---
name: straddle-setup
description: First-time setup, onboarding, environment configuration, getting started with Straddle, installing SDKs, connecting MCP servers, troubleshooting connection issues
---

# Straddle Setup

This skill covers first-time setup for working with Straddle. Follow the sections in order for a complete setup, or jump to the section you need.

## MCP Server Connection

Straddle provides an MCP server that gives AI agents direct access to the Straddle API. There are three connection methods depending on your environment.

### 1. Remote OAuth (default)

The simplest method. Uses Straddle's hosted MCP server with OAuth authentication. Best for interactive development.

**Claude Code:**

```bash
claude mcp add --transport http straddle https://mcp.straddle.com
```

**Cursor / VS Code (mcp.json):**

```json
{
  "mcpServers": {
    "straddle": {
      "url": "https://mcp.straddle.com"
    }
  }
}
```

On first use, the server initiates an OAuth flow in your browser to authenticate with Straddle.

### 2. API Key (for agents and CI/CD)

For automated environments where interactive OAuth is not available. Uses a separate endpoint that accepts API key authentication via header.

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

Runs the MCP server locally via npx. Useful for offline development or when you need to inspect traffic.

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

## Straddle Docs MCP

A separate, read-only MCP server that searches Straddle product documentation. No authentication required.

```bash
claude mcp add --transport http straddle-docs https://docs.straddle.com/mcp
```

**Cursor / VS Code (mcp.json):**

```json
{
  "mcpServers": {
    "straddle-docs": {
      "url": "https://docs.straddle.com/mcp"
    }
  }
}
```

This server provides documentation search tools. It does not call the Straddle API or require any credentials.

## Straddle CLI

The Straddle CLI gives you full API access from the terminal. Every resource available through the SDKs -- customers, paykeys, charges, payouts, bridge, embed -- is available as a CLI command.

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

Each environment (sandbox, production) has its own set of keys. Keys are not interchangeable between environments.

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

## Verification

After setup, verify everything works with these three checks:

### 1. Test SDK docs search

Ask your AI agent:

> Search the Straddle docs for "paykey"

This confirms the `straddle-docs` MCP server is connected. You should get results about Straddle's Paykey concept.

### 2. Test a code tool

Ask your AI agent:

> List my Straddle customers

This confirms the `straddle` MCP server is connected and authenticated. You should get a response from the Straddle API (even if the customer list is empty in sandbox).

### 3. Test product docs search

Ask your AI agent:

> Search Straddle docs for how to create a charge

This confirms documentation search returns actionable integration guidance. You should see results covering charge creation parameters and the payment flow.

### 4. Test CLI (if installed)

Run:

```bash
straddle charges create --help
```

This confirms the CLI is installed and working. You should see the full list of parameters for creating a charge.

If any check fails, verify the MCP server is registered (`claude mcp list` in Claude Code) and that your API key is set correctly for the environment you are targeting.
