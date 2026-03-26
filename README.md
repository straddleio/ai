# Straddle AI

AI-native integrations for Straddle's payment infrastructure. Plugins, MCP servers, skills, and agent toolkits.

## Prerequisites

Get a Straddle API key from the [Straddle Dashboard](https://dashboard.straddle.com). Set it as an environment variable:

```bash
export STRADDLE_API_KEY="your-api-key-here"
```

Add this to your shell profile (`~/.zshrc`, `~/.bashrc`, or `~/.config/fish/config.fish`) to persist it across sessions.

## Connect to Straddle's MCP Server

Two MCP servers:

| Server | URL | Auth | What it provides |
|--------|-----|------|------------------|
| **Straddle API** | `https://mcp.straddle.com/mcp` | OAuth | Code execution, SDK docs search |
| **Straddle Docs** | `https://docs.straddle.com/mcp` | None | Product docs search |

For clients that don't support OAuth, use the Bearer token endpoint instead: `https://straddle.stlmcp.com/` with `Authorization: Bearer YOUR_API_KEY`.

### Claude Code

Install the Straddle plugin (includes MCP servers, skills, and slash commands):

```bash
claude plugins marketplace add straddleio/ai
claude plugins install straddle
```

The plugin connects via OAuth -- a browser window opens on first use. Run `/straddle-setup` after installing to complete configuration.

Or add just the MCP servers without the plugin:

```bash
# API MCP with OAuth (opens browser to authenticate)
claude mcp add --transport http straddle https://mcp.straddle.com/mcp

# API MCP with Bearer token (for CI/agents, requires STRADDLE_API_KEY env var)
claude mcp add --transport http straddle https://straddle.stlmcp.com/ \
  --header "Authorization: Bearer $STRADDLE_API_KEY"

# Docs MCP (no auth required)
claude mcp add --transport http straddle-docs https://docs.straddle.com/mcp
```

### Cursor

Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "straddle": {
      "url": "https://straddle.stlmcp.com/",
      "headers": { "Authorization": "Bearer YOUR_STRADDLE_API_KEY" }
    },
    "straddle-docs": { "url": "https://docs.straddle.com/mcp" }
  }
}
```

### Claude Desktop / Cowork

Install the Straddle plugin from the plugin browser, or add the MCP servers manually in Settings > MCP.

### Other MCP clients

Point any MCP-compatible client at the server URLs above. Use `https://mcp.straddle.com/mcp` if your client supports OAuth, or `https://straddle.stlmcp.com/` with a Bearer token if it doesn't.

### Local MCP

Run the Straddle MCP server locally using the npm package:

```bash
npx -y @straddlecom/straddle-mcp@latest --api-key=$STRADDLE_API_KEY
```

## Straddle CLI

```bash
brew install straddleio/tools/straddle
```

The CLI reads `STRADDLE_API_KEY` from your environment, or pass it per-command:

```bash
straddle customers list --environment sandbox
straddle charges create --environment sandbox --help
```

See [CLI docs](https://docs.straddle.com/sdks/cli) for details.

## What you get

### Skills

Skills activate automatically based on what you're doing. No slash command needed.

| Skill | When it activates | What it does |
|-------|-------------------|--------------|
| **Setup** | First-time setup, connecting MCP servers, configuring environments | Walks through API key setup, MCP connection, and environment selection |
| **Integration** | Building payment flows, working with Straddle APIs and SDKs | Guides integration decisions: customers, paykeys, charges, payouts, Bridge, Embed, webhooks, ACH returns |
| **Build** | Planning a new Straddle integration from scratch | Runs a guided conversation (5-8 questions) that produces a complete integration plan tailored to your use case |

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
| Product docs search | Docs MCP | Search product guides and tutorials |

## SDKs

| SDK | Package | Repo |
|-----|---------|------|
| TypeScript | [`@straddlecom/straddle`](https://www.npmjs.com/package/@straddlecom/straddle) | [straddleio/straddle-node](https://github.com/straddleio/straddle-node) |
| Python | [`straddle`](https://pypi.org/project/straddle/) | [straddleio/straddle-python](https://github.com/straddleio/straddle-python) |
| Go | `straddle-go` | [straddleio/straddle-go](https://github.com/straddleio/straddle-go) |
| Ruby | [`straddle`](https://rubygems.org/gems/straddle) | [straddleio/straddle-ruby](https://github.com/straddleio/straddle-ruby) |
| C# | [`Straddle`](https://www.nuget.org/packages/Straddle) | [straddleio/straddle-csharp](https://github.com/straddleio/straddle-csharp) |
| CLI | `brew install straddleio/tools/straddle` | [straddleio/straddle-cli](https://github.com/straddleio/straddle-cli) |

SDK reference docs: [sdk.straddle.com](https://sdk.straddle.com/api)

## Supported Editors

| Editor | Status | Features |
|--------|--------|----------|
| Claude Code | Available | Plugin with skills, commands, and MCP |
| Cowork | Available | Same plugin as Claude Code |
| Cursor | Available | MCP and skills |
| Gemini | Coming soon | |
| VS Code | Coming soon | |

## Learn More

- [Straddle documentation](https://docs.straddle.com)
- [API reference](https://docs.straddle.com/api-reference)
- [Sandbox testing guide](https://docs.straddle.com/guides/testing)
- [Contributing](CONTRIBUTING.md)

## License

MIT -- see [LICENSE](LICENSE).
