# Implementation Plan: Straddle Printing Press CLI

## Overview

This plan turns the Straddle public OpenAPI spec into a Printing Press generated CLI preview, keeps the generated MCP sibling, and adds enough docs and validation for reviewers to compare it against the spec, Ramp, and the existing Stainless CLI.

The master workflow for this effort is `cli-plans/2026-05-09-straddle-cli-full-workflow.md`. Every implementation loop must follow that workflow before and during each slice. The controller must map the slice to the workflow phases, reuse existing evidence, run required review gates, update the audit, and commit intended files after the slice passes spec review, quality review, and verification.

Implementation must use fresh subagents. The controller supplies this plan and the relevant spec sections. Each implementation task gets a spec review and then a code-quality review before the next task starts.

After each slice passes spec review, quality review, and verification, the controller stages only the intended files and makes a small commit before starting the next implementation slice. Commit logical chunks instead of one broad dump. For the current baseline, commit the generated Printing Press baseline first, then commit hand-authored docs, validation, plans, and audit updates in their own logical chunk.

## Architecture Decisions

- Printing Press is the source of the CLI and MCP project shape.
- The public OpenAPI file in `straddle-docs` is the source for Straddle API operations.
- The generated project lives under `packages/cli/straddle-pp-cli` so it does not disrupt the current plugin package.
- Hand-authored docs and validation live outside the generated Go internals.
- Ramp comparison is a checklist after generation, not an implementation input.
- Stainless comparison is a behavior checklist after generation, not a source input.
- Hand-authored command behavior should use a documented patch layer with `// PATCH:` comments and `.printing-press-patches.json`, not direct root registration edits that generation can overwrite.

## Task List

### Phase 1: Foundation

#### Task 1: Normalize the generated Printing Press baseline

**Description:** Keep or regenerate the default Printing Press output from the full public Straddle OpenAPI spec under `packages/cli/straddle-pp-cli`. Remove only incomplete artifacts if the generator left a broken partial tree, then rerun the generator from `/tmp/straddle-cli-research-generator`. Keep source files and manifests, but remove local build binaries from `build/stage/bin` unless a reviewer identifies a release packaging reason to keep them.

**Acceptance criteria:**

- [ ] `packages/cli/straddle-pp-cli/.printing-press.json` exists.
- [ ] `packages/cli/straddle-pp-cli/spec.json` exists and identifies `Straddle API`.
- [ ] `packages/cli/straddle-pp-cli/cmd/straddle-pp-cli/main.go` exists.
- [ ] `packages/cli/straddle-pp-cli/cmd/straddle-pp-mcp/main.go` exists, or the missing MCP output is documented as a blocker.
- [ ] Generated commands include customers and charges.
- [ ] Local build binaries are removed or explicitly justified.

**Verification:**

- [ ] Run `git status --short --untracked-files=all`.
- [ ] Run `jq '.info.title' packages/cli/straddle-pp-cli/spec.json`.
- [ ] Run `find packages/cli/straddle-pp-cli/cmd -maxdepth 2 -type f -print`.

