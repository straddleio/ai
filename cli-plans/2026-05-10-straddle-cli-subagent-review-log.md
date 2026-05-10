# Straddle CLI Subagent Review Log

Date: 2026-05-10

## Purpose

This artifact records durable review evidence for recent Straddle Printing Press CLI slices. It helps future agents find what changed, which review gates passed, and what evidence still remains incomplete.

This does not close the full historical evidence gap. Older slices may still lack committed implementer, spec-review, quality-review, or controller-verification summaries. This log improves the forward trail for recent committed slices.

## Workflow Rule

Every implementation slice must complete these gates before the controller selects the next slice:

1. Implementer subagent completes one scoped slice and reports changed files, commands, evidence, and open risks.
2. Spec reviewer checks the slice against the spec, plan, audit, and local workflow rules.
3. Code-quality reviewer checks maintainability, safety, generated-code boundaries, and verification.
4. Controller verification reruns the required commands and checks for unintended files, unsafe examples, and formatting issues.
5. Controller commits the intended files only.

## Recent Committed Slices

| Commit | Slice | Durable evidence |
|--------|-------|------------------|
| `c1eb35d docs: record packaged credential smoke` | Recorded the local packaged-client credential smoke results in durable planning docs. | Local built CLI and MCP binaries ran without credentials or API calls; auth status returned expected exit 4; MCP `tools/list` returned 87 tools; `make clean` passed. Spec and quality review approved the evidence. |
| `4b4c90f feat: add packaged credential smoke plan` | Added `credentials plan packaged-client --json` so agents can print local packaged CLI/MCP smoke steps before running them. | Review requested MCP `tools/list` proof command, completion-audit command consistency, and keychain and launch wording fixes. Fixes landed before spec and quality approval. |
| `0abc7e4 feat: add release owner decisions plan` | Added `release plan owner-decisions --json` for public release owner choices that remain blocked. | Review requested stale release surface list and runbook purpose fixes. Fixes landed before approval; public launch stayed blocked. |
| `c7f9497 feat: add release compatibility plan` | Added `release plan compatibility --json` to inventory current Stainless CLI behavior before any public command replacement. | Spec and quality review approved after the installed Stainless CLI and source-tree inventory were verified. |
| `1515611 feat: add release docs support plan` | Added local docs and support launch planning through `release plan docs-support --json`, refreshed audit and decision docs, and updated generated CLI support code and tests. | This log records the session review details below. |
| `34549dd docs: refresh cli completion audit` | Refreshed the completion audit and public-launch product review after new local readiness evidence. | Commit contains audit updates that keep launch status partial. |
| `8eac604 feat: add smoke approval plan` | Added the local-only `smoke plan approval` surface, approval evidence fields, stop criteria, and tests. | Completion audit and decision packet now point at the approval packet, while live smoke remains incomplete. |
| `39444c8 feat: add release naming plan` | Added the local-only release naming plan and tests. | Completion audit and decision packet now state the public `straddle` name is not approved. |
| `32fc65f docs: record keychain packaging smoke` | Recorded local packaging smoke after opt-in keychain support. | Shipcheck scorecard and completion audit record `make package-readiness`, `make release-check`, and cleanup. |
| `cf2598e feat: add opt-in keychain auth` | Added opt-in keychain auth, launch credential planning updates, and related tests. | Completion audit and public-launch review keep credential launch posture partial pending owner and security approval. |

## Latest Slice Review Detail

### Fresh non-live shipcheck after compatibility inventory

Run date: 2026-05-10.

What changed:

- Recorded a fresh non-live, credential-free, local-only shipcheck in the shipcheck scorecard and completion audit.
- Kept public launch and live smoke blocked.
- Recorded cleanup evidence showing `make clean` removed local outputs.

Evidence:

- `npm run validate` passed with `Summary: 0 errors`; generated MCP typed counts remained 70 endpoint tools, 3 framework tools, and 73 typed tools total.
- `go test -count=1 ./...` passed from `packages/cli/straddle-pp-cli`.
- `make package-readiness` built executable packaged binaries at `dist/local/straddle-pp-cli` and `dist/local/straddle-pp-mcp`, then verified packaged CLI help.
- Packaged `dist/local/straddle-pp-cli --help` worked.
- Packaged `setup check --json` reported no docs endpoint calls, no Straddle API calls, no MCP execution, no webhook posts, and no production writes.
- Packaged `about --agent` emitted a valid target JSON envelope for local preview and reported no auth requirement, no API calls, and no production writes.
- Packaged `release plan all --json`, `credentials plan packaged-client --json`, and `smoke plan approval --json` printed local-only planning or approval guidance without approving launch, reading secrets, publishing, signing, notarizing, or executing MCP tools.
- JSON-RPC `initialize`, `notifications/initialized`, and `tools/list` against `dist/local/straddle-pp-mcp` returned `tool_count: 87`; first tools were `account-settings_get-settings`, `accounts_capability-requests_create`, `accounts_capability-requests_list`, `accounts_create`, and `accounts_get`. No MCP tool was called.
- `make clean` removed `bin/`, `build/`, and `dist/`.

Safety boundary:

- No Straddle API calls, docs endpoint calls, MCP tool calls, production calls, publishing, signing, notarization, npm registry actions, Homebrew, or tap actions happened.
- Stainless remained reference only; Printing Press remained the generator foundation.

