# Public Launch Product Review Gate: Straddle Printing Press CLI

Date: 2026-05-10

Scope: product review gate for the current `straddle-pp-cli` and `straddle-pp-mcp` state in `/Users/js/clawd/straddle/straddle-ai`.

This artifact does not approve public launch, publishing, signing, notarization, live Straddle API calls, production use, public docs, or support commitments.

## Reviewed Evidence

- Completion audit: `cli-plans/2026-05-10-straddle-cli-completion-audit.md`.
- Public launch decision packet: `cli-plans/2026-05-10-straddle-cli-public-launch-decision-packet.md`.
- Local-preview product review: `cli-plans/2026-05-09-straddle-cli-product-review.md`.
- Generated CLI project: `packages/cli/straddle-pp-cli`.
- Local CLI package README: `packages/cli/README.md`.
- Generated CLI README: `packages/cli/straddle-pp-cli/README.md`.
- Generator provenance: `packages/cli/straddle-pp-cli/.printing-press.json`.
- Patch catalog: `packages/cli/straddle-pp-cli/.printing-press-patches.json`.
- OpenAPI source: `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`.

The reviewed evidence says Printing Press `4.2.0` generated `straddle-pp-cli` and `straddle-pp-mcp` from the Straddle OpenAPI source. The latest completion audit records passing local validation, passing Go tests, credential-free CLI smoke, and credential-free MCP `tools/list` smoke with `tool_count: 87`. It also records no public publish, no approved live read-only smoke, no signed or notarized macOS distribution, no desktop MCP package, and no final launch decision for credential storage.

Ramp remains a benchmark only. Stainless remains a downstream behavior reference only. Printing Press remains the generator foundation.

## Decision

Local preview remains approved.

Public launch remains not approved.

The current state is good enough for local product review, command discovery, dry-run request-shape checks, local packaging checks, local MCP inspection, docs search review, and workflow planning review.

It is not good enough for public users because the required launch decisions and live evidence do not exist yet.

## Launch-Ready Locally

- CLI preview path: `packages/cli/straddle-pp-cli`.
- Generated binaries can be built locally from `cmd/straddle-pp-cli` and `cmd/straddle-pp-mcp`.
- `about`, `setup check`, `docs search`, `sandbox guide`, `ops guide`, `workflow plan`, `smoke plan`, `release plan`, and `credentials plan` are documented as local or planning surfaces.
- Agent-mode envelopes are documented for generated list and read paths plus local helper paths covered by the completion audit.
- Local validation and generated Go tests are part of the current evidence set.
- Local archive readiness exists through non-publishing checks, including local archives that contain both CLI and MCP sibling binaries.
- Credential guidance prefers safe stdin or caller-supplied environment injection and warns against checked-in config, logs, argv, and shell history exposure.

## Blocked For Public Launch

- No public release channel has been approved or used.
- No public `straddle` command-name decision has been made.
- No broad-public macOS signing or notarization proof exists.
- No desktop MCP package, hosted MCP relationship decision, or public MCP support model exists.
- Credential launch posture is still not approved for broad public launch. Keychain-backed storage exists as opt-in preview support, but owner/security approval, packaged-client smoke, approved live read-only smoke, and public docs wording are still missing.
- No approved live read-only smoke has run with scoped non-production credentials and redacted expected output.
- Public docs, support ownership, issue intake, and support boundaries are not approved.
- Operational workflow commands remain planning guidance, not proven workflow execution.

## Pass/Fail Criteria

- Command name: pass requires owner decision for public binary name, collision review, migration or alias plan if using `straddle`, and approved public help output. Current result: fail. Current preview name is `straddle-pp-cli`; public `straddle` decision is open.
- Release channel: pass requires approved first channel, fresh non-publishing release check, archive inspection, checksum plan, release notes, rollback plan, and no secret exposure in logs. Current result: fail. Local archive proof exists, but no channel approval or publish plan is accepted.
- macOS signing and notarization: pass requires Apple owner, certificate storage plan, CI signing plan, notarization proof, clean-machine Gatekeeper install evidence, and approved warning text if unsigned preview is allowed. Current result: fail. No signing or notarization proof exists.
- MCP packaging: pass requires desktop client matrix, install and uninstall docs, packaged `straddle-pp-mcp` smoke, secure token-injection examples, hosted MCP relationship decision, and support owner approval. Current result: fail. Local stdio runtime smoke exists only.
- Credential posture: pass requires owner/security approval for the chosen storage posture, packaged-client smoke, approved live read-only smoke, public docs wording, and redaction checks. Current result: fail. Approval remains open.
- Live read-only smoke: pass requires written approval naming environment, credential source, allowed read-only commands, data boundaries, stop criteria, transcript path, and reviewer signoff after redacted results. Current result: fail. No approved live smoke has run.
- Docs and support: pass requires approved install path, command name, known limits, support owner, issue intake, support boundaries, security wording, and final docs review against current behavior. Current result: fail. Local docs are preview-scoped only.
- Operational workflow claims: pass requires public wording that says planning guidance only, or live workflow specs, smoke evidence, error handling, audit logs, and owner signoff proving execution. Current result: fail. Current workflows are planning guidance only.

## Narrow Acceptance Checklist

Future reviewers may change this gate only after all items below are true:

- A launch owner chooses the public binary name and first release channel in writing.
- A security or product owner chooses credential posture in writing.
- A macOS owner records signing and notarization requirements, or explicitly limits distribution to an unsigned preview with approved warning text.
- An MCP owner chooses manual local-build, packaged desktop MCP, hosted MCP, or no public MCP for the first release.
- A read-only live smoke approval packet exists with environment, credential source, allowed commands, transcript path, expected evidence, and stop criteria.
- The approved live smoke runs only against sandbox or another named non-production environment.
- Smoke output is redacted, stored locally, and reviewed for command behavior, environment, object count or empty-list proof, exit code, and token safety.
- Public docs name only approved install paths and support channels.
- Public wording does not claim workflow execution unless that execution is separately specified, tested, and approved.

## Stop Lines

- No production.
- No write commands.
- No token literals.
- No argv tokens.
- No public claims until approved.
- No publishing, uploading, tap pushing, npm publishing, signing, notarization, or release announcements from this gate.
- No public docs that imply `straddle-pp-cli` replaces an approved public `straddle` command.
- No live MCP tool execution unless a future approval names the tool and confirms it is read-only.

## Reviewer Verdict

Keep local preview approved. Keep public launch blocked.

The next useful slice is not more launch copy. It is owner decisions plus one narrow approved live read-only smoke in a non-production environment.
