# SDK Reference

## Available SDKs

| Language | Package | Install |
|----------|---------|---------|
| TypeScript/Node.js | `@straddlecom/straddle` | `npm install @straddlecom/straddle` |
| Python | `straddle` | `pip install straddle` |
| Ruby | `straddle` | `gem install straddle` |
| C# | `straddle` | `dotnet add package straddle` |
| Go | `straddle-go` | `go get github.com/straddleio/straddle-go` |

## MCP Tool Interaction Model

When using Straddle through an MCP server, the AI agent calls tools that map to SDK operations. The MCP tools handle authentication, request construction, and response parsing. The agent does not make raw HTTP calls -- it invokes typed tool functions that correspond to the SDK methods documented below.

## Bridge Widget SDK

The Bridge Widget is a drop-in UI component for connecting **customer** bank accounts (open banking). It is not for merchant/account onboarding -- that uses the hosted onboarding form (see embed reference).

Source: https://github.com/straddleio/straddle-bridge-client

**Packages:**
| Package | Use |
|---------|-----|
| `@straddlecom/bridge-react` | React applications |
| `@straddlecom/bridge-js` | Vanilla JavaScript |
| `@straddlecom/bridge-core` | Core utilities/types (not for direct use) |

The Bridge Widget handles the following tasks:
- Bank selection and search (open banking)
- Manual bank entry (routing + account number) as fallback
- Customer authentication with the bank
- Account selection
- Paykey generation on success

Usage requires a Bridge session token from the server-side `POST /v1/bridge/session` call. See the Pay by Bank reference for the full connection flow.

## TypeScript SDK Operations

### Initialize Client

```typescript
import Straddle from '@straddlecom/straddle';

const client = new Straddle({
  apiKey: process.env.STRADDLE_API_KEY,
  environment: 'sandbox',                 // or 'production'
});
```

### Create Customer

```typescript
const result = await client.customers.create({
  device: { ip_address: '192.168.1.1' },
  email: 'user@example.com',
  name: 'John Doe',
  phone: '+12128675309',
  type: 'individual',
  compliance_profile: { dob: '1990-01-01', ssn: '123-45-6789' }
});
// Returns: { data: { id, status, email, name, phone, type, created_at, ... }, meta, response_type }
// Key fields: data.id (string), data.status ('pending'|'review'|'verified'|'inactive'|'rejected')
```

### List Customers

```typescript
// Auto-pagination
for await (const customer of client.customers.list({ status: ['verified'], page_size: 50 })) {
  // customer: { id, name, email, phone, status, type, created_at, external_id? }
}

// Manual pagination
const page = await client.customers.list({ page_number: 1, page_size: 50 });
// Returns: { data: Array<customer>, meta: { page_number, page_size, total_items, total_pages, ... } }
```

### Get Customer

```typescript
const result = await client.customers.get('customer_id');
// Returns: { data: { id, email, name, phone, status, type, address?, compliance_profile?, metadata?, ... }, meta, response_type }
```

### List Paykeys

```typescript
for await (const paykey of client.paykeys.list({ customer_id: 'cust_123', status: ['active'] })) {
  // paykey: { id, paykey, label, status, source, institution_name?, bank_data?, balance?, ... }
}
// Key fields: data[].paykey (token string), data[].status, data[].label
```

### Create Charge

```typescript
const result = await client.charges.create({
  amount: 10000,           // cents (10000 = $100.00)
  paykey: 'pk_xxx',
  currency: 'USD',
  description: 'Monthly subscription',
  external_id: 'order_123',
  payment_date: '2024-01-15',
  consent_type: 'internet',
  device: { ip_address: '192.168.1.1' },
  config: { balance_check: 'enabled' }
});
// Returns: { data: { id, amount, status, paykey, payment_date, ... }, meta, response_type }
// data.status: 'created'|'scheduled'|'failed'|'cancelled'|'on_hold'|'pending'|'paid'|'reversed'|'validating'
```

### Create Payout

