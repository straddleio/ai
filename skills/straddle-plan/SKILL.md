---
name: straddle-plan
description: >-
  This skill should be used when the user asks to "integrate with Straddle",
  "build my Straddle integration", "plan my integration", "walk me through
  Straddle", "set up payments", or wants a guided integration workflow.
  Produces a tailored integration plan based on use case, SDK, and payment needs.
---

## Purpose

Run a guided conversation (5-8 questions) that produces a complete Straddle
integration plan. The plan covers entity mapping, API flows, code examples,
webhook handlers, and compliance notes -- all tailored to the developer's
specific use case and SDK language.

The plan is the artifact the developer uses to build their sandbox integration.

## Scope boundaries

- Execute API calls -> use `sandbox-test`
- Answer ad-hoc integration questions -> use `straddle-integrate`
- Set up MCP/CLI/keys -> use `setup`
- Explain statuses -> use `explain-status`

Point users to the appropriate skill if they ask for something outside scope.

## Reference files

Read before generating each plan section. Shared with `straddle-integrate`:

| Topic | Reference |
|-------|-----------|
| Entities, statuses, webhooks, ACH | <../straddle-integrate/references/domain.md> |
| Embed: onboarding, accounts, headers | <../straddle-integrate/references/embed.md> |
| Pay by Bank: customer, bridge, payments | <../straddle-integrate/references/pay-by-bank.md> |
| SDKs, Bridge Widget, errors | <../straddle-integrate/references/sdk.md> |

## Doc search enforcement

Reference files contain stable structural and behavioral knowledge. Enumerated
factual lists (return codes, event names, numeric limits) have been replaced
with links to authoritative documentation pages.

**Two search tools exist. They return different content:**

| Tool | What it searches | When to use |
|------|-----------------|-------------|
| `search_docs` | SDK and API reference (method signatures, parameters, code examples) | Writing code examples, looking up fields and request shapes. **Always pass `language` param.** |
| `search_straddle_docs` | Product guides (payment lifecycle, compliance, sandbox testing) | Understanding concepts, checking business rules, finding operational guidance |

**Default to `search_docs`** for any code or API question. Use `search_straddle_docs` only for product concepts and compliance.

For EACH section of the output plan:

1. Read the relevant reference file for structural baseline
2. Follow all documentation links in the reference file for current values
3. Use `search_docs` (pass `language` param) for method signatures and code examples
4. Use `search_straddle_docs` for current guides and compliance info
5. Compare all sources. **MCP results win on conflicts** (they are live). Flag discrepancies.

Never generate a plan section from reference files alone. Never guess at enumerated values -- always search or follow the doc links.

**Documentation index:** https://docs.straddle.com/llms.txt -- complete sitemap
of all Straddle documentation pages. Use as a fallback when MCP search doesn't
return the needed content.

## Conversation flow

Ask questions one at a time. Skip conditional questions when they don't apply.

### Step 0: Prerequisites

Recommend (do not gate):

