---
name: straddle-setup
description: First-time setup, onboarding, environment configuration, getting started with Straddle, installing SDKs, connecting MCP servers, troubleshooting connection issues
---

# Straddle Setup

This skill covers first-time setup for working with Straddle. Follow the sections in order for a complete setup, or jump to the section you need.

## MCP Server Connection

Straddle provides an MCP server that gives AI agents direct access to the Straddle API. Straddle supports three connection methods depending on your environment.

### 1. Remote OAuth (default)

The simplest method. Uses Straddle's hosted MCP server with OAuth authentication. Best for interactive development.

**Claude Code:**

```bash
claude mcp add --transport http straddle https://mcp.straddle.com/mcp
```

**Cursor / VS Code (mcp.json):**

```json
{
  "mcpServers": {
    "straddle": {
      "url": "https://mcp.straddle.com/mcp"
    }
  }
}
```

On first use, the server initiates an OAuth flow in your browser to authenticate with Straddle.

### 2. API Key (for agents and CI/CD)

For automated environments where interactive OAuth isn't available. Uses a separate endpoint that accepts API key authentication through a header.

**Claude Code:**

```bash
claude mcp add --transport http straddle https://straddle.stlmcp.com/ \
  --header "Authorization: Bearer $STRADDLE_API_KEY"
```

**Cursor / VS Code (mcp.json):**

```json
{
  "mcpServers": {
    "straddle": {
      "url": "https://straddle.stlmcp.com",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

Replace `YOUR_API_KEY` with your actual Straddle API key. Do not commit this configuration to version control.

### 3. Local npx (offline)

Runs the MCP server locally via npx. Useful for offline development or for inspecting traffic.

**Claude Code:**

```bash
claude mcp add straddle -- npx -y @straddlecom/straddle-mcp@latest
```

Requires the `STRADDLE_API_KEY` environment variable to be set in your shell.

**Cursor / VS Code (mcp.json):**

```json
{
  "mcpServers": {
    "straddle": {
      "command": "npx",
      "args": ["-y", "@straddlecom/straddle-mcp@latest"],
      "env": {
        "STRADDLE_API_KEY": "YOUR_API_KEY"
      }
    }
  }
}
```

## Straddle CLI

The Straddle CLI gives you full API access from the terminal. Every resource available through the SDKs (customers, paykeys, charges, payouts, bridge, embed) is available as a CLI command.

```bash
brew install straddleio/tools/straddle
```

Set your API key and confirm it works:

```bash
export STRADDLE_API_KEY=your_sandbox_key
straddle charges create --help
```

The `--help` flag shows available parameters for any command. Use it to explore the API surface:

```bash
straddle --help
straddle paykeys --help
```

Use `--format json` for structured output and `--debug` to see the full HTTP request and response when troubleshooting.

The CLI uses the same API keys and environments as the SDKs.

## API Keys

Straddle API keys are opaque strings. Get them from the Straddle Dashboard:

**Dashboard:** https://dashboard.straddle.com

Each environment (sandbox, production) has its own set of keys. Keys aren't interchangeable between environments.

**Rules:**
- Never commit API keys to version control
- Store keys in environment variables (`STRADDLE_API_KEY`) or a secrets manager
- Rotate keys immediately if exposed
- Sandbox keys only work against the sandbox environment; production keys only work against production

## Environments

| Environment | Base URL | Purpose |
|-------------|----------|---------|
| Sandbox | `https://sandbox.straddle.com` | Testing and development. No real money moves. |
| Production | `https://production.straddle.com` | Live payments. Real money moves. |

Use sandbox for all development and testing. Switch to production only when you are ready to process real payments.

SDK clients accept an `environment` parameter:

```typescript
import Straddle from '@straddlecom/straddle';

const client = new Straddle({
  apiKey: process.env.STRADDLE_API_KEY,
  environment: 'sandbox',  // or 'production'
});
```

## Integration Type

Ask the user what they are building:

- **Direct account:** A single business collecting or sending payments. No sub-merchants, no embedded accounts. This is the simplest integration.
- **SaaS platform:** Software with embedded payments for your clients. Your clients (embedded accounts) own their customers in the Straddle API. Examples: loan servicing, property management, subscription billing software.
- **Marketplace:** A platform connecting buyers with multiple sellers. The platform owns customer relationships directly. Examples: e-commerce marketplace, gig economy, rental platform.

Write the answer to the plugin's `.local.md` file:

```markdown
---
platform_type: account
---
```

Valid values: `account`, `saas`, `marketplace`.

If `.local.md` already exists with a `platform_type`, show the current value and ask if they want to change it.

## Verification

After setup, verify everything works with these checks:

### 1. Test a code tool

Ask your AI agent:

> List my Straddle customers

This confirms the `straddle` MCP server is connected and authenticated. Expect a response from the Straddle API (even if the customer list is empty in sandbox).

### 2. Test CLI (if installed)

Run:

```bash
straddle charges create --help
```

This confirms the CLI is installed and working. The output should show the full list of parameters for creating a charge.

If any check fails, verify the MCP server is registered (`claude mcp list` in Claude Code) and that your API key is set correctly for the environment you are targeting.

## Next steps

Based on integration type:

**Direct account:**
- Ask to plan your integration, or run `/sandbox-test` to test payment flows
- Ask about specific payment operations (charges, payouts, Bridge)

**SaaS platform or marketplace:**
- Ask to plan your integration -- the plan covers Embed onboarding, customer management, and payment flows
- Run `/sandbox-test embed-onboarding` to test the merchant onboarding flow

## Troubleshooting

### OAuth flow does not open a browser

Headless environment (CI, SSH, containers). Switch to the API key connection method:

```bash
claude mcp add --transport http straddle https://straddle.stlmcp.com/ \
  --header "Authorization: Bearer $STRADDLE_API_KEY"
```

### 401 Unauthorized after initial setup

OAuth token expired. Remove and re-add the MCP server:

```bash
claude mcp remove straddle
claude mcp add --transport http straddle https://mcp.straddle.com/mcp
```

### Connection timeout

Firewall or proxy blocking the connection. Try the local npx method:

```bash
claude mcp add straddle -- npx -y @straddlecom/straddle-mcp@latest
```

### MCP server registered but tools not appearing

Restart the editor. MCP servers load on session start.

- Claude Code: start a new session
- Cursor: Developer > Reload Window
- Codex: restart the CLI

### Wrong environment (sandbox vs production)

API keys are environment-specific. A sandbox key returns 401 against production, and a production key returns 401 against sandbox. Check which key is set:

```bash
echo $STRADDLE_API_KEY | head -c 10
```

Sandbox keys start with `sk_test_`, production keys start with `sk_live_`.

### CLI returns "command not found"

Homebrew did not add the binary to PATH. Run:

```bash
brew link straddleio/tools/straddle
```

Or install with Go:

```bash
go install 'github.com/straddleio/straddle-cli/cmd/straddle@latest'
```
