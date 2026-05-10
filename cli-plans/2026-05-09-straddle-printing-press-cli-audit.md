# Completion Audit: Straddle Printing Press CLI

## Objective Restated

Build a new public Straddle CLI in `/Users/js/clawd/straddle/straddle-ai`.

The CLI must be generated with Printing Press from Straddle's public OpenAPI spec, use the Stainless CLI only as a behavior reference, use Ramp only as a benchmark, include a generated MCP sibling, and become agent-friendly, documented, tested, and useful for practical Straddle workflows without overbuilding the first slice.

## Current Verdict

Not complete.

The first generated baseline is present and verified. Task 5 spec review passed. The first Task 5 quality review found README and audit wording issues, and those were fixed. The next Task 5 quality re-review found stale spec, plan, and audit wording. That focused fix resolved those wording issues.

The selected CLI contract and honesty slice is now partially implemented. The local-preview product review is complete at `cli-plans/2026-05-09-straddle-cli-product-review.md` and approves local preview only. Local release archive validation now passes without publishing: GoReleaser v2 validates `.goreleaser.yaml`, the config uses `homebrew_casks` instead of deprecated `brews`, and a snapshot build created darwin, linux, and windows archives containing both `straddle-pp-cli` and `straddle-pp-mcp`. `release plan [surface]` now makes archive, Homebrew, MCP, npm, and signing blockers explicit without publishing or secrets. The full objective is not achieved because public launch packaging, public-launch product approval, approved live operations, and richer workflow commands remain open. The MCP count discrepancy is resolved and validated for this slice.

Task 14 implemented the Streaming Agent Contract for `sync --agent` and real `tail --agent`. Agent stream lines now use the target envelope with event payloads under `data`, timestamps, and final summary or end events as envelope lines. Normal human output and normal `--json` stream output remain raw NDJSON for compatibility.

For this slice, the conservative `--agent` path is documented. Current `--agent` output expands to JSON, compact, no-input, no-color, and yes. Provenance-backed generated list and read commands now use the target envelope from the spec. Command-specific local helpers routed through `printJSONFiltered`, such as `which --agent`, also use the target envelope only when `--agent` is active; normal `--json` stays raw. `agent-context --agent` also uses the target envelope, with the existing v3 agent context object under `data`. The target envelope has no provenance field, so the previous `meta` provenance object is intentionally not included in JSON output. `sync --agent` and real `tail --agent` event streams now use the same target envelope.

Safe token guidance is done for the current preview docs: stdin auth is documented, environment injection is documented, and docs say not to commit, print, log, or pass tokens through argv. The agent envelope is now covered for generated list/read commands, `printJSONFiltered` local helpers under `--agent`, `agent-context --agent`, `about --agent`, `sync --agent`, and real `tail --agent`.

The first presentation polish slice is now partially implemented through `straddle-pp-cli about`. It is local-only, credential-free, and prints Straddle ASCII word art plus concise preview status for humans. `about --json` emits a stable machine object, and `about --agent` emits the target envelope.

The docs-search slice is implemented through `straddle-pp-cli docs search`. It separates product docs lookup from the existing synced-data `search` command. Product docs search uses the unauthenticated product docs MCP endpoint, command search uses the local generated capability index, and API or SDK sources return `search_docs` MCP guidance for now. `docs search --agent` uses the target envelope through the existing local JSON helper path.

The ops-guide slice is partially implemented through `straddle-pp-cli ops guide [workflow]`. Supported workflows are `reconciliation`, `fraud-monitoring`, `collections`, `reporting`, and `monitoring`. The command is local-only guidance: it lists docs lookup queries, read-side CLI surfaces to inspect, safe next steps, and safety metadata. It does not call Straddle APIs, call docs endpoints, execute MCP tools, post webhooks, or write production data. Live operational execution requires separate approval and a fresh docs lookup.

The workflow also needs smaller commits. After each slice passes spec review, quality review, and verification, the controller should stage only intended files and make a small commit before starting the next implementation slice. The current baseline should be committed in logical chunks now: generated baseline first, then hand-authored docs, validation, plans, and audit updates.