> Before we start, two things that help:
>
> **Straddle CLI** -- full API access from your terminal:
> ```
> brew install straddleio/tools/straddle
> export STRADDLE_API_KEY=your_sandbox_key
> ```
>
> **API key** from the [Straddle Dashboard](https://dashboard.straddle.com).

Proceed to step 1 immediately.

### Step 1: Use case

> What are you building?
> 1. **A single business** that needs to collect or send bank payments
> 2. **A SaaS product** where your clients need payment capabilities
> 3. **A marketplace** connecting buyers with sellers

Store as `use_case`: `account`, `saas`, or `marketplace`.

### Step 2: SDK language

> Which language is your backend?
> 1. TypeScript / Node.js
> 2. Python
> 3. Go
> 4. Ruby
> 5. C# / .NET
> 6. Raw HTTP

Store as `sdk_language`. Map to `search_docs` language param:
typescript, python, go, ruby, http. For C#, the `search_docs` tool does not have a `csharp` option -- use `http` for raw API shapes and supplement with `typescript` examples (the C# SDK follows the same patterns).

After answer, recommend the SDK install command from <../straddle-integrate/references/sdk.md>.

### Step 3: Business context

> Describe your business in 1-2 sentences. What do you do, who are your users, and what payments need to happen?

Free text. Drives entity mapping.

### Step 4: Payment directions

> What payment directions do you need?
> 1. **Charges only** -- pull money from bank accounts
> 2. **Payouts only** -- push money to bank accounts
> 3. **Both**

### Step 5: Customer types

> Who are you transacting with?
> 1. **Individuals** (consumers, people)
> 2. **Businesses** (companies, vendors, contractors)
> 3. **Both**

### Step 6 (saas/marketplace only): Scale

> Roughly how many merchants/sellers at launch?

Skip for `account` use case.

### Step 7: Existing bank linking

> Do you already have a bank linking provider?
> 1. **Yes, Plaid**
> 2. **Yes, Quiltt**
> 3. **No, starting fresh**
> 4. **Not sure**

"No" and "Not sure" -> recommend Bridge widget.

## Plan generation

After all questions, announce:

> Generating your integration plan. Cross-referencing Straddle docs and SDK reference for [language].

Generate each section below. Follow doc search enforcement for every section.
Use the developer's business terms (from step 3) throughout.

### Section 1: Entity mapping

Table mapping their domain concepts to Straddle entities.

- `account`: their business = account holder, their customers = Customer, bank links = Paykey
- `saas`/`marketplace`: their platform = Platform, their merchants = Account (hosted onboarding), their end-users = Customer, bank links = Paykey

### Section 2: Onboarding flow

- `account`: "Not applicable -- account set up via Dashboard."
- `saas`/`marketplace`: Hosted onboarding form. Search SDK docs for embed component. Show code. Explain `platform.id`, `env`, `external.id`. Document status flow: `created` -> `onboarding` -> `active`.

### Section 3: Customer and paykey flow

Search SDK docs for `customers.create` and Bridge setup.

- Create customer with required fields
- Verification by type: individual (always reviewed), business without compliance_profile (auto-verified, no B2B chargeback protection), business with compliance_profile (standard)
- Customers in `review` can proceed (items held until cleared)
- Bank connection based on step 7: Bridge (`@straddlecom/bridge-react` or `bridge-js`), Plaid token, or Quiltt token
- Paykey creation statuses: active, review, rejected
- Verify with CLI: `straddle customers get <id> --format json`, `straddle paykeys list --format json`

### Section 4: Payment flow

Search SDK docs for `charges.create` / `payouts.create`.

- Code examples for applicable payment directions
- `Straddle-Account-Id` header rules per use case (read from embed.md header table)
- Consent type: `internet` for individual, `signed` for B2B
- Authorization guides: https://help.straddle.com/article/authorization-guide, https://help.straddle.com/article/b2b-agreements
- Balance check modes: `enabled` (default), `required` (high-value), `disabled` (future-dated/manual-entry)
- Test with CLI before writing SDK code: `straddle charges create --help` to see required fields, `straddle charges get <id> --debug` to inspect responses

### Section 5: Webhook handler

Search product docs for webhook events and security.

- Events filtered by use case + payment directions
- Status transitions per event (from domain.md lifecycle)
- Terminal status guard with timestamp ordering
- `on_hold`: system holds (Dashboard) vs user holds (release via API)
- Signature verification
- Idempotency: store webhook-id, dedup on replay

### Section 6: Sandbox testing

Search product docs for sandbox guide.

- `sandbox_outcomes` for test scenarios
- `simulate` for account onboarding (saas/marketplace)
- CLI commands for verifying sandbox state:
  - `straddle customers list --environment sandbox --format json`
  - `straddle charges get <id> --environment sandbox --debug`
  - `straddle paykeys list --environment sandbox --format json`
  - Use `--help` on any command to see available parameters
- Link: https://docs.straddle.com/guides/resources/sandbox-paybybank

### Section 7: Pre-Production Checklist

- Idempotency-Key on all POST/PATCH (10-40 chars)
- Webhook signature verification
- Error handling: `error.type`, `error.items[].reference`, log `api_request_id`
- NACHA compliance: consent records, notification emails
- Retry on 429 (no inherent rate limits)
- Address note: account uses `line1`/`postal_code`, customer uses `address1`/`zip` (known, will be unified)
- Use `straddle <resource> <command> --debug` to troubleshoot unexpected API responses

## Delivering the plan

Present the full plan in conversation. Then offer:

> Save this plan to `straddle-integration-plan.md`?

**Revising the plan:**

To revise a section, ask about it. There is no need to restart the full conversation. Re-read the relevant reference files and re-search docs for the updated sections only.

**Next steps:**

> 1. Review the plan -- ask questions or request changes to any section
> 2. Test in sandbox -- try `/sandbox-test` for guided testing
> 3. Explore the [Straddle docs](https://docs.straddle.com) for deep dives
