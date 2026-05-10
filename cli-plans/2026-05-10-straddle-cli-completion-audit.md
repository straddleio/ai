# Completion Audit: Straddle CLI Goal

Date: 2026-05-10

## Verdict

Goal status: not complete.

The repo now has a strong local preview of a Printing Press generated Straddle CLI and MCP sibling. It is generated from the Straddle OpenAPI spec, has agent-friendly output paths, local safety commands, workflow planning commands, release and credential planning commands, docs, validation, MCP runtime smoke proof, and a small commit history.

It is not yet a public Straddle CLI launch. Public release artifacts are not published, no approved live read-only smoke has run, no public-launch product review exists, no decision has been made between env/config-only auth and OS secure storage, and practical operational workflows are still local planning guidance rather than proven live workflows.

## Objective Restated As Deliverables

1. Generate the Straddle CLI in `/Users/js/clawd/straddle/straddle-ai` from `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`.
2. Use Printing Press as the required generator foundation.
3. Keep the Stainless-generated CLI as a downstream behavior reference only.
4. Use Ramp as the required benchmark for ergonomics, docs, MCP, agent friendliness, packaging, and presentation. Treat other CLI research as supporting context only, not as a success criterion.
5. Ship CLI first, with a generated MCP sibling from the same command tree.
6. Make the CLI useful to humans and agents for setup, customers, payments, reconciliation, fraud monitoring, collections, reporting, monitoring, sandbox testing, and docs search.
7. Keep token guidance safe. Do not print, commit, log, or pass tokens through argv in recommended paths.
8. Document and verify the generated project, patch layer, MCP runtime, release path, credential path, and launch gaps.
9. Use subagent-driven implementation, spec review, quality review, verification, and tight commits for every slice. Count this as complete only when durable evidence exists for the slice being claimed.
10. Do not call production APIs or claim public launch from local generation alone.

## Prompt To Artifact Checklist

| Requirement | Evidence | Status |
|-------------|----------|--------|
| Work in `straddle-ai` | Current repo root is `/Users/js/clawd/straddle/straddle-ai`; generated CLI lives under `packages/cli/straddle-pp-cli`. | Done |
| OpenAPI source from `straddle-docs` | `.printing-press.json` records `spec_path` and `spec_url` as `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`; `spec.json` title is `Straddle API` and has 55 paths. | Done |
| Printing Press foundation | `.printing-press.json` records Printing Press `4.2.0`, `cli_name: straddle-pp-cli`, and `mcp_binary: straddle-pp-mcp`; CLI and MCP entrypoints exist. | Done for preview |
| Printing Press MCP sibling | `cmd/straddle-pp-mcp/main.go` and `internal/mcp/` exist; fresh runtime smoke returned `tool_count: 87`. | Done for preview |
| CLI first | `packages/cli/README.md` says `straddle-pp-cli` is primary and `straddle-pp-mcp` is the sibling from the same Printing Press tree. | Done for preview |
| Ramp as benchmark, not architecture | Spec and benchmark docs say Ramp is a benchmark only; the competitor benchmark includes Ramp evidence. Extra CLI research for Stripe, GitHub CLI, Wrangler, Vercel, Shopify, Supabase, Brex, Finch, Kiro, and LangChain Deep Agents is supporting context only, not a required completion gate. | Done for planning |
| Stainless as reference only | Spec and docs say Stainless is a behavior reference only and not the architecture. | Done for planning |
| Word art and presentation | `about` exists and fresh `about --agent` returned `schema_version: "1.0"`, `data.command: "about"`, and `data.status: "local preview"`. Human `about` is documented as Straddle ASCII word art. | Done for local preview |
| Agent output | Generated list/read output, local helper `--agent` output, `agent-context --agent`, `about --agent`, `setup check --agent`, `sync --agent`, and real `tail --agent` are documented as target-envelope paths. | Partial, public compatibility review still needed |
| Setup workflow | `setup check` exists and is local-only; docs cover config path, environment classification, auth source, MCP sibling, docs search, sandbox guide, and safe next steps. | Partial, public onboarding still open |
| Customer workflow | Generated customer commands exist, dry-run agent output is tested, and read-only sandbox exploration is documented. | Partial, no approved live read smoke |
| Payment workflow | Generated charges, payouts, paykeys, payments, funding events, and reports exist; read-only exploration and dry-run checks are documented. | Partial, no approved live read smoke |
| Reconciliation workflow | `ops guide reconciliation` and `workflow plan reconciliation` provide local guidance and structured phases. | Partial, no live matching workflow |
| Fraud monitoring workflow | `ops guide fraud-monitoring` and `workflow plan fraud-monitoring` provide local guidance and structured phases. | Partial, no live monitoring or action workflow |
| Collections workflow | `ops guide collections` and `workflow plan collections` provide local guidance and structured phases. | Partial, no notices, retries, or live workflow |
| Reporting workflow | `ops guide reporting` and `workflow plan reporting` provide local guidance and structured phases. | Partial, no live report execution or exports |
| Monitoring workflow | `ops guide monitoring` and `workflow plan monitoring` provide local guidance and structured phases. | Partial, no polling, alerting, or webhook delivery |
| Sandbox testing | `sandbox guide` and `smoke plan` are local-only planning commands; docs require explicit approval and secure sandbox credentials before live work. | Partial, no live smoke |
| Docs search | `docs search` separates product docs, command search, and API or SDK `search_docs` guidance. | Done for preview |
| Safe token guidance | `auth set-token --stdin` is documented; `credentials plan launch` reports no secret reads/writes and lists the keychain or env/config launch decision. | Partial, secure-store decision open |
| Release path | `make package-readiness`, `make release-check`, and `make release-snapshot` exist and prior scorecard evidence says local archives include both CLI and MCP. | Partial, no public publish |
| Validation | Fresh `npm run validate` passed with `Summary: 0 errors`; generated artifact validation checks config, CLI main, README, SKILL, spec title, MCP main, `internal/mcp`, MCP typed counts, and endpoint count. | Done for preview |
| Go tests | Fresh `go test -count=1 ./...` passed in `packages/cli/straddle-pp-cli`. | Done for preview |
| MCP runtime, not just source validation | Fresh JSON-RPC `tools/list` against a `/tmp` MCP build returned `tool_count: 87`, `workflow_plan.readOnlyHint: true`, `workflow_plan.destructiveHint: false`, `credentials_plan.readOnlyHint: true`, and `credentials_plan.destructiveHint: false`. | Done for preview |
| Patch manifest | `.printing-press-patches.json` is valid JSON and catalogs safe-token, agent-output, docs-search, setup, sandbox, ops, smoke, release, credentials, and workflow-plan patches. | Done for preview |
| Product review | `cli-plans/2026-05-09-straddle-cli-product-review.md` approves local preview and rejects public launch. | Done for local preview |
| Subagent-driven process and review gates | The plan requires subagent-driven implementation plus spec and quality review before each slice. The current completion-audit slice is undergoing independent audit, spec review, and quality review. Durable repo evidence for all historical reviewer reports is incomplete, so this cannot be treated as fully satisfied for the whole goal. | Partial |
| Commit cadence | Recent history contains small commits for workflow planning, credential planning, MCP smoke, release planning, smoke planning, release validation, product review, and package readiness. This audit slice is not complete until these files are committed after review and verification. | Partial |
| Public launch | Docs repeatedly state this is a local preview, not a public launch artifact. | Not done |

