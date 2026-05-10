# Straddle CLI Shipcheck Scorecard

Date: 2026-05-09

## Verdict

Shipcheck status: Partial, with fresh Phase 4 local dogfood completed, a local packaging readiness proof added, local GoReleaser archive validation completed, local-preview product review completed, local-only live-smoke planning added, local-only release planning added, local-only credential storage planning added, a no-secret packaged-client credential smoke passed, local-only structured workflow planning added, and MCP metadata updated after the command tree changed.

Score: 7.3 of 10 for the current preview slice.

The scorecard now has a fresh local dogfood run from 2026-05-09 16:40 MDT, a packaging readiness slice from 2026-05-09, local GoReleaser archive validation from 2026-05-09 17:25 MDT, a product review artifact at `cli-plans/2026-05-09-straddle-cli-product-review.md`, `straddle-pp-cli smoke plan [scope]` for future approved read-only smoke planning, `straddle-pp-cli release plan [surface]` for local-only public-release readiness planning, `straddle-pp-cli credentials plan [surface]` for local-only credential storage readiness planning, and `straddle-pp-cli workflow plan [workflow]` for structured local-only command planning. Root validation, generated CLI builds, generated MCP builds, focused Go tests, broad Go tests, patch manifest validation, MCP runtime smoke, local package readiness, local snapshot archive build, credential-free local product review, and local packaged-client credential smoke passed before this slice. The full public CLI goal is not complete. Public release, actual approved live smoke, public-launch approval, explicit env/config-only or secure-store approval, and live workflow execution remain open.

## Launch Criteria Scorecard

Generated from Straddle public OpenAPI

- Evidence: `packages/cli/straddle-pp-cli/spec.json` identifies `Straddle API`; `.printing-press.json` records `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`.
- Status: Done for preview.
- Missing work: Recheck after every regeneration.

Printing Press is the generator foundation

- Evidence: Generated project includes `.printing-press.json`, `cmd/straddle-pp-cli`, `cmd/straddle-pp-mcp`, and `internal/mcp`; `packages/cli/README.md` names `mvanhorn/cli-printing-press` as the generator.
- Status: Done for preview.
- Missing work: Release packaging still needs a final generation and review pass.

CLI first, MCP sibling from same command tree

- Evidence: `packages/cli/README.md` states the CLI is primary and `straddle-pp-mcp` is generated from the same tree. The product review approves this CLI-first shape for local preview and confirms the MCP sibling is reviewable through local stdio `tools/list`.
- Status: Done for preview.
- Missing work: Public MCP package or desktop bundle review after packaging exists.

Local preview docs are honest

- Evidence: `packages/cli/README.md` says there is no current public `npx`, prebuilt binary, public-library release link, Hermes install path, or MCP package bundle.
- Status: Done for preview.
- Missing work: Public install docs after packaging exists.

Safe token path exists and is documented

- Evidence: `auth set-token --stdin` and `auth set-token --stdin --keychain` are documented, with environment-token and custom config paths; docs say not to commit, print, log, or pass tokens through argv. `credentials plan [surface]` now documents config-file auth, opt-in keychain auth, environment or secret-manager injection, MCP env injection, packaged-client local smoke guidance, and the remaining launch approval set. The 2026-05-10 packaged-client credential smoke used only local packaged binaries, no credentials, and JSON-RPC `initialize` plus `tools/list`.
- Status: Partial.
- Missing work: Broader auth review, owner/security launch approval, approved live read-only smoke, approved docs wording, signed/notarized packaging posture, desktop MCP packaging posture, and launch approval.

Agent envelopes are documented and covered for current local commands

- Evidence: README documents the target envelope for generated list/read commands, `printJSONFiltered` helpers, `agent-context`, `about`, `setup check`, `sync`, and real `tail`. Fresh local checks show `about --agent` and `setup check --agent` emit the target envelope. `customers list --dry-run --agent` exits 0 and now emits only the target JSON envelope on stdout, with `data.dry_run: true` and no human request preview text. The product review clears this for local preview only.
- Status: Partial.
- Missing work: Public-launch compatibility review after packaging and approved live smoke.

