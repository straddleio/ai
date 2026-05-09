# Straddle CLI

Postman environment details omitted from generated CLI artifacts.
# Introduction

Built on REST principles, the Straddle API uses intuitive, resource-oriented URLs and communicates via JSON-encoded request bodies and responses. We employ standard HTTP methods, authentication, and status codes to ensure consistency and predictability.


# Environments

Straddle provides two separate environments to support your development workflow: the **Sandbox** environment for testing and development, and the **Production** environment for live transactions.

| Environment | Base URL                      | Purpose                 |
|-------------|-------------------------------|------------------------|
| Sandbox     | `https://sandbox.straddle.com` | Testing and development |
| Production  | `https://production.straddle.com` | Live transactions       |

**Warning:** Always ensure you're using the correct environment and API keys. Using Sandbox credentials in Production will cause requests to fail and negatively impact the user experience.


# Authentication

Straddle uses Bearer Token authentication via JWT API keys. Include your secret API key in the `Authorization` header of every request:

```bash
curl https://sandbox.straddle.com/v1/customers \
  -H "Authorization: Bearer YOUR_SECRET_API_KEY"
```

### Generate an API Key

Generate an API key from the Straddle Dashboard:

1. Log in to your [Straddle Dashboard](https://dashboard.straddle.com).
2. Navigate to **Developers** > **API Keys**.
3. Click **Create API Key** to generate a new key.

> **Warning:** Your secret API key grants full access to your Straddle account. Keep it secure and **never** share it publicly or include it in client-side code.

### Sandbox and Production Environments

Straddle provides separate API keys for sandbox and production environments:

- **Sandbox API Keys**: Use these keys for development and testing.
- **Production API Keys**: Use these keys in production when you're ready to accept real transactions.

> **Tip:** Always test your integration thoroughly using sandbox API keys before switching to production keys.

### Keep your API keys secure

Follow these guidelines to keep your API keys secure:

1. **Keep Secret Keys Confidential:** Do not share your secret keys in emails, chat messages, or public repositories.
2. **Use Environment Variables:** Store keys securely using environment variables or a secrets management system.
3. **Rotate Keys Regularly:** Periodically rotate your API keys to reduce risk.
4. **Monitor Usage:** Regularly review your API logs in the Dashboard for any suspicious activity.

With authentication and environments configured, you can start making requests to Straddle's API. Keep reading to learn more. 


# Idempotent Requests

Straddle supports idempotent API requests, which means you can safely retry requests without fear of performing the same operation multiple times. This is especially important for operations that change state, like creating a payment, where duplicate requests could lead to financial discrepancies.

Idempotency is achieved by including a unique `Idempotency-Key` header in your HTTP requests. Straddle uses this key to detect and prevent duplicate operations. If a request with a given key has already been successfully processed, Straddle will return the original response without re-executing the operation.


### Request Headers

To make an idempotent API request, include a unique string in the `Idempotency-Key` header. We require a key length of 10-40 characters.

| Header | Type | Description |
|--------|------|-------------|
| `Idempotency-Key` | string | A unique identifier for the request. Must be 10-40 characters long. |

### Response Headers

When an identical request is successfully replayed, the response will include the original HTTP status code, original response headers, and the original response body, with an additional header:

| Header | Type | Description |
|--------|------|-------------|
| `Idempotent-Replayed` | boolean | Set to `true` when the response is a replay of a previous successful request. |

### Idempotency Error Responses

The Straddle will return specific error responses in idempotency-related scenarios:

| Status Code | Error Type | Description |
|-------------|------------|-------------|
| **400** | Bad Request | The `Idempotency-Key` header is invalid (missing or incorrect length). |
| **409** | Conflict | The idempotency key was already used for a different request, or a previous identical request is currently in progress. |

### Idempotency Key Reused for Different Request

If you send a request with an `Idempotency-Key` that was previously used for a different request (e.g., different path, method, or request body), you will receive a `409 Conflict` error.

```json
{
  "status": 409,
  "type": "/conflict",
  "title": "Conflict",
  "detail": "Idempotency key already used for a different request."
}
```

### Concurrent Request in Progress

If you send a request with an `Idempotency-Key` that is currently being processed by another request, you will receive a `409 Conflict` error.

```json
{
  "status": 409,
  "type": "/conflict",
  "title": "Conflict",
  "detail": "Previous identical request currently in progress."
}
```

### Invalid Idempotency Key

If the `Idempotency-Key` header is missing or does not meet the length requirements (10-40 characters), a `400 Bad Request` error will be returned.

```json
{
  "status": 400,
  "type": "/bad-request",
  "title": "Bad Request",
  "detail": "The Idempotency-Key header is invalid. It must be between 10 and 40 characters long."
}
```

### Best Practices

1. **Generate Unique Keys per Business Operation**: For each distinct business operation you initiate, generate a new and unique `Idempotency-Key`. Do not reuse keys across different logical actions.
2. **Use UUIDs**: Universally Unique Identifiers (UUIDs) are an excellent choice for generating idempotency keys due to their high probability of uniqueness.
4. **Handle 409 Conflicts**: Implement logic in your client to properly handle `409 Conflict` responses. For "key already used for a different request," generate a new key. For "previous identical request currently in progress," consider retrying.
5. **Key Length**: Ensure your `Idempotency-Key` is between 10 and 40 characters long.
6. **Avoid Sending Same Key with Different Data**: Never send the same `Idempotency-Key` with a different request body, path, or HTTP method. This will result in a `409 Conflict` error.

### Example Usage

```bash
curl -X POST https://sandbox.straddle.com/v1/charges \
-H "Authorization: Bearer YOUR_API_KEY" \
-H "Content-Type: application/json" \
-H "Idempotency-Key: unique-client-key-7890" \
-d '{
  "amount": 100.00,
  "currency": "USD"
}'
```

Idempotency is currently supported for **POST**, **PUT**, **PATCH** and **DELETE** requests only, and requires API key authentication. 


# Response Structure

The Straddle API provides responses with consistent structure to ensure readability and ease of integration. All API responses follow these conventions to ensure consistency and ease of integration across different client applications.

- **Field Naming**
  - Use `snake_case` for all field names
  - Use descriptive full words, except common acronyms (e.g., `dob`, `SSN`)
  
- **Resource IDs**
  - All IDs are UUIDs for cross-system uniqueness and compatibility
  
- **Response Type (`response_type`)**
  - `"object"`: Single resource response
  - `"array"`: List of resources, typically paginated
  - `"error"`: Error response with details in `error` field
  
- **Primary Data (`data`)**
  - Contains main response payload
  - Holds resource(s) for `"object"` and `"array"` types
  - For `"error"` type, error details go in `error` field
  
- **Meta Information (`meta`)**
  - Standard fields:
    - `api_request_id`: Unique request identifier
    - `api_request_timestamp`: ISO 8601 request time (e.g., `"2023-11-07T05:31:56Z"`)
  - Pagination fields (for `"array"` responses):
    - `page_number`: Current page
    - `page_size`: Items per page
    - `total_items`: Total available items
    - `sort_order`: `"asc"` or `"desc"`
    - `sort_by`: Sort field name

### Examples

#### Single-Object Response

```json
{
  "meta": {
    "api_request_id": "3a2b1c4d-0e6f-4a88-9876-123456abcdef",
    "api_request_timestamp": "2023-11-07T05:31:56Z"
  },
  "response_type": "object",
  "data": {
    "id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "dob": "1990-01-01",
    "address": {
      "street": "123 Main St",
      "city": "Springfield",
      "state": "IL",
      "postal_code": "62701"
    }
  }
}
```

#### Paginated List Response

```json
{
  "meta": {
    "api_request_id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
    "api_request_timestamp": "2023-11-07T05:31:56Z",
    "page_number": 2,
    "page_size": 50,
    "total_items": 500,
    "sort_order": "asc",
    "sort_by": "name"
  },
  "response_type": "array",
  "data": [
    {
      "id": "c1b1b1b1-1b1b-1b1b-1b1b-1b1b1b1b1b1b",
      "name": "John Doe",
      "email": "john.doe@example.com"
    },
    {
      "id": "a9b1b1b1-1b1b-1b1b-1b1b-1b1b1b1b1b1b",
      "name": "Steven Martin",
      "email": "steven.martin@example.com"
    }
  ]
}
```

#### Error Response

```json
{
  "meta": {
    "api_request_id": "f1b1b1b1-1b1b-1b1b-1b1b-1b1b1b1b1b1b"
  },
  "response_type": "error",
  "error": {
    "status": 400,
    "type": "/field_validation",
    "title": "Invalid Input Data",
    "detail": "The request contains invalid field values.",
    "items": [
      {
        "reference": "customer.email",
        "detail": "Email address must be unique."
      }
    ]
  }
}
```

### Best Practices for Handling Responses

1. **Check the `response_type`**: Determine how to parse the response based on the `response_type` field.
2. **Handle Pagination**: Use pagination metadata to navigate through paginated data effectively.
3. **Implement Robust Error Handling**: Examine the `error` object in error responses to understand and address issues.
4. **Log `api_request_id`**: Record the `api_request_id` for each request to assist with troubleshooting and support.
5. **Access Data via `data` Property**: Retrieve the main payload from the `data` property for successful responses.
6. **Synchronize Timestamps**: Use `api_request_timestamp` for event logging and synchronization.
7. **Consistent Parsing Logic**: Apply a consistent parsing strategy across all responses for reliability.
8. **Avoid Sensitive Data in Logs**: When logging responses, ensure that sensitive information is excluded to maintain security.

By adhering to these practices, you can build a robust integration with the Straddle API that gracefully handles various response scenarios.


# Metadata

Metadata allows you to attach custom key-value pairs to Straddle objects like `customers`, `charges`, and `payouts`. Use metadata to store additional information important to your business that isn't captured by Straddle's standard fields.

> **Important:** Do not confuse the `metadata` field with the `meta` object. The `meta` object contains system-level information about the API request, while `metadata` is for custom data you provide.

### Adding Metadata

You can add metadata when creating or updating objects through the Straddle API. Here's how:

#### Adding Metadata When Creating a Customer

Include a `metadata` object in your request:

```json
{
  "name": "John Doe",
  "type": "individual",
  "email": "john@example.com",
  "address": {
    "address1": "123 Main St",
    "address2": null,
    "type": "residential",
    "city": "Springfield",
    "state": "IL",
    "zip": "62701"
  },
  "phone": "+1234567890",
  "external_id": "CUS-123",
  "device": {
    "ip_address": "192.168.1.1"
  },
  "metadata": {
    "order_id": "6735",
    "customer_group": "premium"
  }
}
```

### Tips
- **Use Consistent Keys:** Establish and follow a consistent naming convention for your metadata keys.
- **Keep It Simple:** Store simple key-value pairs. For complex data, store a reference ID in metadata and keep the full data in your own database.
- **Avoid Sensitive Data:** Do not store sensitive information like credit card numbers or social security numbers in metadata.

### Limitations

- Metadata keys and values must be 40 characters or fewer.
- You can have up to 20 key-value pairs in the `metadata` object.

# Embedded Accounts

Platforms building on Embed can make API calls on behalf of their embedded accounts, allowing you to perform actions for your users seamlessly. To issue requests as an embedded account, include the `Straddle-Account-Id` header with the embedded account's ID (prefixed with `acct_`) in each request. You can make API calls for your embedded accounts in two ways:

1. **Server-side**: Use the `Straddle-Account-Id` header with the embedded account ID in each request.
2. **Client-side**: Pass the `Straddle-Account-Id` as an argument when initializing the Straddle client library.

> **Note:** To ensure optimal performance and reliability, Straddle enforces rate limits on API endpoints. These limits apply collectively to all requests made by your platform, including those made on behalf of embedded accounts.

### Server-side Requests Using the `Straddle-Account-Id` Header

When making server-side API calls, include the `Straddle-Account-Id` header with the embedded account's ID to execute requests on their behalf.

#### Example: Creating a Charge

The following example demonstrates how to create a charge using your platform's secret API key and your user's account ID.

```bash
curl --request POST \
  --url https://sandbox.straddle.com/v1/charges \
  --header 'Authorization: Bearer <your-secret-api-key>' \
  --header 'Content-Type: application/json' \
  --header 'Straddle-Account-Id: <uuid>' \
  --data '{
    "paykey": "<string>",
    "description": "<string>",
    "amount": 123,
    "currency": "<string>",
    "payment_date": "2023-12-25",
    "consent_type": "internet",
    "device": {
      "ip_address": "<string>"
    },
    "external_id": "<string>",
    "config": {
      "balance_check": "required"
    },
    "metadata": {}
  }'
```

### Client-side Requests

To make client-side API calls on behalf of an embedded account, pass the embedded account ID when initializing the Straddle client. This feature is *coming soon*.

> **Warning:** Exercise caution when making client-side requests as an embedded account. Ensure you are not exposing sensitive information or providing unnecessary permissions to the client.


# Errors

Straddle uses standard HTTP status codes to indicate the success or failure of API requests. Understanding these codes and how to handle errors will help you build robust and user-friendly applications.

Here is a summary of the HTTP status and error codes that Straddle may return:

| Status Code | Type | Description |
|------------|------|-------------|
| **200** | OK | The request was successful, and the response contains the expected data. |
| **400** | Bad Request | The request was invalid, often due to missing or incorrect parameters. |
| **401** | Unauthorized | No valid API key was provided with the request. |
| **403** | Forbidden | The API key doesn't have the necessary permissions to perform the request. |
| **404** | Not Found | The requested resource does not exist. |
| **409** | Conflict | The request conflicts with another request (e.g., using the same idempotency key). |
| **422** | Unprocessable Entity | The request was well-formed but could not be processed due to semantic errors. |
| **429** | Too Many Requests | Too many requests have been made in a short period of time. Implement exponential backoff and retry later. |
| **500, 502, 503, 504** | Server Errors | Server errors - something went wrong on Straddle's end. These errors are rare. |

| Error Type | Description |
| ---------- | ----------- |
| `invalid_request_error` | Occurs when the request has invalid parameters, such as missing required fields or invalid values. |
| `validation_error` | Occurs when the request data fails Straddle's validation checks, like providing an invalid address or unsupported payment method. |
| `authentication_error` | Occurs when the provided API key is invalid or lacks the necessary permissions for the requested action. |
| `api_error` | Covers any other type of problem, such as temporary issues with Straddle's servers. These errors are rare. |

When an error occurs, Straddle returns an HTTP response with the appropriate status code and a JSON body containing an `error` object with details about the error.

### Error Response Structure

When an error occurs, Straddle returns an HTTP response with the appropriate status code and a JSON body containing an `error` object with details about the error.

The `error` object includes the following attributes:

| Attribute | Type | Description |
|-----------|------|-------------|
| `status` | integer | The HTTP status code returned. |
| `type` | string | A string identifying the type of error. Possible values are `api_error`, `invalid_request_error`, `validation_error`, or `authentication_error`. |
| `title` | string | A short description of the error type. |
| `detail` | string | A detailed message about the error. |
| `items` | array | (Optional) An array of objects providing more specific details about individual errors. |
| `items[].reference` | string | An identifier related to the error, such as a field name or error code. |
| `items[].detail` | string | A detailed description of the specific error. |

### Example Error Response

Here's an example of a validation error response:

```json
{
  "meta": {
    "api_request_id": "3a2b1c4d-0e6f-4a88-9876-123456abcdef",
    "api_request_timestamp": "2023-11-07T05:31:56Z"
  },
  "response_type": "error",
  "error": {
    "status": 400,
    "type": "validation_error",
    "title": "Invalid Input Data",
    "detail": "The request contains invalid field values.",
    "items": [
      {
        "reference": "customer.email",
        "detail": "Email address must be unique."
      }
    ]
  }
}
```

- The error type is `validation_error`, indicating issues with the input data.
- The `items` array provides specific details about which field caused the error. 
#

## Install

The recommended path installs both the `straddle-pp-cli` binary and the `pp-straddle` agent skill in one shot:

```bash
npx -y @mvanhorn/printing-press install straddle
```

For CLI only (no skill):

```bash
npx -y @mvanhorn/printing-press install straddle --cli-only
```


### Without Node

The generated install path is category-agnostic until this CLI is published. If `npx` is not available before publish, install Node or use the category-specific Go fallback from the public-library entry after publish.

### Pre-built binary

Download a pre-built binary for your platform from the [latest release](https://github.com/mvanhorn/printing-press-library/releases/tag/straddle-current). On macOS, clear the Gatekeeper quarantine: `xattr -d com.apple.quarantine <binary>`. On Unix, mark it executable: `chmod +x <binary>`.

<!-- pp-hermes-install-anchor -->
## Install for Hermes

From the Hermes CLI:

```bash
hermes skills install mvanhorn/printing-press-library/cli-skills/pp-straddle --force
```

Inside a Hermes chat session:

```bash
/skills install mvanhorn/printing-press-library/cli-skills/pp-straddle --force
```

## Install for OpenClaw

Tell your OpenClaw agent (copy this):

```
Install the pp-straddle skill from https://github.com/mvanhorn/printing-press-library/tree/main/cli-skills/pp-straddle. The skill defines how its required CLI can be installed.
```

## Quick Start

### 1. Install

See [Install](#install) above.

### 2. Set Up Credentials

Get your access token from your API provider's developer portal, then store it through stdin:

```bash
read -r -s STRADDLE_TOKEN_INPUT
straddle-pp-cli auth set-token --stdin <<<"$STRADDLE_TOKEN_INPUT"
unset STRADDLE_TOKEN_INPUT
```

Supported auth paths:

- `STRADDLE_TOKEN` for shells, CI, and MCP launches that inject credentials through the environment.
- Config-file auth through `auth set-token --stdin`.
- Custom config paths through `--config /path/to/config.toml`, for example `auth set-token --stdin --config /path/to/config.toml`.

The legacy positional token form still works for compatibility, but avoid it. Tokens must not be committed, printed in logs, or passed in argv.

Or set `STRADDLE_TOKEN` through your shell's secure secret flow.

### 3. Verify Setup

```bash
straddle-pp-cli doctor
```

This checks your configuration and credentials.

### 4. Try Your First Command

```bash
straddle-pp-cli accounts list
```

## Usage

Run `straddle-pp-cli --help` for the full command reference and flag list.

## Commands

### account-settings

Manage account settings

- **`straddle-pp-cli account-settings get-settings`** - Get all resolved settings for the specified account, including inherited values from organization, platform, and system defaults.

### accounts

Accounts represent businesses using Straddle through your platform. Each account must complete automated verification before processing payments. Use accounts to manage your users' payment capabilities, track verification status, and control access to features. Accounts can be instantly created in sandbox and require additional verification for production access.

- **`straddle-pp-cli accounts create`** - Creates a new account associated with your Straddle platform integration. This endpoint allows you to set up an account with specified details, including business information and access levels.
- **`straddle-pp-cli accounts get`** - Retrieves the details of an account that has previously been created. Supply the unique account ID that was returned from your previous request, and Straddle will return the corresponding account information.
- **`straddle-pp-cli accounts list`** - Returns a list of accounts associated with your Straddle platform integration. The accounts are returned sorted by creation date, with the most recently created accounts appearing first. This endpoint supports advanced sorting and filtering options.
- **`straddle-pp-cli accounts update`** - Updates an existing account's information. This endpoint allows you to update various account details during onboarding or after the account has been created.

### bridge

Bridge provides a comprehensive suite of tools for connecting customer bank accounts. Use it to generate secure widget sessions for instant account verification, accept tokens from major providers like Plaid and Finicity, or verify accounts directly via our API. Bridge handles all sensitive banking credentials and ensures secure, compliant connections with support for 90% of US bank accounts.

- **`straddle-pp-cli bridge create`** - Creates a new paykey using a Quiltt token as the source. This endpoint allows you to create a secure payment token linked to a bank account authenticated through Quiltt.
- **`straddle-pp-cli bridge create-bank-account-paykey`** - Use Bridge to create a new paykey using a bank routing and account number as the source. This endpoint allows you to create a secure payment token linked to a specific bank account.
- **`straddle-pp-cli bridge create-plaid-paykey`** - Use Bridge to create a new paykey using a Plaid token as the source. This endpoint allows you to create a secure payment token linked to a bank account authenticated through Plaid.
- **`straddle-pp-cli bridge create-speedchex`** - Creates a new paykey using a Speedchex token as the source. This endpoint allows you to create a secure payment token linked to a bank account authenticated through Speedchex.
- **`straddle-pp-cli bridge create-tan`** - Create tan
- **`straddle-pp-cli bridge create-token`** - Use this endpoint to generate a session token for use in the Bridge widget.

### charges

Charges represent attempts to debit money from a customer's bank account using a Paykey. Each charge includes automatic balance verification, real-time fraud screening, and multi-rail optimization and detailed status tracking throughout the payment lifecycle. Use charges to accept bank payments with confidence knowing every transaction is protected.

- **`straddle-pp-cli charges create`** - Use charges to collect money from a customer for the sale of goods or services.
- **`straddle-pp-cli charges get`** - Retrieves the details of an existing charge. Supply the unique charge `id`, and Straddle will return the corresponding charge information.
- **`straddle-pp-cli charges update`** - Change the values of parameters associated with a charge prior to processing. The status of the charge must be `created`, `scheduled`, or `on_hold`.

### customers

Customers represent the end users who send or receive payments through your integration. Each customer undergoes automatic identity verification and fraud screening upon creation. Use customers to track payment history, manage bank account connections, and maintain a secure record of all transactions associated with a user. Customers can be either individuals or businesses with appropriate compliance checks for each type.

- **`straddle-pp-cli customers create`** - Creates a new customer record and automatically initiates identity, fraud, and risk assessment scores. This endpoint allows you to create a customer profile and associate it with paykeys and payments.
- **`straddle-pp-cli customers delete`** - Permanently removes a customer record from Straddle. This action cannot be undone and should only be used to satisfy regulatory requirements or for privacy compliance.
- **`straddle-pp-cli customers get`** - Retrieves the details of an existing customer. Supply the unique customer ID that was returned from your 'create customer' request, and Straddle will return the corresponding customer information.
- **`straddle-pp-cli customers list`** - Lists or searches customers connected to your account. All supported query parameters are optional. If none are provided, the response will include all customers connected to your account. This endpoint supports advanced sorting and filtering options.
- **`straddle-pp-cli customers update`** - Updates an existing customer's information. This endpoint allows you to modify the customer's contact details, PII, and metadata.

### funding-event-payments

Manage funding event payments

- **`straddle-pp-cli funding-event-payments get`** - All the payments that made up the funding event

### funding-events

Funding events represent all money movement between Straddle and an Account's external bank accounts. They are automatically generated when charges settle or payouts are initiated. Each event provides detailed tracking of settlement status, fee breakdowns, and reconciliation data across both incoming and outgoing transfers. Use funding events to monitor your platform's entire money movement lifecycle.

- **`straddle-pp-cli funding-events create`** - Simulate a funding event for testing. This endpoint can only be used in the sandbox environment.
- **`straddle-pp-cli funding-events get`** - Retrieves the details of an existing funding event. Supply the unique funding event `id`, and Straddle will return the individual transaction items that make up the funding event.
- **`straddle-pp-cli funding-events list`** - Retrieves a list of funding events for your account. This endpoint supports advanced sorting and filtering options.

### linked-bank-accounts

Linked bank accounts connect your platform users' external bank accounts to Straddle for settlements and payment funding. Each linked account undergoes automated verification and continuous monitoring. Use linked accounts to manage where clients receive deposits, fund payouts, and track settlement preferences.

- **`straddle-pp-cli linked-bank-accounts create`** - Creates a new linked bank account associated with a Straddle account. This endpoint allows you to associate external bank accounts with a Straddle account for various payment operations such as payment deposits, payout withdrawals, and more.
- **`straddle-pp-cli linked-bank-accounts get`** - Retrieves the details of a linked bank account that has previously been created. Supply the unique linked bank account `id`, and Straddle will return the corresponding information. The response includes masked account details for security purposes.
- **`straddle-pp-cli linked-bank-accounts list`** - Returns a list of bank accounts associated with a specific Straddle account. The linked bank accounts are returned sorted by creation date, with the most recently created appearing first. This endpoint supports pagination to handle accounts with multiple linked bank accounts.
- **`straddle-pp-cli linked-bank-accounts update`** - Updates an existing linked bank account's information. This can be used to update account details during onboarding or to update metadata associated with the linked account. The linked bank account must be in 'created' or 'onboarding' status.

### organizations

Organizations are a powerful feature in Straddle that allow you to manage multiple accounts under a single umbrella. This hierarchical structure is particularly useful for businesses with complex operations, multiple departments, or legally related entities.

- **`straddle-pp-cli organizations create`** - Creates a new organization related to your Straddle integration. Organizations can be used to group related accounts and manage permissions across multiple users.
- **`straddle-pp-cli organizations get-by-id`** - Retrieves the details of an Organization that has previously been created. Supply the unique organization ID that was returned from your previous request, and Straddle will return the corresponding organization information.
- **`straddle-pp-cli organizations list`** - Retrieves a list of organizations associated with your Straddle integration. The organizations are returned sorted by creation date, with the most recently created organizations appearing first. This endpoint supports advanced sorting and filtering options to help you find specific organizations.

### paykeys

Paykeys are secure tokens that link verified customer identities to their bank accounts. Each Paykey includes built-in balance checking, fraud detection through LSTM machine learning models, and can be reused for subscriptions and recurring payments without storing sensitive data. Paykeys eliminate fraud by ensuring the person initiating payment owns the funding account.

- **`straddle-pp-cli paykeys get`** - Retrieves the details of an existing paykey. Supply the unique paykey `id` and Straddle will return the corresponding paykey record , including the `paykey` token value and masked bank account details.
- **`straddle-pp-cli paykeys list`** - Returns a list of paykeys associated with a Straddle account. This endpoint supports advanced sorting and filtering options.

### payments

Payments provide endpoints to filter both Charges and Payouts with multiple different parameters.

- **`straddle-pp-cli payments list`** - Search for payments, including `charges` and `payouts`, using a variety of criteria. This endpoint supports advanced sorting and filtering options.

### payouts

Payouts represent transfers from Straddle to customer bank accounts. Create payouts to handle disbursements, process refunds, or manage marketplace settlements. Use payouts to send money quickly and securely with the most cost-effective rail automatically selected.

- **`straddle-pp-cli payouts create`** - Use payouts to send money to your customers.
- **`straddle-pp-cli payouts get`** - Retrieves the details of an existing payout. Supply the unique payout `id` to retrieve the corresponding payout information.
- **`straddle-pp-cli payouts update`** - Update the details of a payout prior to processing. The status of the payout must be `created`, `scheduled`, or `on_hold`.

### reports

Manage reports

- **`straddle-pp-cli reports create`** - Create

### representatives

Representatives are individuals who have legal authority or significant responsibility within a business entity associated with a Straddle account. Each representative undergoes automated verification as part of KYC/KYB compliance. Use representatives to collect and verify beneficial owners, control persons, and authorized signers required for account onboarding. Representatives also determine who can legally operate the account and make important changes.

- **`straddle-pp-cli representatives create`** - Creates a new representative associated with an account. Representatives are individuals who have legal authority or significant responsibility within the business.
- **`straddle-pp-cli representatives get`** - Retrieves the details of an existing representative. Supply the unique representative ID, and Straddle will return the corresponding representative information.
- **`straddle-pp-cli representatives list`** - Returns a list of representatives associated with a specific account or organization. The representatives are returned sorted by creation date, with the most recently created representatives appearing first. This endpoint supports advanced sorting and filtering options.
- **`straddle-pp-cli representatives update`** - Updates an existing representative's information. This can be used to update personal details, contact information, or the relationship to the account or organization.


## Output Formats

```bash
# Human-readable table (default in terminal, JSON when piped)
straddle-pp-cli accounts list

# JSON for scripting and agents
straddle-pp-cli accounts list --json

# Filter to specific fields
straddle-pp-cli accounts list --json --select id,name,status

# Dry run - show the request without sending
straddle-pp-cli accounts list --dry-run

# Agent mode - JSON + compact + no prompts in one flag
straddle-pp-cli accounts list --agent
```

## Agent Usage

This CLI is designed for AI agent consumption:

- **Non-interactive** - never prompts, every input is a flag
- **Pipeable** - `--json` output to stdout, errors to stderr
- **Filterable** - `--select id,name` returns only fields you need
- **Previewable** - `--dry-run` shows the request without sending
- **Explicit retries** - add `--idempotent` to create retries and `--ignore-missing` to delete retries when a no-op success is acceptable
- **Confirmable** - `--yes` for explicit confirmation of destructive actions
- **Piped input** - write commands can accept structured input when their help lists `--stdin`
- **Offline-friendly** - sync/search commands can use the local SQLite store when available
- **Agent-safe by default** - no colors or formatting unless `--human-friendly` is set

Exit codes: `0` success, `2` usage error, `3` not found, `4` auth error, `5` API error, `7` rate limited, `10` config error.

## Use with Claude Code

Install the focused skill - it auto-installs the CLI on first invocation:

```bash
npx skills add mvanhorn/printing-press-library/cli-skills/pp-straddle -g
```

Then invoke `/pp-straddle <query>` in Claude Code. The skill is the most efficient path - Claude Code drives the CLI directly without an MCP server in the middle.

<details>
<summary>Use as an MCP server in Claude Code (advanced)</summary>

If you'd rather register this CLI as an MCP server in Claude Code, install the MCP binary first:


Install the MCP binary from this CLI's published public-library entry or pre-built release.

Then register it using your client's secure environment-variable flow. Do not put the token value in the command line.

```bash
claude mcp add straddle straddle-pp-mcp
```

</details>

## Use with Claude Desktop

This CLI ships an [MCPB](https://github.com/modelcontextprotocol/mcpb) bundle - Claude Desktop's standard format for one-click MCP extension installs (no JSON config required).

To install:

1. Download the `.mcpb` for your platform from the [latest release](https://github.com/mvanhorn/printing-press-library/releases/tag/straddle-current).
2. Double-click the `.mcpb` file. Claude Desktop opens and walks you through the install.
3. Fill in `STRADDLE_TOKEN` when Claude Desktop prompts you.

Requires Claude Desktop 1.0.0 or later. Pre-built bundles ship for macOS Apple Silicon (`darwin-arm64`) and Windows (`amd64`, `arm64`); for other platforms, use the manual config below.

<details>
<summary>Manual JSON config (advanced)</summary>

If you can't use the MCPB bundle (older Claude Desktop, unsupported platform), install the MCP binary and configure it manually.


Install the MCP binary from this CLI's published public-library entry or pre-built release.

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "straddle": {
      "command": "straddle-pp-mcp",
      "env": {
        "STRADDLE_TOKEN": "<your-key>"
      }
    }
  }
}
```

</details>

## Health Check

```bash
straddle-pp-cli doctor
```

Verifies configuration, credentials, and connectivity to the API.

## Configuration

Config file: `~/.config/straddle-pp-cli/config.toml`

Static request headers can be configured under `headers`; per-command header overrides take precedence.

Environment variables:

| Name | Kind | Required | Description |
| --- | --- | --- | --- |
| `STRADDLE_TOKEN` | per_call | Yes | Set to your API credential. |

## Troubleshooting
**Authentication errors (exit code 4)**
- Run `straddle-pp-cli doctor` to check credentials
- Verify the environment variable is present without printing it: `test -n "$STRADDLE_TOKEN" && echo STRADDLE_TOKEN is set`
**Not found errors (exit code 3)**
- Check the resource ID is correct
- Run the `list` command to see available items

---

Generated by [CLI Printing Press](https://github.com/mvanhorn/cli-printing-press)
