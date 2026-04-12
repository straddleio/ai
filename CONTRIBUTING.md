# Contributing

Contributions are welcome. Open issues and pull requests at [github.com/straddleio/ai](https://github.com/straddleio/ai).

See [CLAUDE.md](CLAUDE.md) for project architecture and conventions.

## Setup

```bash
npm run sync       # Sync canonical skills to all providers
npm run validate   # Check sync consistency, frontmatter, and references
npm test           # Alias for validate
```

## Skills

Canonical skill files live in `skills/`. After any change, run `npm run sync` to propagate to all providers. Never edit skills directly in `providers/*/plugin/skills/` -- those are synced copies.

Each skill is a directory with a `SKILL.md` file and optional `references/` directory. SKILL.md requires YAML frontmatter with `name` and `description`.

## Commands

Commands are provider-specific. Claude commands live in `providers/claude/plugin/commands/`. Each command is a `.md` file with YAML frontmatter (`description` required, `argument-hint` optional). No sync step needed.

## Adding a provider

1. Create a new directory under `providers/` (e.g., `providers/windsurf/plugin/`).
2. Add the provider's manifest and MCP configuration files.
3. Add the provider as a sync target in `scripts/shared.js`.
4. Run `npm run sync` to populate skills.

## Providers

| Provider | Status |
|----------|--------|
| Claude Code / Cowork | Available |
| Codex | Available |
| Cursor | Available |