**Dependencies:** None.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/**`

**Estimated scope:** Medium, generated output only.

#### Task 2: Add CLI package documentation

**Description:** Add `packages/cli/README.md` that explains what the preview is, how it is generated, how to verify it, and how to compare it with Ramp and the Stainless CLI.

**Acceptance criteria:**

- [ ] The README states that Printing Press is required.
- [ ] The README names the public OpenAPI source file.
- [ ] The README says Ramp is a benchmark only.
- [ ] The README says Stainless is a reference only.
- [ ] The README lists first-slice gaps and follow-up workflow areas.
- [ ] The README includes exact regeneration and verification commands.

**Verification:**

- [ ] Read `packages/cli/README.md`.
- [ ] Confirm every acceptance item appears in plain English.

**Dependencies:** Task 1.

**Files likely touched:**

- `packages/cli/README.md`

**Estimated scope:** Small.

### Phase 2: Validation

#### Task 3: Add fast generated-artifact validation

**Description:** Add a lightweight validation script that checks for the required generated files and basic spec provenance without building Go or requiring network access. Wire it into the root validation flow only if it remains fast and deterministic.

**Acceptance criteria:**

- [ ] Validation fails when `.printing-press.json` is missing.
- [ ] Validation fails when CLI `main.go` is missing.
- [ ] Validation fails when `spec.json` is missing or does not identify `Straddle API`.
- [ ] Validation checks MCP files if the generated MCP binary exists.
- [ ] Root `npm run validate` includes the check, or the README explains why it is intentionally separate.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Run the new validation script directly if it is separate.

**Dependencies:** Task 1.

**Files likely touched:**

- `scripts/validate.js`
- Optional `scripts/validate-cli.js`
- Optional `packages/cli/package.json`

**Estimated scope:** Small.

#### Task 4: Verify generated Go project

**Description:** Run generated Go verification and document exact results. Fix only small generated-project issues that are clearly required for local build success and do not change API behavior.

**Acceptance criteria:**

- [ ] `go test ./...` is run in the generated project.
- [ ] `go build -o /tmp/pp-cli-verify ./cmd/straddle-pp-cli` is run.
- [ ] `go build -o /tmp/pp-mcp-verify ./cmd/straddle-pp-mcp` is run if MCP exists.
- [ ] `/tmp/pp-cli-verify --help` is run.
- [ ] `/tmp/pp-cli-verify agent-context --json` is run.
- [ ] `rm -f /tmp/pp-cli-verify /tmp/pp-mcp-verify` is run.
- [ ] Any failure is documented with command and cause.
- [ ] No production API call is made.

**Verification:**

- [ ] Capture command results in the implementer report.
- [ ] If a small fix is made, rerun the failing command.

**Dependencies:** Task 1.

**Files likely touched:**

- Usually none.
- Generated Go files only if a small build fix is necessary.

**Estimated scope:** Medium.

### Phase 3: Review and Comparison

#### Task 5: Add comparison checklist

**Description:** Add or update docs with a checklist that compares the Printing Press baseline against Ramp and the Stainless CLI without turning either into the architecture.

**Acceptance criteria:**

- [ ] Ramp comparison covers installer, auth, agent JSON, command grammar, skills, MCP, docs, and word art.
- [ ] Stainless comparison covers existing Straddle resource coverage and useful flags.
- [ ] Checklist separates launch blockers from later polish.
- [ ] Practical Straddle workflow gaps are listed: setup, customers, payments, reconciliation, fraud monitoring, collections, reporting, monitoring, sandbox testing, docs search.

**Verification:**

- [ ] Read the checklist and confirm every acceptance item appears.

**Dependencies:** Tasks 1 and 2.

**Files likely touched:**

- `packages/cli/README.md`

**Estimated scope:** Small.

#### Task 6: Run two-stage subagent review

**Description:** Dispatch a spec compliance reviewer against the spec and plan, then dispatch a separate code-quality reviewer against the resulting diff. Future quality reviewers for this CLI work must explicitly apply `agent-skills:code-review-and-quality` and `straddle-engineering:code-review` where applicable. When reviewing Go or Node CLI code, mark .NET-specific Straddle checklist items N/A instead of forcing CleanCQRS, nullable reference, or C# test-convention rules onto the CLI. The implementer fixes any required findings before completion.

**Acceptance criteria:**

- [ ] Spec reviewer returns no blocking findings.
- [ ] Code-quality reviewer returns no blocking findings.
- [ ] Code-quality reviewer states that `agent-skills:code-review-and-quality` and `straddle-engineering:code-review` were applied where applicable.
- [ ] Go or Node CLI reviews mark .NET-specific Straddle checklist items N/A when they do not apply.
- [ ] Any accepted fix is verified.

**Verification:**

- [ ] Reviewer reports are included in the controller final summary.
- [ ] `git status --short` shows only intended changes.

**Dependencies:** Tasks 1 through 5.

**Files likely touched:**

- Depends on review findings.

**Estimated scope:** Small to medium.

### Phase 4: CLI Contract and Honesty

#### Task 7: Add safe token input contract

**Description:** Add a launch-blocker reduction for auth setup by planning a safe token input path, then implementing the smallest accepted path in the next coding slice. The preferred command shape is `auth set-token --stdin`. An equivalent is acceptable only if it does not echo the token and does not pass the token through argv.

**Acceptance criteria:**

- [ ] The command contract for `auth set-token --stdin`, or the chosen equivalent, is written before code changes.
- [ ] README auth docs name the supported env, config, and stdin or equivalent paths.
- [ ] Docs state that tokens must not be committed, printed in logs, or passed in argv.
- [ ] The command help makes the safe path discoverable.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Run generated Go tests for the touched package.
- [ ] Run a CLI help or dry-run check that proves the token path is discoverable without printing a token.
- [ ] Run a spec review subagent before implementation and a quality review subagent after implementation.

**Dependencies:** Tasks 1 through 6.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/**`
- `packages/cli/README.md`

**Estimated scope:** Small.

#### Task 8: Document the earlier agent JSON stream gap

**Description:** Document the `--agent` output behavior from the docs slice before Task 14. Provenance-backed generated list and read commands now emit the target envelope, `printJSONFiltered` local helpers emit the target envelope under `--agent`, `agent-context --agent` emits the target envelope, and `about --agent` emits the target envelope for local preview status. Task 14 now closes the stream-envelope gap for `sync --agent` and real `tail --agent`. The broader public CLI launch remains incomplete.

**Acceptance criteria:**

- [ ] `packages/cli/README.md` explains that provenance-backed generated list/read output uses the target envelope.
- [ ] `packages/cli/README.md` explains that `printJSONFiltered` local helpers and `agent-context --agent` use the target envelope under `--agent`.
- [ ] `packages/cli/README.md` explains that `about --agent` uses the target envelope.
- [ ] `packages/cli/README.md` no longer describes `sync --agent` and real `tail --agent` streams as missing the target envelope after Task 14.
- [ ] No broad generated-code rewrite is made for the target envelope in this slice.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Run `rg -n 'agent JSON|not launch-ready|target envelope|about --agent|sync --agent|tail --agent' packages/cli/README.md cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`.
- [ ] Run spec and quality review subagents.

**Dependencies:** Tasks 1 through 7.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/**`
- `packages/cli/README.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`

**Estimated scope:** Small to medium.

#### Task 9: Make generated install docs honest

**Description:** Update generated README and SKILL install docs so they do not imply unavailable published artifacts. The docs must clearly separate local preview, future release, MCP registration, and public launch.

**Acceptance criteria:**

- [ ] Generated README install guidance says the package is a local preview.
- [ ] Generated SKILL install guidance says the package is a local preview.
- [ ] Future release and public launch are described as future states, not current availability.
- [ ] MCP registration guidance uses the generated `straddle-pp-mcp` binary and does not imply a separate hand-built MCP tree.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Run `rg -n 'local preview|future release|MCP registration|public launch' packages/cli/straddle-pp-cli/README.md packages/cli/straddle-pp-cli/SKILL.md packages/cli/README.md`.
- [ ] Run spec and quality review subagents.

**Dependencies:** Tasks 1 through 6.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/README.md`
- `packages/cli/straddle-pp-cli/SKILL.md`
- `packages/cli/README.md`

**Estimated scope:** Small.

#### Task 10: Add MCP smoke instructions

**Description:** Add a small MCP smoke check that proves `straddle-pp-mcp` starts and exposes generated tools from the same generated command tree. Do not hand-build a separate MCP tree and do not hand-edit MCP tools to expose workflow commands.

**Acceptance criteria:**

- [ ] The smoke instructions build or run `straddle-pp-mcp` from `packages/cli/straddle-pp-cli`.
- [ ] The smoke instructions prove generated tools are exposed.
- [ ] The smoke instructions do not require production credentials.
- [ ] The docs state that MCP tools come from the generated command tree.

**Verification:**

- [ ] Run `go build -o /tmp/pp-mcp-verify ./cmd/straddle-pp-mcp`.
- [ ] Run the documented MCP smoke command and capture the generated tool exposure result.
- [ ] Run `rm -f /tmp/pp-mcp-verify`.
- [ ] Run spec and quality review subagents.

**Dependencies:** Tasks 1 through 6.

**Files likely touched:**

- `packages/cli/README.md`
- `packages/cli/straddle-pp-cli/README.md`
- Optional generated MCP docs under `packages/cli/straddle-pp-cli/`

**Estimated scope:** Small.

#### Task 11: Add sandbox-safe read-only walkthrough

**Description:** Add one setup walkthrough that uses sandbox-safe configuration and read-only customer and payment exploration. Add a first-class help-only `sandbox guide [scenario]` flow for sandbox testing scenarios. It must not make production calls and must not create customers, charges, payouts, or other payment-side effects.

**Acceptance criteria:**

- [ ] The walkthrough starts with local preview setup.
- [ ] The walkthrough uses sandbox-safe configuration.
- [x] `setup check` exists as a local-only first-run readiness preflight and points to safe next commands.
- [ ] Customer exploration is read-only.
- [ ] Payment exploration is read-only.
- [ ] The walkthrough states that production calls are out of scope for this slice.
- [x] `sandbox guide [scenario]` exists as local guidance only and covers the previous `/sandbox-test` scenarios.
- [x] `sandbox guide` blocks `--deliver` and exposes `sandbox_guide` as an MCP read-only shell-out tool.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Dry-read every walkthrough command and classify it as local, help-only, config-only, or read-only sandbox.
- [x] Run focused sandbox and MCP tests for the help-only command.
- [x] Run focused setup tests for local-only JSON, environment classification, agent envelope, and deliver rejection.
- [ ] Run spec and quality review subagents.

**Dependencies:** Tasks 7 through 10.

**Files likely touched:**

- `packages/cli/README.md`
- Optional generated docs under `packages/cli/straddle-pp-cli/`

**Estimated scope:** Small.

#### Task 12: Document the patch layer

**Description:** Document how hand-authored CLI behavior should survive regeneration. Use `// PATCH:` comments in touched generated code and track the patch list in `.printing-press-patches.json`. Do not hand-edit root registration as the extension point, because generation can overwrite it.

**Acceptance criteria:**

- [ ] `.printing-press-patches.json` is documented as the list of intentional local patches.
- [ ] `// PATCH:` comments are required for hand-authored generated-code changes.
- [ ] Docs state that root registration is generated and should not be hand-edited for workflow exposure.
- [ ] Docs state that MCP workflow exposure must come from the generated command tree or a documented patch, not a separate MCP tree.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Run `rg -n 'PATCH:|.printing-press-patches.json|patch layer|root registration' packages/cli cli-plans`.
- [ ] Run spec and quality review subagents.

**Dependencies:** Tasks 1 through 6.

**Files likely touched:**

- `packages/cli/README.md`
- Optional `.printing-press-patches.json`
- Optional generated code only if Task 7 or Task 8 needs a scoped patch

**Estimated scope:** Small.

#### Task 13: Run Phase 4 review gates and audit update

**Description:** After Tasks 7 through 12, run the required review gates and update the completion audit. The audit must say what was implemented, what remains incomplete, and what proves each claim. The Phase 4 scorecard lives at `cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md` and is the single place that combines dogfood checks, verification commands, caveats, and launch readiness status.

**Acceptance criteria:**

- [ ] A spec review subagent returns no blocking findings.
- [ ] A quality review subagent returns no blocking findings.
- [x] The audit records the Phase 4 outcome and does not claim full public launch completion.
- [x] The audit keeps later workflow engine work out of this slice.
- [x] The scorecard records dogfood checks for `about`, `setup check`, `docs search --source commands`, `sandbox guide`, `ops guide`, agent envelopes, MCP smoke/count, and patch manifest validity.
- [x] The scorecard records the sandbox caveat for broad Go and MCP tests that need localhost bind.
- [x] Final status shows only intended changes.

**Verification:**

- [x] Run `npm run validate`.
- [x] Run `git diff --check`.
- [x] Run the scorecard text check:
  ```bash
  rg -n '2026-05-09-straddle-cli-shipcheck-scorecard|about|setup check|docs search --source commands|sandbox guide|ops guide|agent envelope|MCP smoke|patch manifest|localhost bind|Partial' cli-plans packages/cli/README.md
  ```
- [x] Run the generated Go verification commands needed by touched files, or record why they were not needed for docs-only changes. Current slice touched planning docs only, so generated Go verification was not needed.
- [x] Run the text check for banned punctuation, banned terms, and emoji.
- [x] Run `git status --short`.

**Dependencies:** Tasks 7 through 12.

**Files likely touched:**

- `cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`

**Estimated scope:** Small.

#### Task 14: Implement stream agent envelopes

**Description:** Implemented in Task 14. `sync --agent` and real `tail --agent` now use the Streaming Agent Contract. Normal human output and normal `--json` streaming behavior remain backward compatible. Command semantics changed only by wrapping agent stream lines in the target envelope. This completes the stream-envelope slice, not the full public CLI launch.

**Acceptance criteria:**

- [ ] `sync --agent` writes one JSON object per line to stdout using the target envelope keys: `schema_version`, `data`, `pagination`, `warnings`, `trace_id`, and `error`.
- [ ] Real `tail --agent` writes one JSON object per line to stdout using the same target envelope keys.
- [ ] Each agent stream line has a stable event name in `data.event`.
- [ ] Each agent stream line includes an ISO timestamp in `data.timestamp` when the source event has one.
- [ ] Stream payloads do not include secrets or token-shaped values.
- [ ] Human status chatter stays on stderr, and agent stream data stays on stdout.
- [ ] Existing `sync_start`, `sync_warning`, `sync_summary`, and real tail data events map into the `data` payload.
- [ ] `sync_summary` and final tail shutdown or end events are final envelope lines, not out-of-band text.
- [ ] Normal human output and normal `--json` stream behavior remain backward compatible unless a deliberate breaking change is approved.

**Verification:**

- [ ] Run `npm run validate`.
- [ ] Run `go test ./...` from `packages/cli/straddle-pp-cli`.
- [ ] Build the CLI to `/tmp`:
  ```bash
  cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
  go build -o /tmp/pp-cli-stream-verify ./cmd/straddle-pp-cli
  ```
- [ ] Run a unit test or local fake-server `sync --agent` check that proves every stdout line parses as JSON and has the target envelope keys. Do not use the real Straddle API for this verification unless live smoke has been explicitly approved.
- [ ] Run a unit test or local fake-server `tail --agent` check that proves every stdout line parses as JSON and has the target envelope keys. Do not use the real Straddle API for this verification unless live smoke has been explicitly approved.
- [ ] Terminate the `tail --agent` fixture with a context cancellation or signal and assert that the final shutdown or end event is emitted as an envelope line.
- [ ] Confirm human/status output is on stderr and agent data is on stdout.
- [ ] Run:
  ```bash
  rg -n 'sync --agent|tail --agent|sync_summary|Streaming Agent Contract|target envelope' cli-plans packages/cli/README.md packages/cli/straddle-pp-cli/README.md packages/cli/straddle-pp-cli/SKILL.md
  ```
- [ ] Remove `/tmp/pp-cli-stream-verify`.

**Dependencies:** This docs/spec slice.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/**`
- `packages/cli/README.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`

**Estimated scope:** Small to medium.

#### Task 15: Implement docs search terminal flow

**Description:** Implemented as a bounded patch-layer command. `docs search <query>` is separate from the existing local synced-data `search` command. Product docs search is the default and uses the unauthenticated product docs MCP endpoint. Command search is local through the generated capability index. API and SDK sources return structured guidance for the `search_docs` MCP source instead of pretending local data search covers reference docs.

**Acceptance criteria:**

- [x] `docs search <query>` exists under a `docs` command tree.
- [x] Root registration has a `// PATCH:` comment and generated endpoint commands are untouched.
- [x] `--source product|commands|api|sdk` is supported, defaulting to `product`.
- [x] Product docs search accepts `--endpoint` and `STRADDLE_DOCS_MCP_URL` only for loopback local tests and does not require Straddle API auth.
- [x] `--source commands` uses `whichIndex` and `rankWhich`.
- [x] `--source api` and `--source sdk` return guidance for the `search_docs` MCP source.
- [x] `--limit`, `--dry-run`, `--json`, and `--agent` are covered.
- [x] `--agent` output uses the target envelope through the existing local JSON helper path.

**Verification:**

- [x] Run `go test -count=1 ./internal/cli -run 'Test.*Docs'`.
- [x] Run `go test -count=1 ./internal/cli -run 'Test.*Docs|Test.*Search|Test.*Which'`.
- [x] Run `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json`.
- [x] Run `npm run validate`.

**Dependencies:** Product docs skill behavior and existing `which` capability index.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/internal/cli/docs.go`
- `packages/cli/straddle-pp-cli/internal/cli/docs_test.go`
- `packages/cli/straddle-pp-cli/internal/cli/root.go`
- `packages/cli/README.md`
- `packages/cli/straddle-pp-cli/README.md`
- `packages/cli/straddle-pp-cli/SKILL.md`
- `packages/cli/straddle-pp-cli/.printing-press-patches.json`
- `cli-plans/2026-05-09-straddle-printing-press-cli-spec.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-plan.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`

**Estimated scope:** Small.

#### Task 16: Implement ops guide terminal flow

**Description:** Implemented as a bounded patch-layer command. `ops guide [workflow]` is local-only operational planning guidance for reconciliation, fraud monitoring, collections, reporting, and monitoring. It returns docs lookup queries, read-side CLI surfaces to inspect, safe next steps, and safety metadata. It does not call Straddle APIs, call docs endpoints, execute MCP tools, post webhooks, or write production data. Live operational execution requires separate approval and a fresh docs lookup.

**Acceptance criteria:**

- [x] `ops guide [workflow]` exists under an `ops` command tree.
- [x] Supported workflows are `reconciliation`, `fraud-monitoring`, `collections`, `reporting`, and `monitoring`.
- [x] The command lists supported workflows when no workflow is provided.
- [x] Each supported workflow returns docs lookup queries and local next steps.
- [x] Safety metadata states that the command is guidance-only and does not call APIs, docs endpoints, MCP, webhooks, or production.
- [x] `ops guide` rejects `--deliver` before webhook delivery.
- [x] `ops guide --agent` uses the target envelope through the existing local JSON helper path.
- [x] MCP runtime exposure includes `ops_guide` as a read-only Cobra shell-out tool.

**Verification:**

- [x] Run focused ops-guide CLI tests for workflow list, named workflow coverage including reporting and monitoring, invalid workflow, agent envelope, and deliver rejection.
- [x] Run focused MCP tests for `ops_guide` shell-out exposure, read-only metadata, and runtime count 83.
- [x] Run `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json`.
- [x] Run targeted docs text checks for `ops guide`, `ops_guide`, supported workflow names, and runtime count `83` / shell-out count `10`.

**Dependencies:** Existing local JSON helper path, MCP Cobra shell-out exposure, and docs-search guidance.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/internal/cli/ops.go`
- `packages/cli/straddle-pp-cli/internal/cli/ops_test.go`
- `packages/cli/straddle-pp-cli/internal/cli/root.go`
- `packages/cli/straddle-pp-cli/internal/mcp/tools.go`
- `packages/cli/straddle-pp-cli/internal/mcp/tools_test.go`
- `packages/cli/straddle-pp-cli/internal/mcp/cobratree/classify_test.go`
- `packages/cli/README.md`
- `packages/cli/straddle-pp-cli/README.md`
- `packages/cli/straddle-pp-cli/SKILL.md`
- `packages/cli/straddle-pp-cli/.printing-press-patches.json`
- `cli-plans/2026-05-09-straddle-printing-press-cli-plan.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`

**Estimated scope:** Small.

#### Task 17: Add local packaging readiness proof

**Description:** Reduce the packaging blocker without claiming a public launch. Fix stale release metadata, keep the generated MCP sibling in release packaging, and add a local command that builds both preview binaries without requiring GoReleaser.

**Acceptance criteria:**

- [x] GoReleaser metadata no longer contains stale Postman Homebrew text.
- [x] Release archives explicitly include both `straddle-pp-cli` and `straddle-pp-mcp`.
- [x] A Makefile command builds both binaries into a local dist directory and verifies they exist.
- [x] Docs describe the command as a local proof only, not public release availability.
- [x] Docs keep public `npx`, pre-built binaries, public installer, Homebrew tap publishing, and desktop MCP packaging as future work.

**Verification:**

- [x] Run `make package-readiness` from `packages/cli/straddle-pp-cli`.
- [x] Run `go test -count=1 ./...` from `packages/cli/straddle-pp-cli`.
- [x] Run `npm run validate`.
- [x] Run `git diff --check`.
- [x] Run targeted text checks proving docs still say local preview and future release, not public availability.

**Dependencies:** Existing generated CLI and MCP sibling.

**Files likely touched:**

- `packages/cli/straddle-pp-cli/.goreleaser.yaml`
- `packages/cli/straddle-pp-cli/Makefile`
- `packages/cli/straddle-pp-cli/README.md`
- `packages/cli/straddle-pp-cli/SKILL.md`
- `packages/cli/README.md`
- `cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md`

**Estimated scope:** Small.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Printing Press generates a large tree | Medium | Keep hand-authored changes outside generated internals and validate shape first. |
| Full OpenAPI has schema issues | Medium | Use `--lenient`, document exact blocker if generation or Go verification fails. |
| Generated MCP exists but is not polished | Low for first slice | Preserve it, verify presence, and put polish in the gap list. |
| Ramp comparison drives architecture drift | High | Treat Ramp only as checklist language in docs. |
| Stainless CLI hides useful Straddle flags | Medium | Compare behavior after Printing Press baseline exists. |
| Root validation gets slow | Medium | Keep Go builds outside root validation unless proven fast. |
| Generated registration overwrites local workflow edits | High | Use the patch layer with `// PATCH:` comments and `.printing-press-patches.json`; avoid root registration as the workflow extension point. |
| Docs imply a release path that does not exist yet | High | Separate local preview, future release, MCP registration, and public launch in generated docs. |
| Broad uncommitted slices become hard to review | High | After a slice passes spec review, quality review, and verification, stage only intended files and make a small commit before starting the next slice. Commit the current baseline in logical chunks: generated baseline first, then hand-authored docs, validation, plans, and audit updates. |

## Open Questions

- Should the preview eventually replace the public binary name `straddle`, or stay `straddle-pp-cli` until launch?
- Should keychain credential storage be a launch blocker?
- Which approved live-read operational workflow should follow the local-only `ops guide` planning slice?

## Completion Audit Checklist

- [ ] Spec file exists and covers objective, commands, structure, style, testing, boundaries, and success criteria.
- [ ] Plan file exists and every task has acceptance criteria and verification.
- [ ] Generated baseline exists from Printing Press.
- [ ] CLI package docs exist.
- [ ] Fast validation exists and passes.
- [ ] Go verification is run or a concrete blocker is recorded.
- [ ] Ramp comparison is documented as checklist only.
- [ ] Stainless comparison is documented as reference only.
- [ ] Spec review passes.
- [ ] Code-quality review passes.
- [ ] Each completed slice is committed in a small intended-files-only commit before the next implementation slice starts.
- [ ] Phase 4 CLI contract and honesty slice is either completed and reviewed or explicitly still pending.
- [ ] Final `git status --short` shows only intended changes.
