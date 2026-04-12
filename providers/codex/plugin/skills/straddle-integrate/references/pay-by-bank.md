# Pay by Bank Workflow Reference

## Overview

Pay by Bank is Straddle's core payment product. It processes account-to-account payments with built-in identity verification, balance confirmation, and multi-rail support (ACH, Same-Day ACH, RTP, FedNow).

The standard integration follows 5 steps:

**Platform note:** If `platform_type` is `saas` or `marketplace`, some operations require the `Straddle-Account-Id` header. See <references/embed.md> for which calls need it. The steps below show the direct account flow. For platform-specific code examples with the header, see the embed reference.

1. Create Customer (identity verification)
2. Connect Bank Account (generate Paykey)
3. Create Charge or Payout
4. Monitor Status
5. Reconcile Funding

## Step 1: Create Customer

Create a customer with identity information. Straddle automatically runs KYC/AML verification.

**Required fields:** `name`, `type`, `email`, `phone`, `device.ip_address`

```typescript
const result = await client.customers.create({
  device: { ip_address: '192.168.1.1' },
  email: 'jane@example.com',
  name: 'Jane Doe',
  phone: '+12128675309',
  type: 'individual',
  compliance_profile: { dob: '1990-01-01', ssn: '123-45-6789' }
});
// result.data.id -> customer ID
// result.data.status -> 'pending' | 'review' | 'verified' | 'inactive' | 'rejected'
```

**Status outcomes by customer type:**

- **Individual customers** always go through identity review (compliance requirement). Usually instant, but can require manual decision.
- **Business customers** without `compliance_profile`: automatically go to `verified`. Useful for small businesses without an EIN. Tradeoff: no B2B chargeback protection.
- **Business customers** with `compliance_profile`: standard verification.

**Important: `review` does not block the flow.** Customers in `review` can proceed through the entire pay-by-bank flow -- Bridge, paykey creation, charge/payout creation all work. Downstream objects are placed in `review` or `on_hold` until the customer clears. After the customer is verified, held items release automatically.

**Handling `review` status:**

When a customer lands in `review`, inspect the identity verification results and optionally make a decision:

```
GET /v1/customers/{id}/review    -- inspect risk scores
POST /v1/customers/{id}/decision -- approve or reject
```

## Step 2: Connect Bank Account

Connect the customer's bank account to generate a paykey. Four connection methods are available, including one for platforms with existing third-party integrations.

### Choose a Connection Method

| Scenario | Method | Pros | Cons |
|----------|--------|------|------|
| New customer, best UX | Bridge Widget | Covers 90%+ of US banks, seamless | Requires frontend integration |
| Existing Plaid integration | Plaid token | No re-authentication needed | Limited to Plaid-connected banks |
| Existing Quiltt integration | Quiltt token | No re-authentication needed | Limited to Quiltt-connected banks |
| Customer outside open banking | Manual bank entry | Works for any bank | Higher fraud risk, no balance checks |

### Option A: Bridge Widget (Recommended)

The Bridge Widget is a drop-in UI component that handles bank selection and authentication.

1. Initialize a Bridge session on the server:
```
POST /v1/bridge/session
Body: { "customer_id": "cus_123" }
Response: { "data": { "bridge_token": "..." } }
```

2. Embed the widget in your frontend using the `@straddlecom/bridge` SDK (see the SDK reference for installation and usage details).

3. The widget returns a Paykey on successful bank connection.

### Option B: Plaid Token

If you already have a Plaid processor token for the customer:

```
POST /v1/bridge/plaid
Body: {
  "customer_id": "cus_123",
  "plaid_token": "processor_token_from_plaid"
}
```

### Option C: Quiltt Token

If you already have a Quiltt token for the customer:

```
POST /v1/bridge/quiltt
Body: {
  "customer_id": "cus_123",
  "quiltt_token": "token_from_quiltt"
}
```

### Option D: Manual Bank Entry

For banks not covered by open banking, or for offline scenarios:

```
POST /v1/bridge/bank_account
Body: {
  "customer_id": "cus_123",
  "routing_number": "110000000",
  "account_number": "000123456789",
  "account_type": "checking"
}
```

**Warning:** Manual entry paykeys have higher fraud risk and cannot perform balance checks. Use `balance_check: "disabled"` or `balance_check: "enabled"` (which proceeds if unavailable) when charging against manual paykeys. Do not use `balance_check: "required"` -- it fails.

### After Connection

Extract the `paykey` token from the response. Verify the paykey status is `active` before proceeding to payment creation. Store the paykey securely for reuse.

## Step 3: Create Charge

A charge pulls (debits) funds from the customer's bank account.

