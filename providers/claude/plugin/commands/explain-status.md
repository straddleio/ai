---
description: Explain any Straddle status, transition, or error across all entities
argument-hint: "[entity] [status or error]"
---

# Explain Straddle Status

Parse the user's arguments to identify the entity type and the status, transition, or error code they are asking about. If no arguments were provided, ask what entity and status they want explained.

## Supported Entity Types

- **customer** -- statuses: pending, review, verified, inactive, rejected
- **paykey** -- statuses: active, expired, blocked, revoked
- **charge** -- statuses: created, scheduled, pending, paid, failed, reversed, cancelled, on_hold, validating
- **payout** -- statuses: created, scheduled, pending, paid, failed, reversed, cancelled, on_hold
- **funding_event** -- statuses tied to settlement lifecycle
- **account** (Embed) -- statuses tied to onboarding lifecycle (pending, active, suspended, etc.)

## What to Explain

For each status, cover all of the following:

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
- `paid`, `failed`, `reversed`, and `cancelled` are terminal states
- `on_hold` can transition to `released` (back to `scheduled`) or `cancelled`

## ACH Return Codes

If the question involves an ACH return code, explain:

1. **Code and meaning** (e.g., R01 = Insufficient Funds)
2. **Fraud vs operational** -- fraud returns (R05, R07, R10, R11, R29) indicate unauthorized transactions; operational returns (R01, R02, R03, R04) are non-fraud
3. **Paykey impact** -- fraud returns (especially R29) may block the paykey. Check `unblock_eligible` to determine if the paykey can be reactivated.
4. **Recovery path** -- whether the payment can be retried and under what conditions

Common codes:

| Code | Meaning | Type |
|------|---------|------|
| R01 | Insufficient funds | Operational |
| R02 | Account closed | Operational |
| R03 | No account / unable to locate | Operational |
| R04 | Invalid account number | Operational |
| R05 | Unauthorized debit to consumer account | Fraud |
| R07 | Authorization revoked by customer | Fraud |
| R10 | Customer advises originator is not known | Fraud |
| R11 | Check truncation entry return | Fraud |
| R29 | Corporate customer advises not authorized | Fraud |

## Identity Review

If the question involves customer `review` status or identity verification:

- Use the `search_straddle_docs` tool to look up risk score details and thresholds
- Explain that `GET /v1/customers/{id}/review` shows the identity verification scores (fraud, email, address, IP, phone, watchlist)
- Explain that `POST /v1/customers/{id}/decision` is used to approve or reject after review
- Note that 98% of customers clear instantly to `verified`; `review` means one or more risk signals were elevated

## Documentation Links

After explaining the status, use the `search_straddle_docs` tool to find relevant documentation pages. Link to specific guides when available.

## Entity-Specific Notes

**Customer:** Status reflects identity verification outcome. `review` requires manual decision. `rejected` is terminal.

**Paykey:** `active` is the only status that allows payments. `blocked` may be recoverable if `unblock_eligible` is true. `expired` requires the customer to reconnect their bank account.

**Charge/Payout:** Same state machine. Key difference is funding timing -- payouts require Straddle to withdraw from the business account first.

**Funding Event:** Tracks settlement of money after a payment reaches `paid`. Query via `/v1/funding/search`.

**Account (Embed):** Onboarding lifecycle. Use `POST /v1/accounts/{id}/simulate` in sandbox to test different outcomes.
