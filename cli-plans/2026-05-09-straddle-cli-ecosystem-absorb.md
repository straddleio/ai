# Phase 1.5 Ecosystem Absorb Gate

## Scope

This artifact catalogs the local Straddle AI ecosystem before any next CLI implementation slice. It does not authorize implementation code changes.

Rules followed:

- Worktree: `/Users/js/clawd/straddle/straddle-ai`.
- No browser use.
- No production API calls.
- No provider synced skill copies used as canonical input.
- No implementation code edited.

## Source Evidence

- Master workflow: `cli-plans/2026-05-09-straddle-cli-full-workflow.md` defines Phase 1.5 as the ecosystem catalog gate.
- Repo rules: `AGENTS.md:1` through `AGENTS.md:37` define this repo as the Straddle AI plugin source and say `skills/` is canonical.
- Provider synced skill copies are not source: `AGENTS.md:55` through `AGENTS.md:60`.
- Commands are provider specific: `AGENTS.md:62` through `AGENTS.md:65`.
- Current validation wires generated CLI checks into root validation: `scripts/validate.js:254` through `scripts/validate.js:263`.

## MCP Configs And Manifests

Relevant MCP configs:

| Path | What it does | Evidence |
|---|---|---|
| `providers/claude/plugin/.mcp.json` | Claude provider MCP config. Uses hosted Straddle HTTP MCP. | `providers/claude/plugin/.mcp.json:2` through `providers/claude/plugin/.mcp.json:3` |
| `providers/codex/plugin/.mcp.json` | Codex provider MCP config. Uses hosted Straddle HTTP MCP. | `providers/codex/plugin/.mcp.json:2` through `providers/codex/plugin/.mcp.json:3` |
| `providers/cursor/plugin/mcp.json` | Cursor provider MCP config. Uses the `straddle.stlmcp.com` hosted MCP URL. | `providers/cursor/plugin/mcp.json:2` through `providers/cursor/plugin/mcp.json:4` |
| `packages/cli/straddle-pp-cli/manifest.json` | Generated MCP package manifest for the Printing Press MCP binary. | `packages/cli/straddle-pp-cli/manifest.json:2` through `packages/cli/straddle-pp-cli/manifest.json:18` |

Relevant plugin manifests:

| Path | What it does | Evidence |
|---|---|---|
| `.claude-plugin/marketplace.json` | Claude marketplace discovery manifest for this repo. | `.claude-plugin/marketplace.json:2` through `.claude-plugin/marketplace.json:12` |
| `.agents/plugins/marketplace.json` | Codex marketplace discovery manifest for this repo. | `.agents/plugins/marketplace.json:2` through `.agents/plugins/marketplace.json:8` |
| `providers/claude/plugin/.claude-plugin/plugin.json` | Claude plugin manifest. | `providers/claude/plugin/.claude-plugin/plugin.json:2` through `providers/claude/plugin/.claude-plugin/plugin.json:5` |
| `providers/codex/plugin/.codex-plugin/plugin.json` | Codex plugin manifest. | `providers/codex/plugin/.codex-plugin/plugin.json:2` through `providers/codex/plugin/.codex-plugin/plugin.json:20` |
| `providers/cursor/plugin/.cursor-plugin/plugin.json` | Cursor plugin manifest. | `providers/cursor/plugin/.cursor-plugin/plugin.json:2` through `providers/cursor/plugin/.cursor-plugin/plugin.json:6` |
| `packages/cli/straddle-pp-cli/.printing-press.json` | Generated CLI provenance, source spec path, checksum, and MCP binary name. | `packages/cli/straddle-pp-cli/.printing-press.json:10` through `packages/cli/straddle-pp-cli/.printing-press.json:14` |

Absorbed implications:

- The existing hosted MCP configs are plugin integration surfaces, not the generated Printing Press MCP binary.
- The generated MCP manifest already expects a sensitive `STRADDLE_TOKEN` user config and launches `bin/straddle-pp-mcp`.
- The next implementation slice should not create a second MCP command tree. It should extend or document the generated CLI and generated MCP relationship.
- MCP count evidence is now resolved. `packages/cli/straddle-pp-cli/.printing-press.json:15` records 70 generated endpoint tools, `packages/cli/straddle-pp-cli/internal/mcp/tools.go` has 73 typed tools after adding `search`, `sql`, and `context`, and runtime `tools/list` exposes 80 tools after seven Cobra shell-out tools are registered, including `docs_search`. Phase 4 now validates this source count invariant.

## Canonical Skills

Canonical skill source is under `skills/`, not under provider synced copies.

| Skill | Canonical path | Capability to absorb | Evidence |
|---|---|---|---|
| `product-docs` | `skills/product-docs/SKILL.md` | Product guide search through docs endpoint, with API reference delegated to `search_docs` MCP. | `skills/product-docs/SKILL.md:2` through `skills/product-docs/SKILL.md:10`, `skills/product-docs/SKILL.md:35` through `skills/product-docs/SKILL.md:43` |
| `setup` | `skills/setup/SKILL.md` | First time setup, MCP registration, environment checks, token handling guidance, CLI troubleshooting. | `skills/setup/SKILL.md:1` through `skills/setup/SKILL.md:10`, `skills/setup/SKILL.md:210` through `skills/setup/SKILL.md:253` |
| `straddle-integrate` | `skills/straddle-integrate/SKILL.md` | Integration routing across API MCP, SDK docs, product docs, and terminal CLI. | `skills/straddle-integrate/SKILL.md:2` through `skills/straddle-integrate/SKILL.md:12`, `skills/straddle-integrate/SKILL.md:59` through `skills/straddle-integrate/SKILL.md:79` |
| `straddle-plan` | `skills/straddle-plan/SKILL.md` | Guided integration plan flow and cross reference requirements. | `skills/straddle-plan/SKILL.md:2` through `skills/straddle-plan/SKILL.md:8`, `skills/straddle-plan/SKILL.md:19` through `skills/straddle-plan/SKILL.md:28` |

Reference files to absorb:

- `skills/straddle-integrate/references/cli.md`, CLI usage, output, and debugging reference.
- `skills/straddle-integrate/references/mcp-server.md`, MCP connection methods, filtering, transport, and safety.
- `skills/straddle-integrate/references/domain.md`, product entities, statuses, webhooks, ACH domain notes.
- `skills/straddle-integrate/references/embed.md`, hosted onboarding, account scoping, and sandbox simulation.
- `skills/straddle-integrate/references/pay-by-bank.md`, customer, Bridge, Paykey, charge, and payout flow.
- `skills/straddle-integrate/references/sdk.md`, SDK packages, Bridge SDK, pagination, error handling, response shape, headers.

## Slash Commands

Slash commands are canonical only under `providers/claude/plugin/commands/`. These are provider specific command docs, not synced skill copies.

| Command doc | Capability to absorb | Evidence |
|---|---|---|
| `providers/claude/plugin/commands/explain-status.md` | Explain entity statuses, transitions, status details, identity review, and docs links. | `providers/claude/plugin/commands/explain-status.md:1` through `providers/claude/plugin/commands/explain-status.md:17`, `providers/claude/plugin/commands/explain-status.md:47` through `providers/claude/plugin/commands/explain-status.md:55` |
| `providers/claude/plugin/commands/product-docs.md` | Thin command wrapper that runs the product docs skill. | `providers/claude/plugin/commands/product-docs.md:1` through `providers/claude/plugin/commands/product-docs.md:6` |
| `providers/claude/plugin/commands/sandbox-test.md` | Guided sandbox scenarios for payment lifecycle, payouts, failures, ACH returns, funding, Bridge, Embed onboarding, and webhooks. | `providers/claude/plugin/commands/sandbox-test.md:1` through `providers/claude/plugin/commands/sandbox-test.md:15`, `providers/claude/plugin/commands/sandbox-test.md:28` through `providers/claude/plugin/commands/sandbox-test.md:149` |
| `providers/claude/plugin/commands/straddle-setup.md` | First time setup route. | `providers/claude/plugin/commands/straddle-setup.md:1` through `providers/claude/plugin/commands/straddle-setup.md:4` |