Local dogfood commands exist for preview checks

- Evidence: See the 2026-05-09 Phase 4 dogfood run below for `about`, `setup check`, `docs search --source commands`, `sandbox guide`, `ops guide`, generated command dry-run agent output, MCP smoke/count, patch manifest validity, and Go tests. Later bounded slices added `smoke plan [scope]` as local-only planning for future approved read-only smoke, `release plan [surface]` as local-only public-release readiness guidance, `credentials plan [surface]` as local-only credential storage guidance, and `workflow plan [workflow]` as structured local-only command planning.
- Status: Partial.
- Missing work: Public launch still needs packaging, public-launch product approval, and approved live smoke.

MCP count semantics are resolved

- Evidence: `.printing-press.json` tracks 70 generated endpoint tools; typed Go MCP registrations total 73 including 3 framework typed tools. Focused MCP tests now expect runtime count 87 and include `workflow_plan` with `readOnlyHint: true` and `destructiveHint: false`.
- Status: Done for preview.
- Missing work: Re-run runtime smoke after any future command tree change.

Patch manifest is valid and documented

- Evidence: `.printing-press-patches.json` is documented as the patch catalog; `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json` passed on 2026-05-09.
- Status: Done for preview.
- Missing work: Keep manifest current with every generated-code patch.

Sandbox-safe walkthrough avoids side effects

- Evidence: README keeps setup checks local, customer and payment exploration read-only, and live writes out of scope.
- Status: Partial.
- Missing work: Approved live read-only sandbox smoke with real data flow. `smoke plan [scope]` now makes the runbook explicit, but it does not run live smoke or grant approval.

Approved live-smoke planning exists, but live smoke has not run

- Evidence: `smoke plan [scope]` supports `setup`, `customers`, `payments`, `funding`, `mcp`, `approval`, and `all`; it emits safety metadata requiring explicit approval, secure credential flow, read-only intended commands, no writes, no token literals, and no live execution in the command.
- Status: Partial.
- Missing work: Secure credential approval and actual read-only live smoke execution remain open.

Operational workflows are useful but safe

- Evidence: `ops guide` is local-only guidance for reconciliation, fraud monitoring, collections, reporting, and monitoring. `workflow plan [workflow]` adds structured phases, steps, docs search topics, read-only CLI commands, dry-run commands, blocked write actions, and required approvals for the same workflows plus `all`. The product review approves these as planning flows for local preview, not as live workflow execution.
- Status: Partial.
- Missing work: Live reads, docs lookup execution, MCP execution, webhook delivery, and workflow engines are not built.

Product review completed for local preview

- Evidence: `cli-plans/2026-05-09-straddle-cli-product-review.md` covers CLI-first and MCP sibling relationship, Printing Press/OpenAPI provenance, target envelope, dry-run agent output, setup check, docs search, sandbox guide, ops guide, stream agent contract, practical workflows, Ramp/reference parity, safety, and launch decision.
- Status: Done for local preview.
- Missing work: Public-launch product review after packaging, approved live smoke, and final public docs exist.

Packaging readiness exists, public launch is not ready

- Evidence: `packages/cli/straddle-pp-cli/Makefile` has `make package-readiness`, which builds `straddle-pp-cli` and the generated `straddle-pp-mcp` sibling into `dist/local/`, verifies both binaries exist, and runs a CLI help smoke. `.goreleaser.yaml` now uses `homebrew_casks` instead of deprecated `brews`, has a Straddle CLI Homebrew description instead of stale Postman text, and keeps both binaries in the future cask install intent. `go run github.com/goreleaser/goreleaser/v2@latest release --snapshot --clean --skip=publish` built local snapshot archives for darwin, linux, and windows; inspected darwin and windows archives contained both binaries plus `LICENSE` and `README.md`.
- Status: Partial.
- Missing work: No release archives were published, no Homebrew tap was updated, no public installer or `npx` path exists, and there is still no desktop MCP package bundle.

