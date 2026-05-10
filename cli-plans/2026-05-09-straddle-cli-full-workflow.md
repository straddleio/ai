# Straddle CLI Full Workflow

## Purpose

This is the master workflow for the Straddle Printing Press CLI. Every implementation loop must follow it before and during each slice. Do not mark the goal complete until every explicit requirement maps to concrete evidence in the audit, plan, docs, generated project, verification output, or reviewer report.

This workflow is planning and documentation for the CLI effort. It does not authorize implementation code changes.

## Fixed Constraints

- Work in `/Users/js/clawd/straddle/straddle-ai`.
- Do not edit `providers/*` synced copies unless the task is an explicit sync task.
- Printing Press is required for the generated Go CLI and generated MCP server.
- Ramp is a benchmark only. Use it to check ergonomics, not architecture.
- Stainless is a reference only. Use it to compare behavior, not as source code.
- Do not make production API calls.
- Do not read, print, commit, or ask for secrets.
- Live smoke, when approved, must be read-only and sandbox-safe.
- No implementation slice starts until the prior slice has spec review, quality review, verification, and a small intended-files-only commit.

## Execution Roles

- Implementer subagent: performs one scoped slice from the plan and reports changed files, commands, evidence, and open risks.
- Spec reviewer subagent: checks the slice against the spec, this workflow, and the plan before quality review.
- Quality reviewer subagent: checks maintainability, safety, local conventions, generated-code boundaries, and verification.
- Optional explorer subagent: researches API identity, competitors, MCP and skill ecosystems, browser traces, or prior artifacts without editing files.
- Controller: keeps scope tight, selects the next slice, applies reviewer findings, stages only intended files, and commits after the slice passes.

## Loop Rules

1. Start each slice by mapping the slice to the phase table below.
2. Reuse existing evidence before creating new research.
3. Run the phase deliverables that apply to the slice.
4. Have a spec reviewer approve the slice before quality review.
5. Have a quality reviewer approve the slice before completion.
6. Run verification after fixes, not just before review.
7. Update the audit with what happened, what is still missing, and what proves each claim.
8. Commit only intended files after the slice passes spec review, quality review, and verification.
9. Do not start the next slice until that commit exists, unless the user explicitly pauses commit work.

## Phase Status

| Phase | Status | Current Evidence |
|-------|--------|------------------|
| Phase 0 Resolve + Reuse | Artifact created, pending final phase-artifact review | Resolve and reuse artifact exists. Do not treat it as fully accepted until final phase-artifact review passes. |
| Phase 1 Research Brief | Artifact created, pending final phase-artifact review | Research brief exists and competitor benchmark exists. Do not treat them as fully accepted until final phase-artifact review passes. |
| Phase 1.5 Ecosystem Absorb Gate | Artifact created, pending final phase-artifact review | Ecosystem absorb artifact exists. Do not treat it as fully accepted until final phase-artifact review passes. |
| Phase 1.7 Browser-Sniff Gate | Artifact created, pending final phase-artifact review | Browser-sniff artifact exists, with HAR fallback noted. Do not treat it as fully accepted until final phase-artifact review passes. |
| Phase 2 Generate | Done | Printing Press generated the Go CLI and MCP server from the Straddle public OpenAPI spec. Root validation and Go verification passed for the first slice. |
| Phase 3 Build workflow commands | Partial | Generated baseline exists. Local-only helper commands now cover docs search, sandbox guide, setup check, ops guide, smoke plan, and release plan. Approved live workflow execution and full workflow engines have not been built. |
| Phase 4 Shipcheck | Partial | Dogfood-style verification, fix verification, review history, audit updates, local packaging proof, local archive validation, local-preview product review, smoke-plan work, release-plan work, and the scorecard at `cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md` exist for the current preview slice. Public launch readiness remains partial because public release, actual approved live smoke, public-launch product review, and richer live workflow commands are incomplete. |
| Phase 5 Live Smoke | Not done | No read-only API smoke or data-flow check has been run. |

## Phase 0 Resolve + Reuse

Timebox: 1-3 min.

What happens:

- Reuse existing research, specs, plans, audits, README notes, generated artifacts, and reviewer findings.
- Detect token requirements without requesting, exposing, or using real secrets.
- Resolve the source spec, URL, or local file path before generation or validation.

Evidence required:

- Exact source file or URL for the Straddle OpenAPI spec.
- Exact paths for existing spec, plan, audit, generated CLI, generated MCP, and README.
- Token discovery result stated as a requirement or gap, not a secret value.
- List of reused artifacts with dates or file paths.

Deliverables:

- Reuse notes in the audit or implementer report.
- Confirmed spec source.
- Confirmed no-secret boundary.

Review gate:

- Spec reviewer confirms the slice uses the resolved source and does not invent inputs.

## Phase 1 Research Brief

Timebox: 5-10 min.

What happens:

- Identify the API identity: product name, source spec, auth model, CLI target, MCP sibling, and launch surface.
- Compare competitors only enough to extract useful expectations.
- Understand the data layer only enough to avoid unsafe assumptions.
- State the product thesis in plain English.

Evidence required:

