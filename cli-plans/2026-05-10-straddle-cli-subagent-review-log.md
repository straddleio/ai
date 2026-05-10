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
| `1515611 feat: add release docs support plan` | Added local docs and support launch planning through `release plan docs-support --json`, refreshed audit and decision docs, and updated generated CLI support code and tests. | This log records the session review details below. |
| `34549dd docs: refresh cli completion audit` | Refreshed the completion audit and public-launch product review after new local readiness evidence. | Commit contains audit updates that keep launch status partial. |
| `8eac604 feat: add smoke approval plan` | Added the local-only `smoke plan approval` surface, approval evidence fields, stop criteria, and tests. | Completion audit and decision packet now point at the approval packet, while live smoke remains incomplete. |
| `39444c8 feat: add release naming plan` | Added the local-only release naming plan and tests. | Completion audit and decision packet now state the public `straddle` name is not approved. |
| `32fc65f docs: record keychain packaging smoke` | Recorded local packaging smoke after opt-in keychain support. | Shipcheck scorecard and completion audit record `make package-readiness`, `make release-check`, and cleanup. |
| `cf2598e feat: add opt-in keychain auth` | Added opt-in keychain auth, launch credential planning updates, and related tests. | Completion audit and public-launch review keep credential launch posture partial pending owner and security approval. |

## Latest Slice Review Detail

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