Controller verification for this documentation slice is expected to cover `git diff --check`, added-line unsafe punctuation scans, added-line credential example scans, and post-clean output directory checks before handoff.

### Current CLI compatibility inventory slice

What changed:

- Added `cli-plans/2026-05-10-straddle-cli-current-cli-compatibility-inventory.md`.
- Recorded local compatibility evidence for the installed Stainless-generated `straddle` command and the Printing Press preview `straddle-pp-cli`.
- Updated the completion audit, public launch decision packet, and public launch product review to reference the new inventory without approving replacement, migration, support wording, docs wording, live smoke, or public launch.

Evidence:

- Implementer built `/tmp/straddle-pp-cli-compat`, captured installed `straddle` version `0.1.0`, inspected installed and preview help, verified `charges create` and `customers list` exist in both CLIs, captured `release plan compatibility --json`, and removed the temporary binary.
- Implementer confirmed the Stainless CLI source remote is `https://github.com/stainless-sdks/straddle-cli` and found the Stainless marker in the source README.
- Spec review approved the artifact and cross-links.
- Quality review approved the scope, launch boundaries, and token-safety wording.
- Controller verification covered formatting, unsafe added-line scans, and repository status before commit.

### Commit `c1eb35d docs: record packaged credential smoke`

What changed:

- Recorded passed local packaged-client credential smoke evidence in the shipcheck scorecard, completion audit, decision packet, and public-launch product review.
- Kept the result scoped to local packaged binaries and stated that it does not approve public launch.

Evidence:

- Implementer ran local packaged binaries under `dist/local`.
- `auth status --json` returned expected unauthenticated exit 4 and did not print credentials.
- MCP JSON-RPC `tools/list` against the packaged MCP binary returned `tool_count: 87` without executing MCP tools.
- `make clean` passed and removed local build outputs.
- Spec and quality review approved the recorded evidence.
- Controller committed only documentation evidence.

### Commit `4b4c90f feat: add packaged credential smoke plan`

What changed:

- Added `credentials plan packaged-client --json` to print local smoke steps for built CLI and MCP binaries.
- Updated credential launch docs, release docs, audits, and patch metadata to keep packaged smoke separate from public launch.

Requested changes and resolution:

- Review requested an explicit MCP `tools/list` proof command. The plan now prints a JSON-RPC `tools/list` smoke command for `dist/local/straddle-pp-mcp`.
- Review requested completion-audit command consistency. The audit now lists the packaged credential plan command in the fresh CLI smoke block.
- Review requested keychain and launch wording fixes. The docs now say keychain is preview support and packaged smoke evidence does not approve broad launch.

Evidence:

- Implementer added code, tests, docs, and patch manifest updates.
- Spec and quality review approved after the requested fixes.
- Controller verification covered release and credential plan output, tests, validation, patch JSON, formatting, and unsafe added-line scans.

### Commit `0abc7e4 feat: add release owner decisions plan`

What changed:

- Added `release plan owner-decisions --json` to print the public release owner choices still required.
- Updated docs, audits, review packets, generated release code, tests, and patch metadata.

Requested changes and resolution:

- Review requested a stale release surface list fix. The owner-decisions surface was added to the release surface list and tests.
- Review requested runbook purpose wording fixes. The runbook now states that the command only prints local planning guidance and does not publish, make live calls, read secrets, approve launch, approve support, sign, notarize, or execute MCP tools.

Evidence:

- Implementer added the owner-decision surface and test coverage.
- Spec and quality review approved after the requested fixes.
- Controller verification covered release plan output, tests, validation, patch JSON, formatting, and unsafe added-line scans.

### Commit `c7f9497 feat: add release compatibility plan`

What changed:

- Added `release plan compatibility --json` to inventory current Stainless CLI behavior before any public `straddle` replacement, alias, or migration decision.
- Updated audits, decision docs, product review docs, generated release code, tests, package docs, and patch metadata.

Evidence:

- Implementer added local proof commands for the installed Stainless CLI and Stainless source-tree markers.
- Spec review approved after the Stainless CLI inventory was verified.
- Quality review approved after confirming the surface stays local-only and does not approve public replacement.
- Controller verification covered release plan output, tests, validation, patch JSON, formatting, and unsafe added-line scans.

Commit: `1515611 feat: add release docs support plan`.

Initial spec review requested changes for two issues:

1. The product-review file was missing from `.printing-press-patches.json`.
2. The runbook purpose wording was stale and still framed the support plan too narrowly.

The fix agent resolved both issues.

Spec re-review approved after:

- `go test -count=1 ./internal/cli -run 'TestReleasePlan'`
- `npm run validate`
- `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json`
- `git diff --check`
- Inspection of `release plan docs-support --json`

Quality review approved after:

- `go test -count=1 ./...`
- `npm run validate`
- `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json`
- `git diff --check`
- Added-line scans for unsafe punctuation and credential examples
- Focused MCP tests

Controller verification passed:

- `go test -count=1 ./internal/cli -run 'TestReleasePlan'`
- `go test -count=1 ./...`
- `npm run validate`
- `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json`
- `git diff --check`
- Added-line em dash scan
- Added-line token and Bearer-header scan

## Remaining Evidence Gap

Recent committed slices now have a durable review index. The completion audit should still treat the historical subagent evidence requirement as partial until older implementation slices have committed reviewer summaries or the owner explicitly accepts the older gap.