**All required fields:**

```json
{
  "paykey": "pk_abc123xyz",
  "amount": 10000,
  "currency": "USD",
  "description": "Monthly subscription",
  "payment_date": "2024-10-01",
  "consent_type": "internet",
  "device": {
    "ip_address": "192.168.1.1"
  },
  "external_id": "charge_12345",
  "config": {
    "balance_check": "enabled"
  }
}
```

**Field notes:**
- `amount` is in cents. 10000 = $100.00.
- `currency` must be `"USD"` (only supported currency).
- `description` appears on the customer's bank statement. Max 80 characters.
- `payment_date` is YYYY-MM-DD format, up to 90 days in the future.
- `consent_type` must match the actual authorization method: `"internet"`, `"signed"`, or `"telephone"`.
- `device.ip_address` is the customer's IP. Use `"0.0.0.0"` only for offline/telephone consent.
- `external_id` is your unique identifier. Used for idempotency -- duplicates within the same account are rejected.

**SDK example:**

```typescript
const result = await client.charges.create({
  amount: 10000,
  paykey: 'pk_abc123xyz',
  currency: 'USD',
  description: 'Monthly subscription',
  external_id: 'charge_12345',
  payment_date: '2024-10-01',
  consent_type: 'internet',
  device: { ip_address: '192.168.1.1' },
  config: { balance_check: 'enabled' }
});
// result.data.id -> charge ID
// result.data.status -> 'created'
```

### Balance Check Modes

| Mode | Behavior | When to Use |
|------|----------|-------------|
| `enabled` | Attempts balance verification; proceeds if unavailable | Default, recommended for most cases |
| `required` | Must verify balance or charge fails | High-value transactions, fraud-sensitive flows |
| `disabled` | No verification attempted | Future-dated charges, manual entry paykeys |

## Step 3b: Create Payout

A payout pushes (credits) funds to the customer's bank account.

**Key difference from charges:** Payouts require Straddle to withdraw from your business account first, then send to the customer. This means there is additional funding timing before the customer receives funds. Charges settle directly to your account.

```typescript
const result = await client.payouts.create({
  amount: 5000,
  paykey: 'pk_abc123xyz',
  currency: 'USD',
  description: 'Vendor payment',
  external_id: 'payout_456',
  payment_date: '2024-01-20',
  device: { ip_address: '192.168.1.1' }
});
// result.data.id -> payout ID
// result.data.status -> 'created'
```

**When to use charges vs payouts:**

| Scenario | Use | Direction |
|----------|-----|-----------|
| Collect payment for goods/services | Charge | Pull from customer |
| Subscription billing | Charge | Pull from customer |
| Refund customer | Payout | Push to customer |
| Marketplace seller payout | Payout | Push to seller |
| Loan disbursement | Payout | Push to borrower |

## Step 4: Monitor Status

### Webhooks (Recommended)

Configure a webhook endpoint to receive real-time status change events:

| Event | When Fired |
|-------|------------|
| `charge.created.v1` | Charge initiated |
| `charge.event.v1` | Charge status changes (scheduled, pending, paid, failed, reversed) |
| `payout.created.v1` | Payout initiated |
| `payout.event.v1` | Payout status changes |

Webhook delivery is via Svix. Your endpoint must return a 2xx status within 15 seconds. Always verify webhook signatures.

### Polling (Fallback)

If webhooks are not available, poll for status updates:

```typescript
const result = await client.charges.get('charge_id');
// result.data.status -> current status
// result.data.status_details -> reason codes for failures
```

Or search across all payments:

```typescript
for await (const payment of client.payments.list({
  status: ['paid'],
  created_from: '2024-01-01'
})) {
  // payment.id, payment.status, payment.type
}
```

### Handling Outcomes

**`paid`:** Payment completed successfully. Proceed to reconciliation.

**`failed`:** Check `status_details.reason` for the cause (e.g., `insufficient_funds`, `closed_bank_account`, `risk_review`). Implement retry logic for transient failures.

**`on_hold`:** System holds (fraud) require dashboard review. User holds can be released via API:
```
PATCH /v1/charges/{id}/release
```

**`reversed`:** Payment was returned after funding (e.g., ACH return). Check the return code for the cause.

## Step 5: Reconcile Funding

After a charge reaches `paid` status, track settlement to your business account:

```typescript
// Query funding events for a specific charge
// GET /v1/funding/search?charge_id=ch_abc123
```

Funding events track the movement of money from the ACH network into your Straddle account. Subscribe to `funding.event.v1` webhooks for real-time settlement notifications.

For payouts, funding events track the withdrawal from your account and the subsequent credit to the customer's account.
