---
description: Explain any Straddle status, transition, or error across all entities
argument-hint: "[entity] [status or error]"
---

# Explain Straddle Status

Parse the user's arguments to identify the entity type and the status, transition, or error code they are asking about. If no arguments were provided, ask what entity and status they want explained.

## Supported Entity Types

- **customer** -- statuses: pending, review, verified, inactive, rejected
- **paykey** -- statuses: active, review, rejected, blocked, inactive, expired
- **charge** -- statuses: created, scheduled, pending, paid, failed, reversed, cancelled, on_hold, validating
- **payout** -- statuses: created, scheduled, pending, paid, failed, reversed, cancelled, on_hold
- **funding_event** -- statuses tied to settlement lifecycle
- **account** (Embed) -- statuses tied to onboarding lifecycle (pending, active, suspended, etc.)

## What to Explain

For each status, cover the following:

1. **Meaning** -- what this status indicates
2. **Cause** -- how the entity reached this status
3. **Transitions** -- what statuses come before and after this one
4. **Terminal vs recoverable** -- whether this is a final state or can change
5. **Next action** -- what the developer or user should do

## Payment Status Machine

For charges and payouts, reference this state machine:

```
created -> scheduled -> pending -> paid
                                -> failed
                     -> on_hold -> released -> scheduled
                                -> cancelled
                        paid    -> reversed
```

Key rules:
- Once a payment reaches `pending`, it cannot be modified, held, released, or cancelled
- `failed`, `reversed`, and `cancelled` are terminal states
- `paid` can still transition to `reversed` (ACH return after settlement)
- `on_hold` can transition to `released` (back to `scheduled`) or `cancelled`

## Status Details

When a payment fails or reverses, `status_details` explains why:

- `reason` -- human-readable category (e.g., `insufficient_funds`, `account_closed`, `unauthorized`)
- `message` -- detailed explanation of what happened
- `code` -- raw return code when applicable (e.g., `R01`)

Search Straddle docs for the current list of status reason codes and their meanings. Do not rely on hardcoded lists -- reason codes are maintained in the documentation.

Key distinctions:
- **Operational reasons** (insufficient funds, closed account, invalid account) -- non-fraud, often retryable
- **Unauthorized reasons** (unauthorized debit, authorization revoked, customer advises not known) -- fraud-related, may block the paykey

When explaining a status, always show the full `status_details` object and explain each field.

## Identity Review

If the question involves customer `review` status or identity verification:

- Use the `search_straddle_docs` tool to look up current risk score details, thresholds, and scoring categories
- Explain that `GET /v1/customers/{id}/review` shows the identity verification scores
- Explain that `POST /v1/customers/{id}/decision` is used to approve or reject after review
- Note that 98% of customers clear instantly to `verified`; `review` means one or more risk signals were elevated

## Documentation Links

After explaining the status, use the `search_straddle_docs` tool to find relevant documentation pages. Link to specific guides when available.

## Entity-Specific Notes

**Customer:** Status reflects identity verification outcome. `review` requires manual decision. `rejected` is terminal.

**Paykey:** `active` is the only status that allows payments. `blocked` may be recoverable if `unblock_eligible` is true. `expired` requires the customer to reconnect their bank account.

**Charge/Payout:** Same state machine. When a payment reaches `failed` or `reversed`, check `status_details` for the reason. The `reason` field categorizes the cause, `message` provides detail, and `code` gives the raw return code when applicable. Use `search_straddle_docs` to look up specific reason codes.

**Funding Event:** Tracks settlement of money after a payment reaches `paid`. Query via `/v1/funding/search`.

**Account (Embed):** Onboarding lifecycle. Use `POST /v1/accounts/{id}/simulate` in sandbox to test different outcomes.
