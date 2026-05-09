# Straddle CLI Shipcheck Scorecard

Date: 2026-05-09

## Verdict

Shipcheck status: Partial.

Score: 6 of 10 for the current preview slice.

The scorecard now exists and the local documentation contract is clearer. The full public CLI goal is not complete. Packaging, release path, product review, approved live smoke, and richer live workflow behavior remain open.

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

- Evidence: `packages/cli/README.md` states the CLI is primary and `straddle-pp-mcp` is generated from the same tree.
- Status: Done for preview.
- Missing work: Product review of the generated MCP surface.

Local preview docs are honest

- Evidence: `packages/cli/README.md` says there is no current public `npx`, prebuilt binary, public-library release link, Hermes install path, or MCP package bundle.
- Status: Done for preview.
- Missing work: Public install docs after packaging exists.

Safe token path exists and is documented

- Evidence: `auth set-token --stdin` is documented, with `STRADDLE_TOKEN` and custom config paths; docs say not to commit, print, log, or pass tokens through argv.
- Status: Partial.
- Missing work: Broader auth review, keychain or secure store decision, launch approval.

Agent envelopes are documented and covered for current local commands

- Evidence: README documents the target envelope for generated list/read commands, `printJSONFiltered` helpers, `agent-context`, `about`, `setup check`, `sync`, and real `tail`.
- Status: Partial.
- Missing work: Product review of final envelope contract and compatibility.

Local dogfood commands exist for preview checks

- Evidence: See dogfood checklist below for `about`, `setup check`, `docs search --source commands`, `sandbox guide`, `ops guide`, agent envelopes, MCP smoke/count, and patch manifest validity.
- Status: Partial.
- Missing work: Fresh run of the full dogfood command set before launch.

MCP count semantics are resolved

- Evidence: `.printing-press.json` tracks 70 generated endpoint tools; typed Go MCP registrations total 73 including 3 framework typed tools; runtime `tools/list` currently returns 83 with 10 Cobra shell-out tools.
- Status: Done for preview.
- Missing work: Re-run runtime smoke after command tree changes.

Patch manifest is valid and documented

- Evidence: `.printing-press-patches.json` is documented as the patch catalog; `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json` is the validity check.
- Status: Done for preview.
- Missing work: Keep manifest current with every generated-code patch.

Sandbox-safe walkthrough avoids side effects

- Evidence: README keeps setup checks local, customer and payment exploration read-only, and live writes out of scope.
- Status: Partial.
- Missing work: Approved live read-only sandbox smoke with real data flow.

Operational workflows are useful but safe

- Evidence: `ops guide` is local-only guidance for reconciliation, fraud monitoring, collections, reporting, and monitoring.
- Status: Partial.
- Missing work: Live reads, docs lookup execution, MCP execution, webhook delivery, and workflow engines are not built.

Packaging and public launch are ready

- Evidence: No evidence yet.
- Status: Not done.
- Missing work: Installer, release packaging, public binary name, product approval, and launch docs.

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
- Generated command agent envelope: `/tmp/straddle-pp-cli customers list --dry-run --agent`.
  Status: Documented as target behavior. Use dry-run first, do not call the real API for this check.
- Streaming agent envelope: use focused tests or local fake-server checks for `sync --agent` and real `tail --agent`.
  Status: Built and documented. Normal `--json` streaming remains raw NDJSON.
- MCP smoke and count: build `straddle-pp-mcp`, run the README `tools/list` JSON-RPC smoke, expect runtime count 83.
  Status: Documented. Confirms generated endpoint tools plus typed framework tools plus Cobra shell-out tools.
- Patch manifest validity: `jq empty packages/cli/straddle-pp-cli/.printing-press-patches.json` from repo root.
  Status: Documented. Required after every generated-code patch.

Cleanup:

```bash
rm -f /tmp/straddle-pp-cli /tmp/straddle-pp-mcp
```

## Verification Commands

Cheap checks for this documentation slice:

```bash
cd /Users/js/clawd/straddle/straddle-ai
npm run validate
git diff --check
rg -n '2026-05-09-straddle-cli-shipcheck-scorecard|about|setup check|docs search --source commands|sandbox guide|ops guide|agent envelope|MCP smoke|patch manifest|localhost bind|Partial' cli-plans packages/cli/README.md
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
- Ready for public CLI launch: no.
- Ready for product packaging: no.
- Ready for approved live smoke: no evidence yet.
- Next narrow work: run or refresh dogfood checks in an environment that can build Go and bind localhost, then update this scorecard with exact command results.
