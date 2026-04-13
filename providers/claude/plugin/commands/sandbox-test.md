---
description: Guide through Straddle sandbox testing scenarios
argument-hint: "[scenario]"
---

# Straddle Sandbox Testing

If the user provided a scenario argument, jump directly to that scenario. Otherwise, present the list of available scenarios and ask which one to run.

## General Rules

- All testing happens in sandbox (`https://sandbox.straddle.com`). Never use production for testing.
- Use the MCP `straddle` code tool for live execution against the sandbox API.
- Explain each API response as it comes back. Do not silently move to the next step.
- If a status is unexpected, use `/explain-status` to diagnose.
- Generate unique `external_id` values for each test run to avoid idempotency collisions.
- Always include `Idempotency-Key` headers on POST/PATCH requests.

## Documentation Sources

Before walking through any scenario, search product docs for current sandbox simulation parameters:

- Pay by Bank sandbox guide: https://docs.straddle.com/guides/resources/sandbox-paybybank
- Platform sandbox guide: https://docs.straddle.com/guides/resources/sandbox-platform

Search product docs by POSTing to `https://docs.straddle.com/mcp` to find the current `sandbox_outcomes` parameter values and simulation mechanisms. Do not guess simulation parameters -- always verify against current documentation.

## Available Scenarios

1. **payment-lifecycle** -- Full charge from created through paid
2. **payout-flow** -- Payout with funding timing explanation
3. **failures** -- Simulated insufficient funds, closed account, risk review
4. **ach-returns** -- Simulated ACH returns (R01, R02, R05, R07, R10, R29)
5. **funding** -- Query funding events after settlement
6. **bridge** -- Bridge token and paykey creation
7. **embed-onboarding** -- Full Embed account onboarding flow
8. **webhooks** -- Webhook testing with Svix

---

## 1. payment-lifecycle

Walk through the full charge lifecycle: customer creation through payment completion.

**Steps:**

1. **Create a customer** with test identity data. Confirm status reaches `verified`.
2. **Connect a bank account** via manual entry (routing: `110000000`, account: `000123456789`, type: `checking`). Extract the paykey.
3. **Create a charge** for $100 (amount: 10000, currency: USD). Use `consent_type: "internet"` and today's date as `payment_date`.
4. **Check charge status.** Walk through each transition: `created` -> `scheduled` -> `pending` -> `paid`.
5. Explain what happened at each stage and what webhooks would fire.

Expected status progression: `created` -> `scheduled` -> `pending` -> `paid`

## 2. payout-flow

Walk through a payout and explain the funding timing difference from charges.

**Steps:**

1. Use an existing customer and paykey, or create new ones (same as payment-lifecycle steps 1-2).
2. **Create a payout** for $50 (amount: 5000). Explain that payouts require Straddle to withdraw from the business account first, then send to the customer.
3. **Check payout status** and walk through the transitions.
4. Explain the funding timing difference: charges settle directly to the business account, payouts require a two-step funding process.

## 3. failures

Search product docs by POSTing to `https://docs.straddle.com/mcp` for "sandbox outcomes" to find the current simulation parameters before walking through each failure scenario.

Test failure scenarios to verify error handling.

**Scenarios to walk through:**

- **Insufficient funds:** Create a charge that triggers an NSF failure. Check `status_details.reason` for `insufficient_funds`.
- **Closed account:** Demonstrate how a closed account return manifests.
- **Risk review:** Create a charge that gets placed `on_hold` for risk review. Show how to release or cancel a held payment.

For each failure:
1. Create the payment
2. Show the failure response
3. Explain what `status_details` contains
4. Explain recovery options (retry, different paykey, manual review)

## 4. ach-returns

Search product docs by POSTing to `https://docs.straddle.com/mcp` for "sandbox ACH returns" to find how to simulate specific return codes in sandbox.

Walk through ACH return code scenarios.

**Return codes to cover:**

| Code | Meaning | Fraud? |
|------|---------|--------|
| R01 | Insufficient funds | No |
| R02 | Account closed | No |
| R05 | Unauthorized debit to consumer | Yes |
| R07 | Authorization revoked | Yes |
| R10 | Customer advises not known | Yes |
| R29 | Corporate customer not authorized | Yes |

For each return:
1. Explain what triggers this return in production
2. Show the payment status after the return (`failed` or `reversed` depending on timing)
3. Explain paykey impact (fraud returns may block the paykey)
4. For fraud returns: explain that R29 blocks the paykey and check `unblock_eligible`

## 5. funding

Query funding events to understand settlement.

**Steps:**

1. Use a charge that has reached `paid` status (create one if needed).
2. Query funding events for that charge via `/v1/funding/search`.
3. Explain the funding event fields and what they mean for reconciliation.
4. Show how `funding.event.v1` webhooks correspond to these events.

## 6. bridge

Test the Bridge integration for bank account connectivity.

**Steps:**

1. Create a customer (or use existing).
2. **Create a Bridge session** via `POST /v1/bridge/session` with the customer ID. Extract the `bridge_token`.
3. Explain that in a real integration, this token is passed to the `@straddlecom/bridge-react` or `@straddlecom/bridge-js` frontend SDK to render the bank connection widget.
4. **Alternative: manual bank entry** via `POST /v1/bridge/bank_account` with test routing/account numbers.
5. Verify the paykey is returned and its status is `active`.

Also cover Plaid and Quiltt token exchange if the user has existing integrations with those providers.

## 7. embed-onboarding

Walk through the full Embed account onboarding flow.

**Steps:**

1. **Create an organization** via `POST /v1/organizations`.
2. **Create an account** via `POST /v1/accounts` with the organization ID.
3. **Create a representative** via `POST /v1/representatives` with identity data and the `Straddle-Account-Id` header.
4. **Link a bank account** via `POST /v1/linked_bank_accounts` with the `Straddle-Account-Id` header.
5. **Request capabilities** via `POST /v1/capability_requests` (request `charges` capability).
6. **Initiate onboarding** via `POST /v1/accounts/{id}/onboard`.
7. **Simulate approval** via `POST /v1/accounts/{id}/simulate` with `{ "status": "active" }`.
8. **Test a scoped payment** -- create a customer and charge using the `Straddle-Account-Id` header to confirm the embedded account is operational.

Remind the user that all account-scoped operations require the `Straddle-Account-Id` header.

## 8. webhooks

Set up and test webhook delivery with Svix.

**Steps:**

1. Explain the Svix webhook infrastructure and available event types:
   - `charge.created.v1`, `charge.event.v1`
   - `payout.created.v1`, `payout.event.v1`
   - `funding.event.v1`
   - `customer.event.v1`
   - `paykey.event.v1`
   - `account.event.v1`
2. Guide through configuring a webhook endpoint (use a tool like webhook.site or a local tunnel for testing).
3. Create a charge to trigger webhook delivery.
4. Explain webhook signature verification and why it matters in production.
5. Explain retry behavior: Svix retries for 15 seconds, endpoint must return 2xx.
6. Show polling via `GET /v1/payments/search` as a fallback if webhooks are missed.