## Fresh Verification

Run from `/Users/js/clawd/straddle/straddle-ai`:

```bash
npm run validate
```

Result: passed, `Summary: 0 errors`.

Run from `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli`:

```bash
go test -count=1 ./...
```

Result: passed for all generated project packages.

Credential-free MCP runtime smoke:

```bash
go build -o /tmp/straddle-pp-mcp-audit ./cmd/straddle-pp-mcp
# JSON-RPC initialize, initialized notification, tools/list
rm -f /tmp/straddle-pp-mcp-audit
```

Observed summary:

```json
{
  "ok": true,
  "tool_count": 87,
  "workflow_plan": {
    "name": "workflow_plan",
    "readOnlyHint": true,
    "destructiveHint": false
  },
  "credentials_plan": {
    "name": "credentials_plan",
    "readOnlyHint": true,
    "destructiveHint": false
  }
}
```

Credential-free CLI smoke:

```bash
go build -o /tmp/straddle-pp-cli-audit ./cmd/straddle-pp-cli
/tmp/straddle-pp-cli-audit about --agent
/tmp/straddle-pp-cli-audit workflow plan all --json
/tmp/straddle-pp-cli-audit credentials plan launch --json
rm -f /tmp/straddle-pp-cli-audit
```

Observed summaries:

```json
{"name":"about","schema_version":"1.0","error":null,"data.command":"about","data.status":"local preview"}
{"name":"workflow","workflow_count":5,"first_workflow":"reconciliation"}
{"name":"credentials","surface":"launch","blockers":["No OS keychain or secure-store implementation exists yet.","Launch needs an explicit decision: approve env/config-only for first public release or implement OS secure storage.","Desktop MCP public install remains future work."]}
```

## Missing Work

These are blockers for claiming the activated goal is complete:

1. Public release is not published. There is no public Homebrew tap update, `npx` package, release download, signed or notarized macOS path, desktop MCP package, or final public install doc.
2. No approved live read-only smoke has run with scoped sandbox credentials and expected outputs.
3. No public-launch product review has approved packaging, live smoke, docs, command name, support expectations, and MCP distribution.
4. Credential launch posture is undecided. The repo needs either explicit approval for env/config-only first public release or an OS secure-store implementation.
5. Operational workflows are still planning guidance. Reconciliation, fraud monitoring, collections, reporting, and monitoring have useful local plans, but no approved live read execution or workflow engines.
6. The generated preview is still named `straddle-pp-cli`. Replacing or publishing the public `straddle` binary needs an explicit naming and migration decision.
7. Phase 5 live smoke remains not done.
8. Durable subagent/review evidence for all historical slices is incomplete. Future slices should either commit reviewer summaries into the relevant audit artifact or keep the plan checklist partial.

## Next Slice

The next slice should be selected from the blocker list, not from new feature ideas. The highest-leverage next slice is an approved live read-only smoke, because it would test the generated CLI against real sandbox API behavior and give product review concrete outputs. If live smoke is not approved yet, the next best slice is a public-release decision pass that resolves command name, Homebrew or archive publish target, MCP desktop packaging, and credential-storage posture.

Do not mark the goal complete until a fresh audit maps every blocker above to evidence or to an explicit user-approved exclusion.