## Dogfood Checklist

These commands are the local preview checks for the command paths already built. They are safe because they are local, help-only, dry-run, or read-only unless a later live smoke is explicitly approved.

Run from the generated CLI project:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go build -o /tmp/straddle-pp-cli ./cmd/straddle-pp-cli
```

- Local preview identity: `/tmp/straddle-pp-cli about`.
  Status: Built and documented. Human output should include Straddle word art and preview status.
- About agent envelope: `/tmp/straddle-pp-cli about --agent`.
  Status: Built and documented. Output should use the target envelope.
- Setup preflight: `/tmp/straddle-pp-cli setup check --json`.
  Status: Built and documented. Local-only, no API, docs, MCP, webhook, or production call.
- Setup agent envelope: `/tmp/straddle-pp-cli setup check --agent`.
  Status: Built and documented. Output should use the target envelope.
- Command docs search: `/tmp/straddle-pp-cli docs search payment --source commands --json`.
  Status: Built and documented. Searches local generated command capabilities.
- Sandbox guide: `/tmp/straddle-pp-cli sandbox guide --json`.
  Status: Built and documented. Help-only guidance, no live write.
- Ops guide: `/tmp/straddle-pp-cli ops guide reconciliation --json`.
  Status: Built and documented. Local-only guidance, no live operation.
- Smoke plan: `/tmp/straddle-pp-cli smoke plan approval --json` and `/tmp/straddle-pp-cli smoke plan all --json`.
  Status: Built and documented. Local-only runbook and approval packet guidance, no live smoke execution or approval.
- Release plan: `/tmp/straddle-pp-cli release plan all --json`.
  Status: Built and documented. Local-only public-release readiness guidance, no publishing, external calls, signing, notarization, MCP execution, or secrets.
- Credentials plan: `/tmp/straddle-pp-cli credentials plan all --json`.
  Status: Built and documented. Local-only credential storage readiness guidance, including packaged-client local smoke commands. No package builds, binary execution, secret reads, credential writes, API calls, docs calls, MCP execution, publishing, signing, notarization, or launch approval.
- Generated command agent envelope: `/tmp/straddle-pp-cli customers list --dry-run --agent`.
  Status: Documented as target behavior. Use dry-run first, do not call the real API for this check.
- Streaming agent envelope: use focused tests or local fake-server checks for `sync --agent` and real `tail --agent`.
  Status: Built and documented. Normal `--json` streaming remains raw NDJSON.
- Workflow plan: `/tmp/straddle-pp-cli workflow plan all --json`.
  Status: Built and documented. Local-only structured command planning, no API calls, docs calls, MCP execution, webhooks, sandbox, production, credentials, writes, or live approval.
- MCP smoke and count: build `straddle-pp-mcp`, run the README `tools/list` JSON-RPC smoke, expect runtime count 87.
  Status: Documented. Confirms generated endpoint tools plus typed framework tools plus Cobra shell-out tools.
- Local packaging readiness: `make package-readiness` from `packages/cli/straddle-pp-cli`.
  Status: Documented. Builds and verifies both local preview binaries, including the MCP sibling, without GoReleaser or publishing.
- Local GoReleaser archive validation: `make release-check` and `make release-snapshot` from `packages/cli/straddle-pp-cli`.
  Status: Documented. Validates config and builds non-publishing local snapshot archives containing both local preview binaries.
- Patch manifest validity: `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json` from repo root.
  Status: Documented. Required after every generated-code patch.

## Phase 4 Local Dogfood Results

Run time: 2026-05-09 16:40 MDT.

Run from `/Users/js/clawd/straddle/straddle-ai` unless a command notes the generated project directory.

| Command | Result | Observed output |
|---------|--------|-----------------|
| `npm run validate` | Pass | `=== Summary: 0 errors ===`; generated CLI artifact checks also reported endpoint tool count 70, framework tool count 3, and typed tool total 73. |
| `git diff --check` | Pass | No output. |
| `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json` | Pass | No output. |
| `go build -o /tmp/straddle-pp-cli ./cmd/straddle-pp-cli` from `packages/cli/straddle-pp-cli` | Pass | No output. |
| `go build -o /tmp/straddle-pp-mcp ./cmd/straddle-pp-mcp` from `packages/cli/straddle-pp-cli` | Pass | No output. |
| `/tmp/straddle-pp-cli about` | Pass | Printed Straddle ASCII word art, `Status: local preview`, `Generator: Printing Press generated`, OpenAPI source `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`, MCP sibling `straddle-pp-mcp`, and safety text saying local only with no credentials, API calls, or production writes. |
| `/tmp/straddle-pp-cli about --agent` | Pass | Emitted a JSON envelope with `schema_version: "1.0"`, `error: null`, `warnings: []`, and `data.command: "about"`. |
| `/tmp/straddle-pp-cli setup check --json` | Pass | Reported config path `/Users/js/.config/straddle-pp-cli/config.toml`, `config.exists: false`, `environment.classification: "unset"`, `auth.configured: false`, `mcp.available: true`, `mcp.sibling_path: "/tmp/straddle-pp-mcp"`, and all safety booleans false for docs endpoint, Straddle API, MCP execution, webhook posting, and production writes. |
| `/tmp/straddle-pp-cli setup check --agent` | Pass | Emitted the same setup data inside the target JSON envelope with `schema_version: "1.0"`, `error: null`, and `warnings: []`. |
| `/tmp/straddle-pp-cli docs search payment --source commands --json` | Pass | Returned 5 command-search results. The first two were `funding-event-payments get` and `payments list`, each with score 5. |
| `/tmp/straddle-pp-cli sandbox guide --json` | Pass | Returned guidance-only scenarios including `payment-lifecycle`, `payout-flow`, `failures`, `ach-returns`, `funding`, `bridge`, `embed-onboarding`, and `webhooks`; policy reported no API calls, no docs endpoint calls, and no production writes. |
| `/tmp/straddle-pp-cli ops guide reconciliation --json` | Pass | Returned local-only reconciliation guidance with docs queries for funding events, charges, payouts, settlement, and reconciliation; safety reported no API calls, no docs endpoint calls, no MCP execution, no webhook posting, and no production writes. |
| `/tmp/straddle-pp-cli customers list --dry-run --agent` | Pass | Did not send a request. It emitted a single JSON envelope on stdout with `data.dry_run: true`, `schema_version: "1.0"`, `error: null`, and `warnings: []`, with no human request preview before or after the envelope. |
| README JSON-RPC `tools/list` smoke against `/tmp/straddle-pp-mcp` | Pass | Returned `{"tool_count":83,"first_tools":["account-settings_get-settings","accounts_capability-requests_create","accounts_capability-requests_list","accounts_create","accounts_get"]}`. |
| `go test -count=1 ./internal/cli -run 'Test.*About|Test.*Setup|Test.*Docs|Test.*Sandbox|Test.*Ops'` from `packages/cli/straddle-pp-cli` | Pass | `ok straddle-pp-cli/internal/cli 0.948s`. |
| `go test -count=1 ./internal/mcp -run 'Test.*Tools|Test.*Count|Test.*Cobra'` from `packages/cli/straddle-pp-cli` | Pass | `ok straddle-pp-cli/internal/mcp 0.296s`. |
| `go test -count=1 ./...` from `packages/cli/straddle-pp-cli` | Pass | Passed all packages. Packages with tests reported `ok` for `internal/cli`, `internal/cliutil`, `internal/mcp`, `internal/mcp/cobratree`, and `internal/store`; command, cache, client, config, and types packages reported no test files where applicable. |
| `rm -f /tmp/straddle-pp-cli /tmp/straddle-pp-mcp` | Pass | Both temp binaries were removed. |

No production API calls, live writes, token literals, or secret literals were used in this run.

Cleanup:

```bash
rm -f /tmp/straddle-pp-cli /tmp/straddle-pp-mcp
```

## Packaging Readiness Slice Results

Run time: 2026-05-09.

Run from `/Users/js/clawd/straddle/straddle-ai` unless a command notes the generated project directory.

| Command | Result | Observed output |
|---------|--------|-----------------|
| `command -v goreleaser || true` | Pass | No output, confirming GoReleaser is still not installed in this environment. |
| `make package-readiness` from `packages/cli/straddle-pp-cli` | Pass | Built `dist/local/straddle-pp-cli` and `dist/local/straddle-pp-mcp`, verified both binaries are executable, ran `straddle-pp-cli --help`, and printed `local package ready: dist/local`. |
| `make release-check` from `packages/cli/straddle-pp-cli` | Pass | Ran `go run github.com/goreleaser/goreleaser/v2@latest check`; 1 configuration file validated with no deprecation warning after the move to `homebrew_casks`. |
| `make release-snapshot` from `packages/cli/straddle-pp-cli` | Pass | Ran `go run github.com/goreleaser/goreleaser/v2@latest release --snapshot --clean --skip=publish`; built snapshot `0.0.0-SNAPSHOT-ebf6bfc`, created darwin, linux, and windows archives, calculated checksums, wrote local `dist/homebrew/Casks/straddle-pp-cli.rb`, skipped publish, and succeeded after 4s. |
| `sed -n '1,220p' dist/homebrew/Casks/straddle-pp-cli.rb` | Pass | Local generated cask contains `binary "straddle-pp-cli"` and `binary "straddle-pp-mcp"`. |
| `tar -tzf dist/straddle-pp-cli_0.0.0-SNAPSHOT-ebf6bfc_darwin_arm64.tar.gz` | Pass | Archive contained `LICENSE`, `README.md`, `straddle-pp-cli`, and `straddle-pp-mcp`. |
| `zipinfo -1 dist/straddle-pp-cli_0.0.0-SNAPSHOT-ebf6bfc_windows_amd64.zip` | Pass | Archive contained `LICENSE`, `README.md`, `straddle-pp-cli.exe`, and `straddle-pp-mcp.exe`. |
| `go test -count=1 ./...` from `packages/cli/straddle-pp-cli` | Pass | Passed all packages. Packages with tests reported `ok` for `internal/cli`, `internal/cliutil`, `internal/mcp`, `internal/mcp/cobratree`, and `internal/store`. |
| `npm run validate` | Pass | `=== Summary: 0 errors ===`; generated CLI artifact checks still reported endpoint tool count 70, framework tool count 3, and typed tool total 73. |
| `git diff --check` | Pass | No output. |
| Targeted release-honesty text check | Pass | Docs still say local preview, future work, no current public installer, no `npx`, no published release artifacts, and no desktop MCP bundle. |
| `make clean` from `packages/cli/straddle-pp-cli` | Pass | Removes local `bin/`, `build/`, and `dist/` build outputs. |

## Keychain Packaging Smoke Results

Run time: 2026-05-10.

Run from `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli`.

This run happened after adding opt-in keychain auth and the `github.com/zalando/go-keyring` dependency. It only built local binaries and validated release configuration. It did not call Straddle APIs, use credentials, publish, upload, push a Homebrew tap, sign, notarize, or run live smoke.

| Command | Result | Observed output |
|---------|--------|-----------------|
| `make package-readiness` | Pass | Built `dist/local/straddle-pp-cli` and `dist/local/straddle-pp-mcp`, verified both binaries are executable, ran `straddle-pp-cli --help`, and printed `local package ready: dist/local`. |
| `make release-check` | Pass | Ran `go run github.com/goreleaser/goreleaser/v2@latest check`; 1 configuration file validated. |
| `make clean` | Pass | Removed local `bin/`, `build/`, and `dist/` outputs after inspection. |

Remaining packaging work: broad public launch still needs published-release approval, owner/security credential approval, signing and notarization decisions, approved live read-only smoke, desktop MCP packaging posture, and public docs wording.

## Packaged-Client Credential Smoke Results

Run time: 2026-05-10.

Run from `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli`.

This was a local no-secret packaged-client credential smoke. It did not use credentials, call Straddle APIs, publish, upload, push, sign, notarize, run live smoke, or execute MCP tools. The MCP check used only JSON-RPC `initialize`, `notifications/initialized`, and `tools/list` against the packaged `dist/local/straddle-pp-mcp` binary.

| Command | Result | Observed output |
|---------|--------|-----------------|
| `make package-readiness` | Pass | Built `dist/local/straddle-pp-cli` and `dist/local/straddle-pp-mcp`, verified both binaries are executable, ran CLI help, and printed `local package ready: dist/local`. |
| `dist/local/straddle-pp-cli --help` | Pass | Root help listed setup, auth, credentials, release, smoke, workflow, endpoint groups, agent flags, and local safety guidance. |
| `dist/local/straddle-pp-cli setup check --json` | Pass | Reported local-preview safety flags with no Straddle API calls, no docs endpoint calls, no MCP execution, no webhook posts, and no production writes. Config existed false, auth configured false, MCP sibling available true and executable true. |
| `dist/local/straddle-pp-cli credentials plan packaged-client --json` | Pass | Emitted the packaged-client smoke runbook, safety metadata showing no secret reads, no credential writes, no API calls, no MCP tool execution, no publishing, no signing, no notarization, and broad public launch still blocked. |
| `dist/local/straddle-pp-cli auth status --json` | Expected unauthenticated | Exited 4 with `authenticated: false`, config path `/Users/js/.config/straddle-pp-cli/config.toml`, empty source, and a local setup or secret-injection hint. No token value printed. |
| JSON-RPC `initialize` plus `tools/list` against `dist/local/straddle-pp-mcp` | Pass | Returned `tool_count: 87` and first tools `account-settings_get-settings`, `accounts_capability-requests_create`, `accounts_capability-requests_list`, `accounts_create`, and `accounts_get`. No MCP tool was executed. |
| `make clean` | Pass | Removed local `bin/`, `build/`, and `dist/` outputs after the smoke. |

## Product Review Slice Results

Run time: 2026-05-09.

Run from `/Users/js/clawd/straddle/straddle-ai` unless a command notes the generated project directory.

| Command or artifact | Result | Observed output |
|---------------------|--------|-----------------|
| `cli-plans/2026-05-09-straddle-cli-product-review.md` | Pass | Approves local preview, rejects public launch, lists public launch blockers, and documents scorecard impact. |
| `go build -o /tmp/straddle-pp-cli-product-review ./cmd/straddle-pp-cli` from `packages/cli/straddle-pp-cli` | Pass | Built local CLI preview binary. |
| `go build -o /tmp/straddle-pp-mcp-product-review ./cmd/straddle-pp-mcp` from `packages/cli/straddle-pp-cli` | Pass | Built local MCP sibling binary. |
| `/tmp/straddle-pp-cli-product-review --help` | Pass | Root help listed setup, docs, sandbox, ops, endpoint groups, workflow, sync, tail, and agent flags. |
| `/tmp/straddle-pp-cli-product-review setup check --json` | Pass | Reported local-preview safety flags with no Straddle API calls, docs endpoint calls, MCP execution, webhook posts, or production writes. |
| `/tmp/straddle-pp-cli-product-review docs search payment --source commands --json` | Pass | Returned local command-search results without auth or live API calls. |
| `/tmp/straddle-pp-cli-product-review sandbox guide --json` | Pass | Returned help-only sandbox scenarios and policy requiring current docs lookup plus separate approval before live sandbox execution. |
| `/tmp/straddle-pp-cli-product-review ops guide --json` | Pass | Returned local-only guidance for reconciliation, fraud monitoring, collections, reporting, and monitoring. |
| `/tmp/straddle-pp-cli-product-review customers list --dry-run --agent` | Pass | Emitted one target JSON envelope with `data.dry_run: true` and no human request preview text. |
| JSON-RPC `tools/list` smoke against `/tmp/straddle-pp-mcp-product-review` | Pass | Returned tool count 83 and included `setup_check`, `docs_search`, `sandbox_guide`, and `ops_guide`. |

## MCP Runtime Smoke Refresh Results

Run time: 2026-05-09 18:21 MDT.

Run from `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli`.

This run only built a local MCP binary in `/tmp`, sent JSON-RPC `initialize` and `tools/list`, inspected the returned tool metadata, and removed the temporary binary. It did not call Straddle APIs, docs endpoints, GitHub, Homebrew, npm, publishing, signing, notarization, secrets, or business MCP tools.

| Command | Result | Observed output |
|---------|--------|-----------------|
| `go build -o /tmp/straddle-pp-mcp ./cmd/straddle-pp-mcp` | Pass | No output. |
| Local JSON-RPC `initialize` plus `tools/list` against `/tmp/straddle-pp-mcp` | Pass | Returned `{ "ok": true, "tool_count": 85, "release_plan": { "name": "release_plan", "readOnlyHint": true, "destructiveHint": false, "openWorldHint": true } }`. |
| `rm -f /tmp/straddle-pp-mcp && test ! -e /tmp/straddle-pp-mcp` | Pass | Temp binary removed. |

## Verification Commands

Cheap checks for this documentation slice:

```bash
cd /Users/js/clawd/straddle/straddle-ai
npm run validate
git diff --check
rg -n '2026-05-09-straddle-cli-shipcheck-scorecard|about|setup check|docs search --source commands|sandbox guide|ops guide|agent envelope|MCP smoke|patch manifest|localhost bind|Partial' cli-plans packages/cli/README.md
```

Packaging readiness checks:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
make package-readiness
go test -count=1 ./...
cd /Users/js/clawd/straddle/straddle-ai
npm run validate
git diff --check
rg -n 'local preview|future release|future work|not a published public launch artifact|no current public|make package-readiness|straddle-pp-mcp' packages/cli/README.md packages/cli/straddle-pp-cli/README.md packages/cli/straddle-pp-cli/SKILL.md cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md
```