The master workflow now lives in `cli-plans/2026-05-09-straddle-cli-full-workflow.md`. Future implementation loops must follow it before and during each slice. The workflow requires phase mapping, evidence reuse, subagent-driven execution, spec review, quality review, verification, audit updates, and an intended-files-only commit before the next slice starts.

## Master Workflow Phase Status

| Phase | Status | Evidence |
|-------|--------|----------|
| Phase 0 Resolve + Reuse | Artifact created, pending final phase-artifact review | Resolve and reuse artifact exists. Do not treat it as fully accepted until final phase-artifact review passes. |
| Phase 1 Research Brief | Artifact created, pending final phase-artifact review | Research brief exists and competitor benchmark exists. Do not treat them as fully accepted until final phase-artifact review passes. |
| Phase 1.5 Ecosystem Absorb Gate | Artifact created, pending final phase-artifact review | Ecosystem absorb artifact exists. Do not treat it as fully accepted until final phase-artifact review passes. |
| Phase 1.7 Browser-Sniff Gate | Artifact created, pending final phase-artifact review | Browser-sniff artifact exists, with HAR fallback noted. Do not treat it as fully accepted until final phase-artifact review passes. |
| Phase 2 Generate | Done | Printing Press generated the Go CLI and MCP server from the public Straddle OpenAPI spec. Root validation and generated Go verification passed for the first slice. |
| Phase 3 Build workflow commands | Partial | Generated baseline exists. Local-only helper commands now cover docs search, sandbox guide, setup check, ops guide, smoke plan, and release plan, but approved live workflow execution and full workflow engines have not been built. |
| Phase 4 Shipcheck | Partial | Shipcheck scorecard now exists at `cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md`. First-slice validation, Go verification, reviews, audit fixes, packaging readiness proof, local GoReleaser archive validation, local-preview product review, live-smoke planning, and public-release readiness planning exist. MCP count semantics are resolved: `.printing-press.json` metadata tracks 70 endpoint tools, typed Go MCP registrations total 73 after adding 3 framework typed tools, and runtime `tools/list` now expects 85 with 12 Cobra shell-out tools including `docs_search`, `ops_guide`, `release_plan`, `sandbox_guide`, `setup_check`, and `smoke_plan`. Launch readiness remains partial because public packaging, approved live smoke, public-launch product approval, and richer workflow commands are incomplete. |
| Phase 5 Live Smoke | Not done | No read-only API smoke or data-flow check has been run. |

## Evidence Snapshot

Captured on `2026-05-09 00:35 MDT`.

Root validation:

```bash
cd /Users/js/clawd/straddle/straddle-ai
npm run validate
```

Result: passed with `Summary: 0 errors`.

Generated Go verification:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
gofmt -l .
go test -count=1 ./...
go build -o /tmp/pp-cli-audit ./cmd/straddle-pp-cli
go build -o /tmp/pp-mcp-audit ./cmd/straddle-pp-mcp
rm -f /tmp/pp-cli-audit /tmp/pp-mcp-audit
```

Result: `gofmt` clean, tests passed, CLI build passed, MCP build passed.

Artifact checks:

```bash
find packages/cli/straddle-pp-cli -maxdepth 3 -type d \( -name build -o -name bin -o -name dist \) -print
rg -n 'bearerToken|postman_environment|eyJ|type: secret|type":"secret|postman.co/workspace|postman.com' packages/cli/straddle-pp-cli || true
```

Result: no local build directories found, no credential-pattern matches found.

Release archive validation:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go run github.com/goreleaser/goreleaser/v2@latest check
go run github.com/goreleaser/goreleaser/v2@latest release --snapshot --clean --skip=publish
tar -tzf dist/straddle-pp-cli_0.0.0-SNAPSHOT-ebf6bfc_darwin_arm64.tar.gz
zipinfo -1 dist/straddle-pp-cli_0.0.0-SNAPSHOT-ebf6bfc_windows_amd64.zip
make clean
```

