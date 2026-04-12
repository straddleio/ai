---
description: Set up Straddle MCP server, CLI, and API keys
---

# Straddle Setup

Walk through each section below. Skip any step the user has already completed. On re-run, check status of each step first and only act on what is missing.

## 1. MCP Server Connection

Run `/mcp` to list connected MCP servers. Check for both `straddle` and `straddle-docs`.

**If `straddle` is missing**, add it:

```bash
claude mcp add --transport http straddle https://mcp.straddle.com/mcp
```

On first use this initiates an OAuth flow in the browser. For non-interactive environments (CI, agents), use the API key method instead:

```bash
claude mcp add --transport http straddle https://straddle.stlmcp.com/ \
  --header "Authorization: Bearer $STRADDLE_API_KEY"
```

**If `straddle-docs` is missing**, add it:

```bash
claude mcp add --transport http straddle-docs https://docs.straddle.com/mcp
```

This is a read-only documentation search server. No authentication required.

## 2. Straddle CLI

Run `which straddle` to check if the CLI is installed.

**If missing**, install via Homebrew:

```bash
brew install straddleio/tools/straddle
```

Verify it works:

```bash
straddle --help
```

The CLI gives full API access from the terminal -- every resource available through the SDKs is available as a command. Use `--help` on any command to explore.

## 3. Environment and API Key

Ask the user which environment they are working with:

- **Sandbox** (`https://sandbox.straddle.com`) -- testing, no real money
- **Production** (`https://production.straddle.com`) -- live payments

If they do not have an API key, direct them to the Straddle Dashboard: https://dashboard.straddle.com

Key rules:
- Sandbox keys only work with the sandbox URL
- Production keys only work with the production URL
- Never commit keys to version control
- Store in environment variables (`STRADDLE_API_KEY`) or a secrets manager

## 4. Integration Type

Ask the user what they are building:

- **Direct account** -- A single business collecting or sending payments. No sub-merchants, no embedded accounts. This is the simplest integration.
- **SaaS platform** -- Software with embedded payments for your clients. Your clients (embedded accounts) own their customers in the Straddle API. Examples: loan servicing, property management, subscription billing software.
- **Marketplace** -- A platform connecting buyers with multiple sellers. The platform owns customer relationships directly. Examples: e-commerce marketplace, gig economy, rental platform.

Write the answer to the plugin's `.local.md` file:

```markdown
---
platform_type: account
---
```

Valid values: `account`, `saas`, `marketplace`.

If `.local.md` already exists with a `platform_type`, show the current value and ask if they want to change it.

## 5. Verification

Use the MCP `straddle` server to list customers. This confirms authentication and connectivity. Even an empty list in sandbox is a successful result.

If the call fails:
- Check the MCP server is registered (`/mcp`)
- Verify the API key matches the target environment
- For OAuth: re-authenticate by removing and re-adding the MCP server

Then use the `search_straddle_docs` tool to search for "paykey". This confirms the docs MCP server is connected.

## 6. Next Steps

Once setup is verified, suggest based on integration type:

**Direct account:**
- Run `/sandbox-test` to walk through payment testing scenarios
- Ask about specific payment flows (charges, payouts, Bridge integration)

**SaaS platform or Marketplace:**
- Start with Embed onboarding: create an Organization and Account, then use the hosted onboarding widget
- Run `/sandbox-test` after onboarding to test payments with the `Straddle-Account-Id` header
- Ask about the Embed integration flow for your platform type
