# Straddle Domain Reference

## What Straddle Is

Straddle is a payment infrastructure platform for account-to-account (A2A) payments. It is the coordination layer between software platforms and payment rails, providing identity verification, bank account connectivity, and payment processing through a unified API.

Straddle combines three capabilities that are normally separate services:
1. **Identity verification** (KYC/AML) via Straddle ID
2. **Bank account connectivity** via Bridge (open banking)
3. **Payment processing** via Pay by Bank (ACH, Same-Day ACH, RTP, FedNow)

Base URLs:
- Sandbox: `https://sandbox.straddle.com`
- Production: `https://production.straddle.com`

Authentication: Bearer token in `Authorization` header.

## Core Entities

| Entity | Purpose | Key Fields |
|--------|---------|------------|
| **Customer** | End-user in payment flow | `name`, `type` (individual/business), `email`, `phone`, `device.ip_address` |
| **Paykey** | Secure token linking identity to bank account | `paykey`, `status`, `bank_data`, `expires_at` |
| **Charge** | Debit (pull) from customer bank account | `paykey`, `amount`, `currency`, `description`, `payment_date`, `consent_type` |
| **Payout** | Credit (push) to customer bank account | `paykey`, `amount`, `currency`, `description`, `payment_date` |
| **Funding Event** | Settlement of payment to business account | `charge_id`/`payout_id`, `amount`, `status` |
| **Account** (Embed) | Business entity within a platform | `organization_id`, `name`, `type` |
| **Organization** (Embed) | Container for multiple accounts | `name` |

## The Paykey

A Paykey is Straddle's core innovation: a secure token linking a verified identity to a validated bank account.

**Lifecycle:**
1. Customer is created (KYC/AML runs automatically)
2. Bank account is connected via Bridge
3. Paykey is generated, combining the identity with the validated bank account
4. All subsequent payments reference the Paykey

**Key fields:** `paykey` (token string), `status`, `bank_data`, `expires_at`, `account_holder_name_match`.

**Creation statuses:** On creation, a paykey lands in one of:
- `active` -- bank validated, ready for payments
- `review` -- name mismatch between customer and account holder, or recent NSF history
- `rejected` -- bad bank account (invalid routing/account number)

**Important: customers in `review` can still proceed.** The entire pay-by-bank flow works regardless of customer verification status. If a customer is in `review`, they can connect via Bridge, get a Paykey, and have charges/payouts created -- but those downstream objects will be placed in `review` or `on_hold` until the customer clears. Once verified, held items release and move forward automatically.

**Post-creation transitions:** Active paykeys can transition to `blocked` (e.g., R29 ACH return), `inactive`, or `expired`.

**Important behaviors:**
- Paykeys expire after a set period. Always check `expires_at` before processing.
- Paykeys can be blocked (e.g., after an R29 ACH return) and unblocked if `unblock_eligible` is true.
- Store paykeys securely and reuse them for recurring payments against the same bank account.

## Payment Status Lifecycle

```
created -> scheduled -> pending -> paid
                                -> failed
                     -> on_hold -> released -> scheduled
                                -> cancelled
                        paid    -> reversed
```

| Status | Modifiable? | Description |
|--------|-------------|-------------|
| `created` | Yes | Initial state, awaiting verification |
| `scheduled` | Yes | Verified, queued for processing |
| `pending` | **NO** | Sent to network -- cannot be modified, held, released, or cancelled |
| `paid` | No | Successfully completed. Can still transition to `reversed`. |
| `failed` | No | Declined before funding (terminal) |
| `reversed` | No | Returned after funding (terminal) |
| `cancelled` | No | Stopped before network submission (terminal) |
| `on_hold` | Depends | Paused for review; can be released or cancelled |

**Terminal statuses:** `failed`, `reversed`, `cancelled`. These are the only truly final states. `paid` is NOT terminal -- it can transition to `reversed` (e.g., ACH return after settlement).

**Critical rule:** Once a payment reaches `pending`, it cannot be modified, held, released, or cancelled. Plan cancellation logic before this point.

## Identity and Risk

Straddle ID runs identity verification automatically when a customer is created. Multiple risk checks are performed across identity, fraud, and compliance dimensions.

For the current list of check types, score meanings, and interpretation guidance:
- Risk models: https://docs.straddle.com/guides/identity/models
- Reason codes: https://docs.straddle.com/guides/identity/reasons

Customer status outcomes after verification:
- `verified` -- cleared, ready for payments
- `review` -- flagged for manual review; use `/v1/customers/{id}/review` to inspect scores, then `/v1/customers/{id}/decision` to approve or reject
- `rejected` -- failed verification

**Verification behavior by customer type:**
- **Individual customers** always go through identity review (compliance requirement). Review is usually instant but can require manual decision.
- **Business customers** without `compliance_profile`: automatically go to `verified`. This is useful for small businesses without an EIN. Tradeoff: you lose B2B chargeback protection (no identity verification on file).
- **Business customers** with `compliance_profile`: go through standard verification.