Result: config validation passed with no deprecation warning after moving from `brews` to `homebrew_casks`. The non-publishing snapshot build succeeded, produced local darwin, linux, and windows archives, wrote a local cask at `dist/homebrew/Casks/straddle-pp-cli.rb`, and skipped publish. The inspected darwin archive contained `LICENSE`, `README.md`, `straddle-pp-cli`, and `straddle-pp-mcp`; the inspected Windows archive contained `LICENSE`, `README.md`, `straddle-pp-cli.exe`, and `straddle-pp-mcp.exe`. The inspected local cask contained `binary "straddle-pp-cli"` and `binary "straddle-pp-mcp"`. No archive was published, uploaded, pushed, or written to a Homebrew tap.

## Prompt to Artifact Checklist

| Requirement | Evidence | Status |
|-------------|----------|--------|
| New public Straddle CLI work lives in `/Users/js/clawd/straddle/straddle-ai` | Generated preview under `packages/cli/straddle-pp-cli`; docs under `packages/cli/README.md`; plan under `cli-plans/` | Partial |
| Powered by OpenAPI from `/Users/js/clawd/straddle/sdks/straddle-docs` | `packages/cli/straddle-pp-cli/spec.json` identifies `Straddle API`; `.printing-press.json` records `spec_url` as `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json` | Done for first slice |
| Use Printing Press as generator/library foundation | Generated Go project has `.printing-press.json`, `cmd/straddle-pp-cli`, `cmd/straddle-pp-mcp`, `internal/mcp`; `packages/cli/README.md` explains `mvanhorn/cli-printing-press` is the generator and `printing-press-library` is catalog/examples/distribution reference | Done for first slice |
| Stainless CLI only as behavior reference | `packages/cli/README.md` has `Stainless Reference` section and states not to copy Stainless architecture | Done for first slice |
| Ramp CLI/MCP/docs/ergonomics/agent friendliness/presentation/word art benchmark | `packages/cli/README.md` has Ramp benchmark checklist including installer, auth, agent JSON, command grammar, skills, MCP, docs, and word art. `about` now covers the first local presentation slice. | Partial |
| Include MCP from Printing Press | `cmd/straddle-pp-mcp/main.go` and `internal/mcp/` exist; Go MCP build passed | Done for first slice |
| CLI first | `packages/cli/README.md` states CLI first and MCP sibling from same command tree | Done for first slice |
| Agent-friendly | Generated CLI includes agent-context. Provenance-backed generated list and read commands now use the target envelope. Command-specific local helpers routed through `printJSONFiltered`, such as `which --agent`, use the target envelope only when `--agent` is active. `agent-context --agent` also uses the target envelope. `sync --agent` and real `tail --agent` now wrap stream lines in the same target envelope while normal `--json` streams remain raw NDJSON. | Partial |
| Documented | Spec, plan, generated README, generated SKILL, and package README exist. Install honesty, MCP smoke instructions, sandbox-safe read-only walkthrough, docs search, and ops-guide guidance are now documented. | Partial, because later launch and live workflow docs remain gaps |
| Tested | `npm run validate`, `go test -count=1 ./...`, CLI build, and MCP build passed | Done for first slice |
| Featureful across setup | Generated baseline has setup-adjacent `auth`, `doctor`, `profile`; `setup check` now provides a local-only first-run readiness preflight that points to `auth set-token --stdin`, optional `doctor --json`, `docs search`, and `sandbox guide` without calling APIs, docs endpoints, MCP, webhooks, or production. | Partial, because publish and broader onboarding remain gaps |
| Featureful across customers | Generated customer commands exist; sandbox-safe read-only customer exploration is documented | Partial, no curated write workflow examples yet |
| Featureful across payments | Generated charges, payouts, paykeys, funding events, and promoted payments commands exist; sandbox-safe read-only payment exploration is documented | Partial, no curated write workflow yet |
| Featureful across reconciliation | `ops guide reconciliation` provides local-only planning guidance, docs lookup queries, read-side CLI surfaces to inspect, and safe next steps. | Partial, no approved live reads, matching engine, or production workflow |
| Featureful across fraud monitoring | `ops guide fraud-monitoring` provides local-only planning guidance, docs lookup queries, read-side CLI surfaces to inspect, and safe next steps. | Partial, no approved live reads, action workflow, or production workflow |
| Featureful across collections | `ops guide collections` provides local-only planning guidance, docs lookup queries, read-side CLI surfaces to inspect, and safe next steps. | Partial, no approved live reads, notices, retries, or production workflow |
| Featureful across reporting | `ops guide reporting` provides local-only planning guidance, docs lookup queries, read-side CLI surfaces to inspect, and safe next steps. | Partial, no approved live reads, live reports, exports, or production workflow |
| Featureful across monitoring | `ops guide monitoring` provides local-only planning guidance, docs lookup queries, read-side CLI surfaces to inspect, and safe next steps. | Partial, no approved live reads, polling, alerting, webhook delivery, or production workflow |
| Featureful across sandbox testing | Sandbox-safe help, config, local build, read-only walkthrough, and help-only `sandbox guide [scenario]` flow are documented. For this slice, production calls and live writes are out of scope. | Partial |
| Featureful across approved live smoke | `smoke plan [scope]` provides local-only runbook guidance for setup, customers, payments, funding, MCP tools/list, and all scopes. It returns docs lookup topics as text, not endpoint-calling docs commands. It requires explicit approval and secure credentials for any future live execution. | Partial, no actual approved live smoke has run |
| Featureful across docs/search integration | Generated `search` remains synced local data search. `docs search` now provides product docs lookup, local command search, and API or SDK `search_docs` guidance. | Partial |
| Do not overbuild first slice | Work stopped at generated baseline, docs, validation, and verification | Done |
| Use subagent-driven development | Tasks 1 through 4 passed subagent implementation and review gates. Task 5 spec review passed. The first Task 5 quality review found README and audit wording issues that were fixed. The next quality re-review found spec, plan, and audit wording issues that this focused fix resolved. | Partial |
| Master workflow exists and controls future loops | `cli-plans/2026-05-09-straddle-cli-full-workflow.md` defines Phase 0 through Phase 5, deliverables, review gates, loop rules, commit cadence, subagent roles, repo constraints, and completion audit rule | Done for planning |
| Future quality agents use Agent Skills and Straddle review | Plan Task 6 requires `agent-skills:code-review-and-quality` and `straddle-engineering:code-review`, with .NET-specific checks marked N/A for Go or Node CLI work | Done in plan |
| CLI contract and honesty slice | Safe token input is done. Provenance-backed generated list and read commands use the target envelope. Command-specific local helpers routed through `printJSONFiltered` use the target envelope only for `--agent`, and normal `--json` stays raw. `agent-context --agent`, `about --agent`, and `setup check --agent` use the target envelope. Install honesty is documented. MCP smoke instructions are documented. Sandbox-safe read-only walkthrough is documented. The Streaming Agent Contract is implemented for `sync --agent` and real `tail --agent`. | Partial, because launch packaging remains open |
| Local-preview product review | `cli-plans/2026-05-09-straddle-cli-product-review.md` approves local preview and rejects public launch. It covers CLI-first shape, MCP sibling, provenance, agent behavior, workflow readiness, safety, Ramp/reference parity, and blockers. | Done for local preview |
| Live-smoke planning command | `straddle-pp-cli smoke plan [scope]` is implemented as a local-only PATCH command and exposed to MCP as read-only `smoke_plan`. | Done for planning only |

