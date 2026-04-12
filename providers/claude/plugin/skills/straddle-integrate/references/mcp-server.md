# MCP Server Reference

## When to use

The `@straddlecom/straddle-mcp` package runs a Model Context Protocol server that exposes Straddle API operations as tools. Use it to give AI coding assistants direct access to the Straddle API -- creating customers, charging payments, managing paykeys, and everything else available through the SDKs.

## Connection methods

Three ways to connect, depending on the environment:

### Remote with OAuth (interactive development)

For Claude Code and other clients that support OAuth login:

```json
{
  "mcpServers": {
    "straddle": { "type": "http", "url": "https://mcp.straddle.com/mcp" }
  }
}
```

Authenticates through a browser-based OAuth flow. Best for local development with human-in-the-loop approval.

### Remote with API key (CI, agents, Cursor)

For headless environments or clients that need static credentials:

```json
{
  "mcpServers": {
    "straddle": {
      "url": "https://straddle.stlmcp.com/",
      "headers": { "Authorization": "Bearer ${STRADDLE_API_KEY}" }
    }
  }
}
```

Uses an API key from environment variables. Required for CI pipelines, autonomous agents, and Cursor.

### Local (offline, traffic inspection)

Run the server locally for offline work or to inspect traffic:

```json
{
  "mcpServers": {
    "straddle": {
      "command": "npx",
      "args": ["-y", "@straddlecom/straddle-mcp@latest"]
    }
  }
}
```

Runs over stdio by default. Add `--transport http --port 3000` to expose over HTTP instead, or `--transport http --socket /tmp/mcp.sock` for a Unix socket.

## Tool filtering

The MCP server exposes every Straddle API operation by default. Use filters to restrict what tools are available. This is critical for production safety -- agents should never have access to destructive operations they do not need.

### By operation type

```bash
npx -y @straddlecom/straddle-mcp@latest --operation read
npx -y @straddlecom/straddle-mcp@latest --operation write
```

`read` exposes only get/list operations. `write` exposes create, update, cancel, and other mutating operations.

### By resource

```bash
# Only expose charge-related tools
npx -y @straddlecom/straddle-mcp@latest --resource "charges"

# Expose everything except embed
npx -y @straddlecom/straddle-mcp@latest --no-resource "embed.*"
```

Resources support wildcards. Use `--resource` to include and `--no-resource` to exclude.

### By tool name

```bash
# Include specific tools
npx -y @straddlecom/straddle-mcp@latest --tool "create_charges" --tool "get_charges"

# Exclude specific tools
npx -y @straddlecom/straddle-mcp@latest --no-tool "cancel_charges"
```

### By tag

```bash
npx -y @straddlecom/straddle-mcp@latest --tag "payments"
npx -y @straddlecom/straddle-mcp@latest --no-tag "admin"
```

### Combining filters

Filters compose. Include filters are additive (union), exclude filters remove from the result:

```bash
# Read-only charges and payouts, but never cancel operations
npx -y @straddlecom/straddle-mcp@latest \
  --operation read \
  --resource "charges" --resource "payouts" \
  --no-tool "cancel_charges" --no-tool "cancel_payouts"
```

### Listing available tools

Use `--list` to see which tools match the current filter set without starting the server:

```bash
npx -y @straddlecom/straddle-mcp@latest --operation read --list
```

## Client compatibility

Adjust tool schemas for specific clients:

```bash
npx -y @straddlecom/straddle-mcp@latest --client claude-code
npx -y @straddlecom/straddle-mcp@latest --client cursor
npx -y @straddlecom/straddle-mcp@latest --client openai-agents
```

For fine-grained control, use `--capability` and `--no-capability` to toggle individual schema adjustments:

```bash
npx -y @straddlecom/straddle-mcp@latest --capability "top-level-unions" --capability "tool-name-length=40"
```

Run `--describe-capabilities` to see all available capability flags and what they do.

## Transport

| Flag | Mode | Use case |
|------|------|----------|
| `--transport stdio` | Standard I/O (default) | Local MCP clients |
| `--transport http --port 3000` | HTTP on a port | Network-accessible server |
| `--transport http --socket /tmp/mcp.sock` | Unix socket | Local inter-process communication |

## Example configurations

**Development sandbox** -- use the local connection (see above) with no filters. All tools available. Sandbox API keys keep production data safe.

**Production read-only dashboard:**

```json
{
  "mcpServers": {
    "straddle": {
      "command": "npx",
      "args": ["-y", "@straddlecom/straddle-mcp@latest", "--operation", "read"]
    }
  }
}
```

**Production with destructive operations blocked:**

```json
{
  "mcpServers": {
    "straddle": {
      "command": "npx",
      "args": [
        "-y", "@straddlecom/straddle-mcp@latest",
        "--no-tool", "cancel_charges",
        "--no-tool", "cancel_payouts",
        "--no-tool", "cancel_paykeys",
        "--no-tool", "delete_customers"
      ]
    }
  }
}
```

**CI/CD agent** -- use the API key connection (see above). For read-only CI checks, use the local variant with `--operation read` instead.

## Full reference

Package: https://www.npmjs.com/package/@straddlecom/straddle-mcp

Run `npx -y @straddlecom/straddle-mcp@latest --help` for all flags.
