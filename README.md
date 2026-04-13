# Straddle AI Toolkit

Build payment integrations faster with AI-powered tools for Straddle. Contextual guidance, live API access, and sandbox testing inside your editor.

## Prerequisites

Get a Straddle API key from the [Straddle Dashboard](https://dashboard.straddle.com). Set it as an environment variable:

```bash
export STRADDLE_API_KEY="your-api-key-here"
```

Add this to your shell profile (`~/.zshrc`, `~/.bashrc`, or `~/.config/fish/config.fish`) to persist it across sessions.

## Setup

### Claude Code

Install the plugin. This sets up MCP servers, skills, and slash commands in one step:

```bash
claude plugins marketplace add straddleio/ai
claude plugins install straddle
```

A browser window opens on first use for OAuth. Run `/straddle-setup` after installing.

### Cowork / Claude Desktop

Install the Straddle plugin from the plugin browser. Same plugin as Claude Code.

### Cursor

Add the MCP servers to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "straddle": {
      "url": "https://straddle.stlmcp.com/",
      "headers": { "Authorization": "Bearer YOUR_STRADDLE_API_KEY" }
    }
  }
}
```

### Other MCP clients

[MCP (Model Context Protocol)](https://modelcontextprotocol.io) connects AI agents to external tools and data sources.

One hosted MCP server:

| Server | URL | Auth | What it provides |
|--------|-----|------|------------------|
| **Straddle API** | `https://mcp.straddle.com/mcp` | OAuth | Code execution, SDK docs search |

For clients that don't support OAuth, use `https://straddle.stlmcp.com/` with `Authorization: Bearer YOUR_API_KEY` instead.

### Local MCP

Run the MCP server on your own machine:

```bash
npx -y @straddlecom/straddle-mcp@latest --api-key=$STRADDLE_API_KEY
```

### MCP without the plugin (Claude Code)

If you want just the MCP servers without skills and slash commands:

```bash
# OAuth (opens browser)
claude mcp add --transport http straddle https://mcp.straddle.com/mcp

# Bearer token (for CI/agents)
claude mcp add --transport http straddle https://straddle.stlmcp.com/ \
  --header "Authorization: Bearer $STRADDLE_API_KEY"
```

## CLI

Full API access from your terminal. Built for developers and AI agents.

```bash
brew install straddleio/tools/straddle
```

```bash
# Explore the API
straddle --help
straddle charges create --help

# List customers with structured output
straddle customers list --format json

# Inspect a charge with full HTTP details
straddle charges get ch_123 --debug

# Extract specific fields
straddle customers list --format json --transform 'data.#.{id,name,status}'
```

Interactive terminal gets styled tables. Piped output switches to JSON automatically.

See [CLI docs](https://sdk.straddle.com/api/cli) for the full command reference.

## MCP server configuration

The MCP servers accept flags for transport, environment, code execution, and access control.

### Sandbox vs production

Set `STRADDLE_ENVIRONMENT` to switch between sandbox and production:

```bash
# Sandbox (default)
export STRADDLE_ENVIRONMENT="sandbox"
export STRADDLE_API_KEY="sk_test_..."

# Production
export STRADDLE_ENVIRONMENT="production"
export STRADDLE_API_KEY="sk_live_..."
```

For advanced configuration (transport, code execution, access control, logging), see the [MCP server reference](https://docs.straddle.com/mcp).

## What you get

### Skills

Skills activate automatically based on what you're doing. No slash command needed.

| Skill | When it activates | What it does |
|-------|-------------------|--------------|
| **Setup** | First-time setup, connecting MCP servers, configuring environments | Walks through API key setup, MCP connection, and environment selection |
| **Plan** | Planning a new Straddle integration from scratch | Runs a guided conversation (5-8 questions) that produces a complete integration plan tailored to your use case |
| **Integrate** | Building payment flows, working with Straddle APIs and SDKs | Guides integration decisions: customers, paykeys, charges, payouts, Bridge, Embed, webhooks, ACH returns |

### Commands

| Command | What it does |
|---------|--------------|
| `/straddle-setup` | First-time setup wizard: MCP servers, CLI, environment, integration type |
| `/explain-status` | Explain any Straddle status, transition, or error. Example: `/explain-status charge failed` |
| `/sandbox-test` | Guided sandbox testing scenarios. Example: `/sandbox-test payment-lifecycle` |

Available sandbox test scenarios: `payment-lifecycle`, `payout-flow`, `failures`, `ach-returns`, `funding`, `bridge`, `embed-onboarding`, `webhooks`.

### MCP Tools

| Tool | Server | Description |
|------|--------|-------------|
| Code execution | API MCP | Run code against Straddle's sandbox |
| SDK docs search | API MCP | Search SDK and API reference documentation |
| Product docs search | product-docs skill | Search product guides and tutorials |

## SDKs

| SDK | Package | Repo |
|-----|---------|------|
| TypeScript | [`@straddlecom/straddle`](https://www.npmjs.com/package/@straddlecom/straddle) | [straddleio/straddle-node](https://github.com/straddleio/straddle-node) |
| Python | [`straddle`](https://pypi.org/project/straddle/) | [straddleio/straddle-python](https://github.com/straddleio/straddle-python) |
| Go | `straddle-go` | [straddleio/straddle-go](https://github.com/straddleio/straddle-go) |
| Ruby | [`straddle`](https://rubygems.org/gems/straddle) | [straddleio/straddle-ruby](https://github.com/straddleio/straddle-ruby) |
| C# | [`Straddle`](https://www.nuget.org/packages/Straddle) | [straddleio/straddle-csharp](https://github.com/straddleio/straddle-csharp) |

SDK reference docs: [sdk.straddle.com](https://sdk.straddle.com/api)

## Supported Editors

| Editor | Status | Features |
|--------|--------|----------|
| Claude Code | Available | Plugin with skills, commands, and MCP |
| Cowork | Available | Same plugin as Claude Code |
| Codex | Available | Plugin with skills and MCP |
| Cursor | Available | Skills and MCP |

Additional editor support is in development.

## Community

Join our developer community for help, support, and feedback.

[![Slack](https://img.shields.io/badge/Slack-4A154B?logo=slack&logoColor=white)](https://strddl.co/mmunity)

## Learn more

- [Straddle documentation](https://docs.straddle.com)
- [API reference](https://docs.straddle.com/api-reference)
- [Sandbox testing guide](https://docs.straddle.com/guides/testing)
- [Security policy](SECURITY.md)
- [Contributing](CONTRIBUTING.md)

## License

MIT -- see [LICENSE](LICENSE).