Absorbed implications:

- `explain-status` should become a CLI workflow candidate only if it can be backed by local reference text plus current docs lookup, not a hardcoded status encyclopedia.
- `sandbox-test` is a required source for future sandbox walkthroughs, but live execution should stay optional and sandbox-safe.
- `product-docs` overlaps with generated CLI `search`, but the current generated `search` is local synced data search, not docs search.

## Generated CLI Command Roots

The generated CLI root is `packages/cli/straddle-pp-cli/internal/cli/root.go`. It registers 28 top-level command roots.

Core API roots:

- `accounts`, with create, get, list, update, capability requests, onboard, and simulate children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/accounts.go:12` through `packages/cli/straddle-pp-cli/internal/cli/accounts.go:22`.
- `bridge`, with create, bank account, Plaid, Speedchex, TAN, and token children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/bridge.go:12` through `packages/cli/straddle-pp-cli/internal/cli/bridge.go:21`.
- `charges`, with create, get, update, cancel, hold, release, resubmit, and unmask children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/charges.go:12` through `packages/cli/straddle-pp-cli/internal/cli/charges.go:23`.
- `customers`, with create, delete, get, list, update, refresh review, review, and unmasked children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/customers.go:12` through `packages/cli/straddle-pp-cli/internal/cli/customers.go:23`.
- `funding-events`, with create, get, and list children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/funding-events.go:12` through `packages/cli/straddle-pp-cli/internal/cli/funding-events.go:18`.
- `linked-bank-accounts`, with create, get, list, update, cancel, and unmask children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/linked-bank-accounts.go:12` through `packages/cli/straddle-pp-cli/internal/cli/linked-bank-accounts.go:21`.
- `organizations`, with create, get by id, and list children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/organizations.go:12` through `packages/cli/straddle-pp-cli/internal/cli/organizations.go:18`.
- `paykeys`, with get, list, cancel, refresh balance, refresh review, reveal, review, unblock, and unmasked children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/paykeys.go:12` through `packages/cli/straddle-pp-cli/internal/cli/paykeys.go:24`.
- `payouts`, with create, get, update, cancel, hold, release, resubmit, and unmask children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/payouts.go:12` through `packages/cli/straddle-pp-cli/internal/cli/payouts.go:23`.
- `representatives`, with create, get, list, update, and unmask children. Evidence: `packages/cli/straddle-pp-cli/internal/cli/representatives.go:12` through `packages/cli/straddle-pp-cli/internal/cli/representatives.go:20`.

Generated support and agent roots:

- Root persistent flags include output modes, dry run, no input, idempotent handling, field selection, agent defaults, local versus live data source, profiles, delivery, and rate limit. Evidence: `packages/cli/straddle-pp-cli/internal/cli/root.go:96` through `packages/cli/straddle-pp-cli/internal/cli/root.go:117`.
- Root command registration covers API roots plus `doctor`, `auth`, `agent-context`, `profile`, `feedback`, `which`, `import`, `search`, `sync`, `tail`, `analytics`, `workflow`, `api`, and promoted endpoints. Evidence: `packages/cli/straddle-pp-cli/internal/cli/root.go:171` through `packages/cli/straddle-pp-cli/internal/cli/root.go:198`.
- `workflow` currently has `archive` and `status`. Evidence: `packages/cli/straddle-pp-cli/internal/cli/channel_workflow.go:17` through `packages/cli/straddle-pp-cli/internal/cli/channel_workflow.go:22`.
- `auth` supports status, set token, and logout. Evidence: `packages/cli/straddle-pp-cli/internal/cli/auth.go:16` through `packages/cli/straddle-pp-cli/internal/cli/auth.go:22`.
- `profile` supports save, use, list, show, and delete. Evidence: `packages/cli/straddle-pp-cli/internal/cli/profile.go:143` through `packages/cli/straddle-pp-cli/internal/cli/profile.go:161`.
- `search`, `sync`, `tail`, `analytics`, `import`, `feedback`, `which`, and `doctor` exist as local or support workflows. Evidence: `packages/cli/straddle-pp-cli/internal/cli/search.go:88` through `packages/cli/straddle-pp-cli/internal/cli/search.go:108`, `packages/cli/straddle-pp-cli/internal/cli/sync.go:41` through `packages/cli/straddle-pp-cli/internal/cli/sync.go:42`, `packages/cli/straddle-pp-cli/internal/cli/tail.go:23` through `packages/cli/straddle-pp-cli/internal/cli/tail.go:25`, `packages/cli/straddle-pp-cli/internal/cli/analytics.go:23` through `packages/cli/straddle-pp-cli/internal/cli/analytics.go:25`, `packages/cli/straddle-pp-cli/internal/cli/import.go:23` through `packages/cli/straddle-pp-cli/internal/cli/import.go:24`, `packages/cli/straddle-pp-cli/internal/cli/feedback.go:101` through `packages/cli/straddle-pp-cli/internal/cli/feedback.go:102`, `packages/cli/straddle-pp-cli/internal/cli/which.go:200` through `packages/cli/straddle-pp-cli/internal/cli/which.go:202`, `packages/cli/straddle-pp-cli/internal/cli/doctor.go:69` through `packages/cli/straddle-pp-cli/internal/cli/doctor.go:70`.

## Generated MCP Surface

The generated MCP surface has two layers:

1. Typed API tools in `packages/cli/straddle-pp-cli/internal/mcp/tools.go`.
2. Cobra command mirroring through `packages/cli/straddle-pp-cli/internal/mcp/cobratree/`.

Typed MCP inventory:

- 73 typed tools are registered with `mcplib.NewTool`.
- Prefix counts from the generated file: `account-settings` 1, `accounts` 8, `bridge` 6, `charges` 8, `customers` 9, `funding-event-payments` 1, `funding-events` 3, `linked-bank-accounts` 6, `organizations` 3, `paykeys` 10, `payments` 1, `payouts` 8, `reports` 1, `representatives` 5, `search` 1, `sql` 1, `context` 1.
- Read-only annotations are applied to GET and analysis tools. Evidence examples: `packages/cli/straddle-pp-cli/internal/mcp/tools.go:28` through `packages/cli/straddle-pp-cli/internal/mcp/tools.go:35`, `packages/cli/straddle-pp-cli/internal/mcp/tools.go:52` through `packages/cli/straddle-pp-cli/internal/mcp/tools.go:59`, `packages/cli/straddle-pp-cli/internal/mcp/tools.go:894` through `packages/cli/straddle-pp-cli/internal/mcp/tools.go:919`.

Cobra mirror inventory:

- `RegisterAll` walks user-facing Cobra commands and registers shell-out MCP tools for commands not already covered by typed endpoint tools. Evidence: `packages/cli/straddle-pp-cli/internal/mcp/cobratree/walker.go:12` through `packages/cli/straddle-pp-cli/internal/mcp/cobratree/walker.go:42`.
- Framework commands are intentionally skipped when typed MCP tools already cover the capability or when the command is not useful through MCP. Evidence: `packages/cli/straddle-pp-cli/internal/mcp/cobratree/classify.go:33` through `packages/cli/straddle-pp-cli/internal/mcp/cobratree/classify.go:71`.
- Novel user-facing commands are mirrored by default unless hidden or classified as endpoint or framework. Evidence: `packages/cli/straddle-pp-cli/internal/mcp/cobratree/classify.go:73` through `packages/cli/straddle-pp-cli/internal/mcp/cobratree/classify.go:83`.
- Companion CLI lookup uses sibling executable lookup, `STRADDLE_CLI_PATH`, then `PATH`. Evidence: `packages/cli/straddle-pp-cli/internal/mcp/cobratree/cli_path.go:12` through `packages/cli/straddle-pp-cli/internal/mcp/cobratree/cli_path.go:22`.

Generated MCP manifest:

- `packages/cli/straddle-pp-cli/manifest.json:2` through `packages/cli/straddle-pp-cli/manifest.json:18` defines manifest version, name, display name, binary entry point, and `STRADDLE_TOKEN` env mapping.
- `packages/cli/straddle-pp-cli/manifest.json:22` through `packages/cli/straddle-pp-cli/manifest.json:29` marks the token config as sensitive and required.

## Validation And Helper Scripts

| Path | Capability | Evidence |
|---|---|---|
| `package.json` | Defines `sync`, `validate`, and `test` scripts. | `package.json:6` through `package.json:10` |
| `skills/sync.js` | Copies canonical `skills/` into each provider skill target, skipping configured entries. | `skills/sync.js:4` through `skills/sync.js:22` |
| `scripts/shared.js` | Defines repo root, canonical skills dir, provider skill sync targets, and skip list. | `scripts/shared.js:6` through `scripts/shared.js:13` |
| `scripts/validate.js` | Validates sync consistency, skill frontmatter, command frontmatter, plugin manifests, version consistency, MCP configs, internal references, and generated CLI artifacts. | `scripts/validate.js:77` through `scripts/validate.js:220`, `scripts/validate.js:222` through `scripts/validate.js:263` |
| `scripts/validate-cli.js` | Validates generated CLI directory, Printing Press config, CLI main, README, generated skill, spec title, MCP main, `internal/mcp`, and `tools.go`. | `scripts/validate-cli.js:8` through `scripts/validate-cli.js:83` |

## Absorbed Feature Checklist

Required for the next implementation plan:

| Feature | Status | Reason |
|---|---|---|
| Preserve Printing Press generated CLI and MCP as the foundation | required | The workflow requires generated Go CLI and MCP, and generated files mark themselves as Printing Press output. |
| Keep provider synced skill copies out of source edits | required | Canonical skills live under `skills/`, and provider skill directories are synced outputs. |
| Absorb existing hosted MCP configs | required | Current provider MCP configs point to hosted Straddle MCP, while the generated MCP manifest points to `straddle-pp-mcp`; both surfaces need clear docs. |
| Treat `STRADDLE_TOKEN` as sensitive config | required | The generated manifest marks token user config sensitive and required. |
| Keep generated MCP and CLI in one command tree | required | `RootCmd()` is consumed by the MCP server, and the Cobra walker mirrors commands. |
| Preserve root agent defaults | required | `--agent` sets JSON, compact output, no input, yes, and no color defaults. |
| Use `doctor`, `auth`, `profile`, `which`, `agent-context`, `sync`, `search`, `analytics`, `tail`, and `workflow` before inventing new support commands | required | These support roots already exist and cover much of the benchmark surface. |
| Add docs search as a distinct concept from local synced data search | required | Existing product docs skill searches docs, while generated CLI `search` searches synced local data. |
| Add status explanation only with live docs or explicit source references | required | Slash command content warns not to rely on hardcoded reason code lists. |
| Keep sandbox testing optional and sandbox-only | required | Existing sandbox command is explicit that testing happens in sandbox and requires current docs lookup. |

Later:

| Feature | Status | Reason |
|---|---|---|
| Public installer polish and binary rename from preview name | later | The generated project is still a local preview and the spec keeps rename as an open question. |
| Full docs parity with product docs and SDK examples | later | The local skill ecosystem has docs search and SDK routing, but generated CLI docs are not a product docs replacement yet. |
| Browser capture for docs or generated output | later | Phase 1.7 browser-sniff artifact exists, with HAR fallback noted, and is pending final phase-artifact review. |
| Live read-only API smoke | later | Phase 5 is optional and requires safe sandbox classification. |
| Provider marketplace sync after CLI docs changes | later | This artifact is not a sync task and did not edit canonical skills. |

Rejected for the next implementation plan:

| Feature | Status | Reason |
|---|---|---|
| Hand-build a separate MCP tree | rejected | The generated MCP already registers typed API tools and mirrors the CLI command tree. A separate tree would duplicate behavior and risk drift. |
| Edit generated internals during this gate | rejected | Phase 1.5 is a catalog artifact. The user also prohibited implementation code edits. |
| Edit `providers/*/plugin/skills` | rejected | Those are synced copies, not canonical source. |
| Hardcode complete status code tables into a CLI command | rejected | Existing command and skill guidance says current reason code values must come from docs. |
| Treat hosted MCP configs and generated MCP binary as interchangeable | rejected | They have different packaging and auth surfaces. |
| Add production smoke or write operations | rejected | The master workflow blocks production calls and requires sandbox-safe read-only smoke for live tests. |

## Novel Suggestions

These are suggestions only. They are not required implementation unless a future task accepts them.

| Suggestion | Status | Reason |
|---|---|---|
| Add `straddle-pp-cli docs search <query>` as a docs-specific command | later | It would remove confusion with local synced data search, but it needs a docs source contract and verification path. |
| Add `straddle-pp-cli status explain <entity> <status>` | later | It maps to the existing slash command, but it must call current docs or cite local reference files instead of embedding stale lists. |
| Add `straddle-pp-cli sandbox guide <scenario>` as a help-only command first | later | It can absorb `/sandbox-test` without making live API calls. Live smoke can come later. |
| Add `straddle-pp-cli mcp doctor` or extend `doctor` with generated MCP checks | later | Current `doctor` is CLI health. MCP binary launch and generated tool exposure are a separate launch readiness concern. |
| Add `straddle-pp-cli workflow pay-by-bank inspect` as read-only walkthrough output | later | It can combine customer, paykey, charge, payout, and funding references without creating resources. |
| Add `straddle-pp-cli workflow embed inspect` as read-only onboarding readiness output | later | It can use account scoping rules and hosted onboarding docs without making API calls. |

## Missing Capabilities

- Generated CLI has local `search`, but no clearly named product docs search command.
- Generated CLI has `which`, but no command that maps slash-command scenarios to CLI commands.
- Generated CLI has `agent-context`, but generated MCP context and CLI context need an explicit docs contract for users.
- Generated CLI has `doctor`, and generated MCP smoke guidance now documents how to build `/tmp/straddle-pp-mcp`, run `tools/list`, and remove the temporary binary afterward.
- Generated CLI metadata and typed MCP registrations now have explicit count semantics: generated metadata says 70 endpoint tools, typed registration count is 73 after 3 framework typed tools, and runtime `tools/list` count is 80 after Cobra shell-out tools.
- Generated CLI has sandbox-capable API roots, but no help-only sandbox scenario command that avoids live writes.
- Generated CLI has `auth set-token`, while the generated MCP manifest expects `STRADDLE_TOKEN`; docs need to reconcile config file auth and env auth.
- Generated CLI has promoted `payments`, `reports`, `account-settings`, and `funding-event-payments`, but no plain map showing which are OpenAPI endpoint mirrors versus custom workflow commands.

## Duplicated Capabilities

- Hosted provider MCP configs and generated MCP binary both expose Straddle API access, but through different runtime surfaces.
- Product docs skill and `product-docs` slash command are intentionally duplicated, with the command acting as a wrapper.
- `search_docs` MCP, product docs HTTP search, and generated CLI local `search` all use the word search for different sources.
- Typed MCP endpoint tools and Cobra shell-out tools can overlap unless the classifier skips endpoint and framework commands.
- `auth set-token` and manifest `STRADDLE_TOKEN` both represent credentials, but they land in different places.

## Next Slice Guidance

The next implementation slice should start from this catalog. It should first decide whether the work is docs-only, generated CLI docs, or a patch-layer command change. If it touches generated internals, it needs the patch-layer evidence required by the master workflow. If it only improves docs, it should state which duplicated or missing capability it clarifies.
