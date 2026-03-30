# Straddle AI Plugin

## What this repo is

Claude Code plugin repo for Straddle payment infrastructure. Provides skills, slash commands, and MCP server configuration for AI coding assistants.

Core principle: **architectural knowledge in files, enumerated facts via live docs/MCP**.

## Directory layout

```
skills/                              # Canonical skill source (edit here)
  sync.js                            # Copies skills/ to providers/*/plugin/skills/
  setup/SKILL.md                     # First-time setup skill
  straddle-plan/SKILL.md             # Guided integration planning skill
  straddle-integrate/                # Integration guidance skill
    SKILL.md
    references/                      # Stable architectural knowledge
      domain.md                      # Entities, status machines, webhooks, ACH
      embed.md                       # Embed platform integration
      pay-by-bank.md                 # Payment flow walkthrough
      sdk.md                         # SDK operations and patterns
providers/
  claude/plugin/                     # Claude Code plugin
    .claude-plugin/plugin.json       # Plugin manifest
    .mcp.json                        # MCP servers (OAuth + docs)
    commands/                        # Slash commands (Claude-only)
    skills/                          # Synced from skills/ -- DO NOT EDIT
  cursor/plugin/                     # Cursor plugin
    .cursor-plugin/plugin.json
    mcp.json                         # MCP servers (Bearer token + docs)
    skills/                          # Synced from skills/ -- DO NOT EDIT
  gemini/                            # Coming soon
  vscode/                            # Coming soon
scripts/
  shared.js                          # Constants shared by sync.js and validate.js
  validate.js                        # Structural validation
.claude-plugin/
  marketplace.json                   # Plugin marketplace manifest
```

## How things connect

### Skills (canonical: `skills/`)

Each skill is a directory with `SKILL.md` and optional `references/` files.

SKILL.md requires YAML frontmatter with `name` and `description`. The `description` uses third-person trigger phrases for AI routing (e.g. "This skill should be used when the user asks to...").

**NEVER edit skills in `providers/*/plugin/skills/`.** Edit in `skills/`, then run `npm run sync`.

### Commands (provider-specific: `providers/claude/plugin/commands/`)

Each command is a `.md` file with YAML frontmatter (`description` required, `argument-hint` optional). Commands are Claude-only -- no sync step needed, other providers don't support slash commands.

### Reference files (`skills/*/references/`)

Contain stable architectural and behavioral knowledge. Use `<path>` syntax for cross-references, resolved relative to the skill root directory (where SKILL.md lives), not the file containing the link.

Enumerated facts (return codes, limits, event names) link to docs.straddle.com instead of being embedded. AI agents search MCP docs for current values.

### MCP servers

- `providers/claude/plugin/.mcp.json` -- OAuth (`mcp.straddle.com/mcp`) + docs
- `providers/cursor/plugin/mcp.json` -- Bearer token (`straddle.stlmcp.com`) + docs

### Marketplace

- `.claude-plugin/marketplace.json` at repo root -- marketplace discovery manifest
- `providers/claude/plugin/.claude-plugin/plugin.json` -- actual plugin manifest

## How to add a new skill

1. Create `skills/<skill-name>/SKILL.md` with `name` and `description` frontmatter
2. Optionally add `skills/<skill-name>/references/*.md`
3. Run `npm run sync`
4. Run `npm run validate`
5. Commit both canonical and synced copies

## How to add a new command

1. Create `providers/claude/plugin/commands/<command-name>.md`
2. Add YAML frontmatter with `description` (and optional `argument-hint`)
3. No sync step -- commands are provider-specific

## How to add a new provider

1. Create `providers/<name>/plugin/` with provider-specific manifest and MCP config
2. Add target path to `SYNC_TARGETS` in `skills/sync.js`
3. Run `npm run sync`

## Conventions

- Directories and files: kebab-case
- No package dependencies -- scripts use Node.js builtins only

## Testing changes

```bash
npm run sync       # Sync canonical skills to all providers
npm run validate   # Check sync consistency, frontmatter, and references
npm test           # Alias for validate
```