## Completed Gates

- Task 1: Printing Press baseline.
  - Spec review: approved.
  - Quality review: approved after sanitizing generated artifacts and formatting Go.
- Task 2: CLI package README.
  - Spec review: approved.
  - Quality review: approved.
- Task 3: fast validation.
  - Spec review: approved.
  - Quality review: approved.
- Task 4: generated Go verification.
  - Spec review: approved.
  - Quality review: approved using Agent Skills code review and Straddle review criteria where applicable.

## Task 5 Review

Task 5: comparison checklist and review-process update.

Implementation completed. Spec review passed. The first quality review found two cleanup items: update the README verification commands so Go builds write to `/tmp` and remove those temp binaries, and update this audit so Task 5 is described with its current review state. Those items were fixed before this re-review.

The next quality re-review found three stale wording items: the spec still used repo-local Go build commands, the plan still used repo-local Go build commands, and this audit still described already-applied README and audit cleanup as pending. This focused fix updated the spec and plan to match the README verification flow, and updated this audit to describe the current review history.

Do not mark the broader goal complete from Task 5 alone. Later launch and workflow requirements remain open.

## Missing Work Before Goal Completion

1. Finish the broader CLI contract and launch path. The current honesty docs slice is partial and does not complete the public CLI goal.
   - Safe token input is done.
   - Agent JSON gap is documented.
   - Install honesty is documented.
   - MCP smoke instructions are documented.
   - Sandbox-safe read-only walkthrough is documented.
   - Provenance-backed generated list and read commands now use the target envelope.
   - Command-specific local helpers routed through `printJSONFiltered`, such as `which --agent`, now use the target envelope only for `--agent`; normal `--json` stays raw.
   - `agent-context --agent` now uses the target envelope with the existing v3 agent context object under `data`.
   - Local word art and preview status are partially done through `about`.
   - Docs search is implemented as a first-class `docs search` command, separate from synced-data `search`.
   - Sandbox testing now has a help-only `sandbox guide [scenario]` command that absorbs the `/sandbox-test` scenario list without live API calls or docs endpoint calls.
   - The Streaming Agent Contract is implemented for `sync --agent` and real `tail --agent`.
   - Normal `--json` stream output remains raw NDJSON for compatibility.
   - Local release archive validation is done without publishing, including archives that contain both CLI and MCP sibling binaries.
   - Real public launch packaging remains open.
   - Local-preview product review is done.
   - Public-launch product approval remains open.
   - Ops guide is implemented as local-only guidance for reconciliation, fraud monitoring, collections, reporting, and monitoring.
   - Smoke plan is implemented as local-only guidance for future approved read-only smoke across setup, customers, payments, funding, and MCP.
   - Release plan is implemented as local-only guidance for public-release readiness across archives, Homebrew, MCP, npm, and signing. It reduces the distribution decision blocker but does not publish, upload, push, sign, notarize, call external services, execute MCP tools, read secrets, or approve launch.
   - Actual approved live smoke has not run.
   - Richer live workflow commands remain open.
   - MCP count discrepancy is resolved and validated. `.printing-press.json` `mcp_tool_count` tracks 70 generated endpoint tools. Typed `mcplib.NewTool(` registrations total 73 because `search`, `sql`, and `context` are local framework typed tools. Runtime `tools/list` now expects 85 tools because it includes those 73 typed tools plus 12 Cobra shell-out tools: `analytics`, `docs_search`, `import`, `ops_guide`, `release_plan`, `sandbox_guide`, `setup_check`, `smoke_plan`, `sync`, `tail`, `workflow_archive`, and `workflow_status`.
   - Patch-layer cleanup is documented for generated-code `// PATCH:` markers, `.printing-press-patches.json`, root registration overwrite risk, and MCP workflow exposure.
   - After spec review, quality review, and verification pass, stage only intended files and make a small commit before the next implementation slice.
2. Keep these broader goals out of the next slice unless explicitly re-scoped:
   - Publishing.
   - OAuth.
   - Full skill manager.
   - Richer presentation polish beyond the local `about` command.
   - Full workflow engine for reconciliation, fraud monitoring, collections, reporting, and monitoring.
   - Live API reads, docs lookup, MCP execution, webhook posts, or production writes from `ops guide`.
   - Live API reads, docs lookup execution, MCP execution, sandbox access, production access, or approval from `smoke plan`.
3. Run a fresh completion audit after the next slice. Treat uncertainty as incomplete.

## Do Not Claim

Do not claim the full goal is complete from the current state.

The current state is a reviewed first-slice baseline plus validation, with Task 14 stream envelope implementation applied. The broader public CLI objective remains active.
