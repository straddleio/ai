# Embed Platform Integration Reference

## What Embed Is

Embed is Straddle's white-label solution for platforms (ISVs, vertical SaaS, payment facilitators) to extend payment infrastructure to their merchants. Platforms can offer identity verification, bank connectivity, and payment processing without carrying payment liability.

## Platform Types

| Type | Description | Resource Ownership |
|------|-------------|-----------|
| **SaaS Platform** | Software with embedded payments for clients | Embedded account owns customers |
| **Marketplace** | Platform connecting buyers with multiple sellers | Platform owns customers |

The platform is identified by a **Platform ID** (found in Dashboard > Settings > Company Profile). This is **not** an Organization ID; do not confuse them.

## Onboarding: Hosted vs API

### Hosted Onboarding (Recommended)

The hosted onboarding form handles the entire account setup in a single embedded UI: organization creation, account creation, business profile collection, representative info, bank account linking, capability selection, and onboarding submission. The platform embeds the form.

**This is not the Bridge widget.** Bridge (`@straddlecom/bridge-react`) is for open banking -- customers connecting their bank accounts. Hosted onboarding is a separate iframe/React component for merchant account setup.

Docs:
- https://docs.straddle.com/guides/embed/hosted-onboarding
- https://docs.straddle.com/guides/embed/react-onboarding
- Source/examples: https://github.com/straddleio/embed

```tsx
// React
import EmbedComponent from './StraddleEmbedComponent';
<EmbedComponent platformId="your-platform-id" env="sandbox" />
```

Or iframe with URL params:
- `platform.id` (required): your Platform ID
- `env` (required): `sandbox` or `production`
- `external.id` (optional): your system's unique identifier for the merchant, for cross-referencing

The form collects all business profile data with validated inputs and dropdowns (including industry). Onboarding is doc-free and fast. All accounts go through the flow but the experience is lightweight.

Account status transitions via webhooks: `created` -> `onboarding` -> `active` (or `rejected`). Listen for `account.event.v1` at each stage.

### API Onboarding (Full Control)

For platforms needing complete UX control, the API flow has six steps:

#### Step 1: Create Organization

```
POST /v1/organizations
Body: { "name": "Acme Corp" }
```

#### Step 2: Create Account

```
POST /v1/accounts
Body: {
  "organization_id": "org_123",
  "account_type": "business",
  "access_level": "standard",
  "business_profile": { "name": "Acme Payments", "website": "https://acme.com" }
}
```

Note: `access_level` is required (`"standard"` or `"managed"`). Minimum fields to create are `name` and `website`, but a complete `business_profile` is required before calling `/onboard`.

#### Step 3: Create Representative

```
POST /v1/representatives
Headers: { "Straddle-Account-Id": "acct_123" }
Body: {
  "name": "John Smith", "email": "john@acme.com", "phone": "+12125551234",
  "title": "CEO",
  "compliance_profile": { "dob": "1980-01-15", "ssn": "123-45-6789" },
  "address": { "line1": "456 Business Ave", "city": "Denver", "state": "CO", "postal_code": "80202", "country": "US" }
}
```

#### Step 4: Link Bank Account

```
POST /v1/linked_bank_accounts
Headers: { "Straddle-Account-Id": "acct_123" }
Body: { "routing_number": "110000000", "account_number": "000123456789", "account_type": "checking" }
```

#### Step 5: Request Capabilities

Format is a flat object with each capability type as a key (NOT a `capability_request_items` array):

```typescript
await client.embed.accounts.capabilityRequests.create(accountId, {
  charges: { enable: true, daily_amount: 10000000, max_amount: 5000000, monthly_amount: 50000000, monthly_count: 500 },
  payouts: { enable: true, daily_amount: 10000000, max_amount: 5000000, monthly_amount: 50000000, monthly_count: 500 },
  individuals: { enable: true },
  businesses: { enable: true },
  internet: { enable: true }
});
```

Six capability types: `charges`, `payouts`, `individuals`, `businesses`, `internet`, `signed_agreement`. Payment types require limit fields. Customer or consent types only need `enable: boolean`.

The capability request API is also useful post-onboarding to change limits.

#### Step 6: Initiate Onboarding

Prerequisites: representative, linked bank account, and capability request.

```
POST /v1/accounts/{id}/onboard
Headers: { "Straddle-Account-Id": "acct_123" }
```

## Sandbox Simulation

```
POST /v1/accounts/{id}/simulate
Headers: { "Straddle-Account-Id": "acct_123" }
Body: { "status": "active" }
```

## Key Rules

### Straddle-Account-Id Header by Platform Type

The header scopes API calls to a specific embedded account. Which calls need it depends on who owns the resource. See the full rules table in SKILL.md.

To add the header in any SDK, pass it as an options argument after the request body. See <references/pay-by-bank.md> for complete request body examples.

#### SaaS Platform

The embedded account owns customers. All account-scoped operations need the header:

```typescript
// TypeScript: pass header as second argument to any SDK call
const customer = await client.customers.create(
  { /* request body -- see pay-by-bank.md */ },
  { headers: { 'Straddle-Account-Id': 'acct_123' } }
);

// Same pattern for charges, payouts, review, decision
const charge = await client.charges.create(
  { /* request body */ },
  { headers: { 'Straddle-Account-Id': 'acct_123' } }
);

// Embedded account reviews its own customers
const review = await client.customers.review.get('cus_456', {
  headers: { 'Straddle-Account-Id': 'acct_123' }
});
```

#### Marketplace

The platform owns customers -- no header on customer/paykey calls. Header required on payments to attribute to the seller:

```typescript
// Customers belong to the platform -- NO header
const customer = await client.customers.create({ /* request body */ });

// Platform reviews its own customers -- NO header
const review = await client.customers.review.get('cus_456');

// Payments attributed to seller -- header required
const charge = await client.charges.create(
  { /* request body */ },
  { headers: { 'Straddle-Account-Id': 'acct_seller_789' } }
);
```

### Payment Operations After Onboarding

Once an embedded account is active, all standard Pay by Bank operations work with the `Straddle-Account-Id` header per the rules above.