```typescript
const result = await client.payouts.create({
  amount: 5000,            // cents
  paykey: 'pk_xxx',
  currency: 'USD',
  description: 'Vendor payment',
  external_id: 'payout_456',
  payment_date: '2024-01-20',
  device: { ip_address: '192.168.1.1' }
});
// Returns: { data: { id, amount, status, paykey, payment_date, ... }, meta, response_type }
```

### List Payments (Charges + Payouts)

```typescript
for await (const payment of client.payments.list({ status: ['paid'], created_from: '2024-01-01' })) {
  // payment: { id, amount, type, status, external_id, payment_date, ... }
}
// Returns paginated results combining charges and payouts
```

### Refresh Paykey Balance

```typescript
const result = await client.paykeys.updateBalance('paykey_id');
// Refreshes the paykey's balance data
// Returns: { data: { balance: { status, account_balance?, updated_at? }, ... }, meta, response_type }
```

### Get Charge

```typescript
const result = await client.charges.get('charge_id');
// Returns: { data: { id, amount, status, status_details, status_history, effective_at?, processed_at?, ... }, meta, response_type }
```

### Get Paykey

```typescript
const result = await client.paykeys.get('paykey_id');
// Returns: { data: { id, paykey, label, status, bank_data?, balance?, customer_id?, ... }, meta, response_type }
// bank_data: { account_number (masked), account_type, routing_number }
```

## Pagination Patterns

All list endpoints return paginated results.

### Auto-Pagination

Auto-pagination iterates through all pages automatically.

```typescript
for await (const item of client.customers.list()) {
  // processes every item across all pages
}
```

### Manual Pagination

Manual pagination gives you more control over page fetching.

```typescript
let page = await client.customers.list({ page_number: 1, page_size: 50 });
// process page.data (array of items)
while (page.hasNextPage()) {
  page = await page.getNextPage();
  // process next page.data
}
```

### Response Shape

All list responses follow this structure:

```typescript
{
  data: Array<T>,
  meta: {
    page_number: number,
    page_size: number,
    total_items: number,
    total_pages: number
  }
}
```

## Error Handling

```typescript
try {
  await client.charges.create(params);
} catch (err) {
  if (err instanceof Straddle.APIError) {
    // err.status: 400 | 401 | 403 | 404 | 422 | 429 | 5xx
    // err.name: 'BadRequestError' | 'AuthenticationError' | 'PermissionDeniedError' |
    //           'NotFoundError' | 'UnprocessableEntityError' | 'RateLimitError' | 'InternalServerError'
  }
}
```

The following list describes common status codes.
- **400** BadRequestError -- invalid request format or parameters
- **401** AuthenticationError -- missing or invalid API key
- **403** PermissionDeniedError -- key lacks required permissions
- **404** NotFoundError -- resource does not exist
- **422** UnprocessableEntityError -- valid format but business logic rejection
- **429** RateLimitError -- too many requests

## Response Structure

All API responses follow a consistent envelope:

```typescript
{
  data: T | Array<T>,           // the resource(s)
  meta: {
    api_request_id: string,     // unique request identifier (log this for support)
    api_request_timestamp: string,
    // ... plus pagination fields for list responses
  },
  response_type: 'object' | 'array' | 'error' | 'none'
}
```

Access the resource via `result.data`. Never look for fields at the root level.

## Optional Headers

All SDK operations accept optional headers for cross-cutting concerns:

```typescript
// Idempotency -- prevents duplicate operations on retry
params['Idempotency-Key'] = 'unique_key_10_to_40_chars';

// Correlation -- links related requests for debugging
params['Correlation-Id'] = 'your_trace_id';

// Embed account scoping -- rules vary by platform type (see SKILL.md table)
params['Straddle-Account-Id'] = 'acct_123';
```

**Idempotency-Key:** Include on all POST/PATCH requests. Must be 10-40 characters. If a request with the same key was already processed, the original response is returned instead of creating a duplicate.

**Correlation-Id:** Optional trace ID that appears in logs and webhook payloads. Useful for end-to-end request tracing.

**Straddle-Account-Id:** Scopes the request to a specific embedded account. Which operations require it depends on platform type (SaaS vs marketplace). See the header rules table in SKILL.md and <references/embed.md> for details.