Product review checks:

```bash
cd /Users/js/clawd/straddle/straddle-ai
rg -n 'product review|local preview|public launch|MCP sibling|dry-run|setup check|ops guide|approved live smoke' cli-plans/2026-05-09-straddle-cli-product-review.md cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md cli-plans/2026-05-09-straddle-printing-press-cli-plan.md
```

Focused generated-project checks when command behavior or generated docs change:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go test -count=1 ./internal/cli -run 'Test.*About|Test.*Setup|Test.*Docs|Test.*Sandbox|Test.*Ops'
go test -count=1 ./internal/mcp -run 'Test.*Tools|Test.*Count|Test.*Cobra'
go build -o /tmp/pp-cli-shipcheck ./cmd/straddle-pp-cli
go build -o /tmp/pp-mcp-shipcheck ./cmd/straddle-pp-mcp
rm -f /tmp/pp-cli-shipcheck /tmp/pp-mcp-shipcheck
```

Broad checks before public launch, when the environment supports them:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go test -count=1 ./...
```

Known caveat: broad Go and MCP tests that use `httptest` may need an environment that allows localhost bind. If this sandbox cannot bind localhost, do not report broad Go or MCP test coverage as passing. Report focused checks and the caveat instead.

## Launch Readiness Summary

- Ready for docs slice review: yes.
- Ready for local preview product review: yes.
- Ready for public CLI launch: no.
- Ready for product packaging: partial local proof only, including non-publishing snapshot archive validation.
- Ready for approved live smoke: no. A local runbook command exists, but no approved live smoke has run.
- Next narrow work: get explicit smoke approval and credential scope, complete public-release distribution decisions surfaced by `release plan`, and decide whether the generated cask needs signing, notarization, or extra Homebrew metadata before publishing.
