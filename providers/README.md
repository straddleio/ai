# Providers

Each provider directory contains the plugin configuration and synced skills for a specific AI client.

| Provider | Directory | Status | Description |
|----------|-----------|--------|-------------|
| Claude Code / Cowork | `claude/` | Available | Plugin with MCP config, slash commands, and skills |
| Codex | `codex/` | Available | Plugin with MCP config and skills |
| Cursor | `cursor/` | Available | Plugin with MCP config and skills |

## How skills get here

Canonical skill definitions live in `skills/` at the repo root. The sync script (`skills/sync.js`) copies them into each provider's `skills/` directory. Run it after editing any skill:

```bash
node skills/sync.js
```

Commands (slash commands) are provider-specific and live only in the provider that supports them. Currently only the Claude provider has commands (`providers/claude/plugin/commands/`).