**Email uniqueness:** Enforced by default. A hidden setting exists that Straddle can enable to allow duplicate customer emails for certain B2B flows. Not recommended for most use cases.

## Webhooks

Straddle delivers webhook events via Svix.

For the current list of event types and delivery behavior:
- Event types: https://docs.straddle.com/webhooks/overview/events
- Webhook fundamentals: https://docs.straddle.com/webhooks/overview/101
- Full Svix event catalog: https://www.svix.com/event-types/us/org_2n72kASOjdYaDUyohRqiT6VQURc/

**Behavioral rules (stable):**
- Webhook delivery order is NOT guaranteed. Always use event timestamps for ordering, not arrival order.
- Your endpoint must return a 2xx HTTP status promptly to confirm receipt.
- If webhooks are missed, use polling as a fallback.
- Always verify webhook signatures. Never trust unsigned webhooks in production.

## ACH Domain Knowledge

Straddle operates as a third-party sender in the ACH network.

Straddle abstracts raw ACH return codes into human-friendly status reason messages. Some returns indicate unauthorized transactions (fraud), others indicate account issues (NSF, closed, invalid).

**Guidance for integrators:** Surface all return information to the business user -- transparency informs them how to cure the issue. Do not hide fraud returns from the platform's end user (the merchant/business). Only hide details from the consumer whose bank returned the transaction.

For payment status flows and reason messages:
- https://docs.straddle.com/guides/payments/statuses

For raw ACH return codes and compliance thresholds:
- https://docs.straddle.com/help/nacha-rules/ach-return

For SEC codes and their use cases:
- https://docs.straddle.com/help/Payment-Compliance/sec-codes

### Consent Types

| Type | Requirement | Use For |
|------|-------------|---------|
| `internet` | Customer authorized online (web/app) | Individual/consumer payments (B2C) |
| `signed` | Customer signed a written authorization/contract | B2B payments (agreements, work orders, invoices) |
| `telephone` | Customer authorized via recorded phone call | Phone-based authorization |

The consent type MUST match how the customer actually authorized the payment. Mismatches cause ACH returns and compliance violations.

For marketplaces: use `internet` for consumer-to-business charges, `signed` for B2B payouts (the business presumably has some form of agreement). Straddle can help with boilerplate authorization language.

For consent type requirements and authorization language guidance:
- https://docs.straddle.com/help/Payment-Compliance/consent-types

### Payment Rails

Straddle automatically selects the optimal rail. You do not choose the rail directly. Available rails include ACH, Same-Day ACH, RTP, and FedNow (availability varies).

For current rail availability, speed, limits, and characteristics:
- https://docs.straddle.com/help/ACH101/same-day-vs-standard-ach
- https://docs.straddle.com/guides/paybybank

## Common Gotchas

- **Balance check `required` can fail.** If the paykey was created via manual entry or the bank does not provide balance data, the charge fails. Use `enabled` (the default) for better UX.
- **Paykeys expire.** Check `expires_at` before processing. Handle expiration gracefully.
- **External ID must be unique.** Use `external_id` for idempotency. Duplicates within the same account are rejected.
- **Always send Idempotency-Key.** Include on all POST/PATCH requests to prevent duplicate operations. Must meet length requirements.
- **Payout funding timing differs.** Payouts require Straddle to withdraw from your account first, then send to the customer. Charges settle directly to your account.
- **Device IP is required.** Always include the customer's IP address. Use `0.0.0.0` only for offline/phone consent.
- **Response data is nested.** All response data is under the `data` property, not at the root level.
- **USD only.** Only USD is currently supported.
- **Future dating limit.** Payment date has a future dating limit. See docs for current value.
- **Metadata limits.** Metadata has key-value pair and character limits. See docs for current values.
- **Sandbox vs production keys.** Each environment has its own keys. Sandbox keys only work with the sandbox URL, production keys only work with the production URL.
- **Embed header varies by platform type.** SaaS platforms: header required on customers, paykeys, payments, reviews, and onboarding steps 3-6. Marketplaces: header required only on payments and onboarding steps 3-6. Direct accounts: never used. See SKILL.md header rules table.
- **No inherent rate limits.** The API returns 429 if overwhelmed but there are no pre-configured per-key or per-account limits.
- **Address field inconsistency.** Account addresses use `line1`/`postal_code`, Customer addresses use `address1`/`zip`. This is a known inconsistency that will be unified in a future API version.
- **Error parsing.** Use `error.type` and `error.items[].reference` for specific field errors. Log `api_request_id` for support.

For current numeric limits and format requirements:
- Metadata: https://docs.straddle.com/api-reference/metadata
- Idempotency: https://docs.straddle.com/api-reference/idempotency