- API source and auth model with file paths or primary docs.
- Competitor notes separated from implementation decisions.
- Data-flow notes that distinguish local CLI behavior, sandbox API behavior, and production API behavior.
- Product thesis stated in one short paragraph.

Deliverables:

- Research brief.
- Launch-blocker list.
- Non-goals list.

Review gate:

- Spec reviewer confirms research claims are sourced and that Ramp and Stainless are not treated as architecture.

## Phase 1.5 Ecosystem Absorb Gate

Timebox: 5-10 min.

What happens:

- Catalog every relevant MCP, skill, CLI command, manifest field, generated command, and helper script.
- Absorb manifest details before planning new commands.
- Record novel suggestions, but separate them from required implementation.

Evidence required:

- Paths to plugin manifests, skill manifests, CLI command roots, MCP configs, generated command roots, and validation scripts.
- Inventory of generated CLI and MCP surfaces.
- Notes on missing or duplicated capabilities.

Deliverables:

- Ecosystem catalog.
- Absorbed-feature checklist.
- Novel suggestion list with status: required, later, or rejected.

Review gate:

- Spec reviewer confirms the next implementation slice is based on the catalog, not a guessed feature list.

## Phase 1.7 Browser-Sniff Gate

Timebox: 2-5 min.

What happens:

- Capture relevant browser behavior when the workflow depends on real docs, API consoles, generated docs, or CLI web output.
- Import HAR or browser evidence when useful.
- Record discovery provenance so later agents can tell what was observed.

Evidence required:

- Browser target URL or local file path.
- Screenshot, DOM notes, HAR import, or explicit reason browser capture was not needed.
- Date, command, or tool used for capture.

Deliverables:

- Browser evidence note.
- Discovery provenance entry.

Review gate:

- Quality reviewer confirms browser-derived claims have visible evidence or are excluded from the slice.

## Phase 2 Generate

Timebox: 1-2 min.

What happens:

- Generate the Go CLI and MCP server from the resolved Straddle public OpenAPI spec using Printing Press.
- Validate the generated project shape.
- Keep hand-authored behavior outside generated internals unless a documented patch is required.

Evidence required:

- `.printing-press.json`.
- `spec.json` identifying `Straddle API`.
- Go CLI entrypoint under `cmd/straddle-pp-cli`.
- MCP entrypoint under `cmd/straddle-pp-mcp`.
- Validation output showing required files exist.

Deliverables:

- Generated CLI tree.
- Generated MCP tree.
- Validation report.

Review gate:

- Spec reviewer confirms the generated project uses Printing Press and the resolved Straddle spec.
- Quality reviewer confirms no provider synced copies were edited and no local binaries or secrets were committed.

## Phase 3 Build workflow commands

Timebox: 10-20 min.

What happens:

- Build from absorbed features and verified user workflows.
- Add the strongest practical Straddle workflows only after the ecosystem catalog exists.
- Include new workflow commands only when they have a concrete user workflow, safe API boundary, and verification path.

Evidence required:

- Mapping from each added command to an absorbed feature, user workflow, or explicit gap.
- CLI help or dry-run output for each command.
- Safety classification: local-only, help-only, config-only, read-only sandbox, or blocked.
- Patch-layer evidence for hand-authored generated-code changes.

Deliverables:

- Implemented workflow commands.
- Agent-friendly command docs.
- Patch manifest updates when needed.

Review gate:

- Spec reviewer confirms every new command maps to a requirement.
- Quality reviewer confirms no production calls, no secrets, no unsafe root registration edits, and no separate hand-built MCP tree.

## Phase 4 Shipcheck

Timebox: 3-8 min.

What happens:

- Dogfood the CLI locally.
- Verify every fix after review.
- Produce one scorecard block that combines verification, gaps, and launch readiness.

Evidence required:

- Root validation output.
- Generated Go test and build output when generated Go files or docs that reference commands changed.
- CLI help or dry-run output for touched command paths.
- MCP build or smoke output when MCP behavior is touched.
- Spec review report.
- Quality review report.
- Final `git status --short`.

Deliverables:

- Shipcheck scorecard.
- Updated completion audit.
- Intended-files-only commit.

Review gate:

- Controller confirms all explicit requirements map to evidence before marking any goal complete.

## Phase 5 Live Smoke

Timebox: 2-5 min. Optional.

What happens:

- Run a read-only API smoke only when the user approves or a safe sandbox credential path already exists.
- Check data flow from CLI command to API response and back to output.
- Do not make production calls.

Evidence required:

- Environment classification: sandbox or local only.
- Command classification: read-only.
- Redacted output summary with no secrets.
- Confirmation no create, update, delete, payout, charge, customer creation, or production side effect occurred.

Deliverables:

- Live Smoke note.
- Data-flow check result.
- Any blocker recorded as a gap.

Review gate:

- Quality reviewer confirms the smoke was read-only, sandbox-safe, and free of secrets.

## Completion Audit Rule

The goal is not complete until the audit has a row for every explicit requirement and each row points to concrete evidence. If evidence is missing, mark the row Partial or Not done. Treat uncertainty as incomplete.
