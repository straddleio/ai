---
name: straddle-integrate
description: >-
  This skill should be used when the user asks to "integrate Straddle",
  "create a customer", "create a charge", "create a payout", "connect a bank
  account", "set up Bridge", "onboard a merchant", "handle ACH returns",
  "check payment status", "use the Straddle SDK", or asks about Straddle
  entities, payment lifecycle, paykeys, webhooks, embed platforms, or the
  Straddle-Account-Id header. Guides integration decisions across all Straddle
  APIs and SDKs.

---

## Context gathering

Check the plugin's `.local.md` for `platform_type` and `sdk_language`. If either is not set, ask before proceeding:

1. **Platform type** (if missing): What are you building -- direct account, SaaS platform, or marketplace?
2. **SDK language** (if missing): Which language/SDK are you using -- TypeScript, Python, Go, Ruby, C#, or raw HTTP?

Use the SDK language to:
- Pass the `language` param when searching SDK docs (`search_docs` tool)
- Write code examples in the correct SDK
- Recommend the right package names and install commands

If the user has not completed initial setup, suggest running `/straddle-setup`.

### `Straddle-Account-Id` header rules

The header follows resource ownership. See <references/embed.md> for code examples.

| Operation | account | saas | marketplace |
|---|---|---|---|
| Customers / Paykeys | No header | Required (embedded account owns them) | No header (platform owns them) |
| Charges / Payouts | No header | Required | Required (attributes to seller) |
| Review / Decision | No header | Required (embedded account reviews) | No header (platform reviews) |
| Embed onboarding (steps 3-6) | N/A | Required (scoped to account being onboarded) | Required (scoped to account being onboarded) |
| Embed orgs + accounts (steps 1-2) | N/A | No header (platform-level) | No header (platform-level) |

### Behavioral rules by `platform_type`

**account:**
- Pay by Bank flow only. Embed is not applicable.
- Never include `Straddle-Account-Id`.

**saas:**
- Before making account-scoped calls, ask which embedded account the user is working with.
- Include `Straddle-Account-Id` header on all customer, paykey, payment, review, and onboarding (steps 3-6) calls.
- Push the hosted onboarding widget. API-based onboarding is a fallback.
- The embedded account reviews its own customers and paykeys.

**marketplace:**
- Customers and paykeys belong to the platform -- no header on those calls.
- Before making payment calls, ask which embedded account (seller) the payment is for.
- Include `Straddle-Account-Id` on charges, payouts, and onboarding (steps 3-6).
- Push the hosted onboarding widget.
- The platform reviews customers and paykeys directly.

## Tool routing

| Need | Tool | Use for |
|------|------|---------|
| Code execution | straddle API MCP | Run API calls, test methods, explore responses |
| SDK reference | `search_docs` MCP tool | Method signatures, parameters, response shapes, code examples. **Always pass `language` param.** |
| Product guides | product-docs skill | Payment guides, sandbox testing, compliance, ACH returns, risk scores. Searches docs.straddle.com via HTTP. |
| Terminal operations | Straddle CLI | Verify resources, test operations, inspect responses, debug API issues. See <references/cli.md> |

## Integration routing

| Building...                    | Reference                     | Covers                                                            |
| ------------------------------ | ----------------------------- | ----------------------------------------------------------------- |
| Payment flow                   | <references/pay-by-bank.md>   | Customer > Bridge > Paykey > Charge/Payout > Funding              |
| Platform / marketplace         | <references/embed.md>         | Organizations, accounts, onboarding, header rules by platform type |
| Entities and lifecycle         | <references/domain.md>        | Status machines, webhooks, ACH, identity, gotchas                 |
| SDK setup and code             | <references/sdk.md>           | All SDKs, TypeScript operations, Bridge Widget SDK, pagination, errors |
| CLI usage and output           | <references/cli.md>           | CLI command structure, output formats, data extraction, debugging         |
| MCP server setup               | <references/mcp-server.md>    | Connection methods, tool filtering, environments, production safety      |

Read the relevant reference file before answering any integration question or writing code.

## Doc search enforcement

Reference files contain stable structural and behavioral knowledge. Enumerated
factual lists (return codes, event names, numeric limits) have been replaced
with links to authoritative documentation pages.

When a reference file links to docs.straddle.com:
1. Search product docs by POSTing to `https://docs.straddle.com/mcp` with `{"jsonrpc":"2.0","method":"tools/call","params":{"name":"search_straddle_docs","arguments":{"query":"YOUR_QUERY"}},"id":1}` and header `Accept: application/json, text/event-stream`
2. If MCP search returns insufficient results, fetch the linked URL directly
3. MCP results and linked pages are authoritative -- they win on conflicts

**Documentation index:** https://docs.straddle.com/llms.txt -- complete sitemap
of all Straddle documentation pages with descriptions. Use as a fallback when
the search does not return the needed content.
