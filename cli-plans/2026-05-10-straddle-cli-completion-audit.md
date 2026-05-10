# Completion Audit: Straddle CLI Goal

Date: 2026-05-10

## Verdict

Goal status: not complete.

The repo now has a strong local preview of a Printing Press generated Straddle CLI and MCP sibling. It is generated from the Straddle OpenAPI spec, has agent-friendly output paths, local safety commands, workflow planning commands, release and credential planning commands, docs, validation, MCP runtime smoke proof, and a small commit history.

It is not yet a public Straddle CLI launch. Public release artifacts are not published, no approved live read-only smoke has run, the public-launch product review gate now exists and rejects approval, keychain-backed storage is only opt-in preview support without owner/security launch approval, the local packaged-client credential smoke passed but does not approve launch, and practical operational workflows are still local planning guidance rather than proven live workflows.

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
| Stainless as reference only | Spec and docs say Stainless is a behavior reference only and not the architecture. `release plan compatibility --json` now records local proof commands for the installed Stainless-generated `straddle` command and source tree. | Done for planning, partial for public compatibility |
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
| Live smoke approval packet | `smoke plan approval --json` exists and prints required written approval fields, expected evidence, stop criteria, redaction guidance, and safe command suggestions. It is local-only and makes no API, docs, MCP, sandbox, or production calls. | Partial, reduces approval planning blocker, no live smoke |
| Docs search | `docs search` separates product docs, command search, and API or SDK `search_docs` guidance. | Done for preview |
| Safe token guidance | `auth set-token --stdin` and `auth set-token --stdin --keychain` are documented; `credentials plan launch` reports no secret reads/writes and lists keychain preview support plus remaining launch approvals. `credentials plan packaged-client` makes the local built-binary smoke commands machine-readable, and the 2026-05-10 local packaged-client credential smoke passed without credentials, API calls, or MCP tool execution. | Partial, owner/security approval, approved live read-only smoke, signed/notarized packaging posture, desktop MCP packaging posture, and docs wording open |
| Release path | `make package-readiness`, `make release-check`, and `make release-snapshot` exist and prior scorecard evidence says local archives include both CLI and MCP. A 2026-05-10 keychain packaging smoke reran `make package-readiness` and `make release-check` after adding `go-keyring`, then cleaned local outputs. A later 2026-05-10 packaged-client credential smoke used `dist/local/straddle-pp-cli` and `dist/local/straddle-pp-mcp`, listed MCP tools only, and cleaned local outputs. | Partial, no public publish, signing, notarization, owner/security launch approval, or approved live smoke |
| Current CLI compatibility inventory | `release plan compatibility --json` exists and records local proof commands for `/opt/homebrew/bin/straddle --version`, `/opt/homebrew/bin/straddle --help`, `/opt/homebrew/bin/straddle charges create --help`, the Stainless CLI remote, and Stainless markers in the source tree. It states that public `straddle` replacement is not approved and that the inventory is local evidence only. | Partial, reduces command-name blocker, no public command chosen |
| Release naming plan | `release plan naming --json` exists and records that the preview command is `straddle-pp-cli`, the public `straddle` command or binary is not approved, compatibility review is incomplete, and any alias, migration, or replacement plan still needs approval. | Partial, reduces naming decision blocker, no public command chosen |
| Docs and support plan | `release plan docs-support --json` exists and records that public docs and support are not approved yet, issue intake and support owner are missing, and public docs must not imply workflow execution, production readiness, or replacement of public `straddle`. | Partial, reduces docs/support blocker, no public docs or support approval |
| Owner decision plan | `release plan owner-decisions --json` exists and records the public binary name, first release channel, macOS signing and notarization, desktop MCP packaging, credential storage, live read-only smoke, public docs/support, and operational workflow claim decisions still required. It states that no owner has approved public release, public command replacement, release channel, signing, desktop MCP packaging, credential posture, live smoke, docs/support scope, or operational workflow execution claims. | Partial, reduces owner-decision blocker, no public launch approval |
| Validation | Fresh `npm run validate` passed with `Summary: 0 errors`; generated artifact validation checks config, CLI main, README, SKILL, spec title, MCP main, `internal/mcp`, MCP typed counts, and endpoint count. | Done for preview |
| Go tests | Fresh `go test -count=1 ./...` passed in `packages/cli/straddle-pp-cli`. | Done for preview |
| MCP runtime, not just source validation | Fresh JSON-RPC `tools/list` against a `/tmp` MCP build returned `tool_count: 87`, `workflow_plan.readOnlyHint: true`, `workflow_plan.destructiveHint: false`, `credentials_plan.readOnlyHint: true`, and `credentials_plan.destructiveHint: false`. | Done for preview |
| Patch manifest | `.printing-press-patches.json` is valid JSON and catalogs safe-token, agent-output, docs-search, setup, sandbox, ops, smoke, release, credentials, and workflow-plan patches. | Done for preview |
| Product review | `cli-plans/2026-05-09-straddle-cli-product-review.md` approves local preview and rejects public launch. `cli-plans/2026-05-10-straddle-cli-public-launch-product-review.md` now exists as the public-launch gate and also rejects approval until owner decisions and live smoke happen. | Done for local preview, blocked for public launch |
| Subagent-driven process and review gates | The plan requires subagent-driven implementation plus spec and quality review before each slice. `cli-plans/2026-05-10-straddle-cli-subagent-review-log.md` now records the workflow rule and recent committed slice evidence, including the latest docs-support review outcomes. Durable repo evidence for older historical reviewer reports may still be incomplete, so this cannot be treated as fully satisfied for the whole goal. | Partial |
| Commit cadence | Recent history contains small commits for workflow planning, credential planning, MCP smoke, release planning, smoke planning, release validation, product review, package readiness, `39444c8 feat: add release naming plan`, and `8eac604 feat: add smoke approval plan`. | Partial |
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
/tmp/straddle-pp-cli-audit credentials plan packaged-client --json
/tmp/straddle-pp-cli-audit release plan compatibility --json
/tmp/straddle-pp-cli-audit release plan docs-support --json
/tmp/straddle-pp-cli-audit release plan naming --json
/tmp/straddle-pp-cli-audit release plan owner-decisions --json
/tmp/straddle-pp-cli-audit smoke plan approval --json
rm -f /tmp/straddle-pp-cli-audit
```

Observed summaries:

```json
{"name":"about","schema_version":"1.0","error":null,"data.command":"about","data.status":"local preview"}
{"name":"workflow","workflow_count":5,"first_workflow":"reconciliation"}
{"name":"credentials","surface":"launch","blockers":["Owner/security approval is missing.","packaged-client smoke is only planned or local evidence until run and reviewed","Public docs wording is missing.","Desktop MCP public install remains future work."]}
{"name":"credentials","surface":"packaged-client","proof_commands":["make package-readiness","dist/local/straddle-pp-cli --help","dist/local/straddle-pp-cli setup check --json","dist/local/straddle-pp-cli credentials plan packaged-client --json","dist/local/straddle-pp-cli auth status --json","node -e 'const {spawn}=require(\"node:child_process\"); const cp=spawn(\"dist/local/straddle-pp-mcp\"); let buf=\"\"; let timer=setTimeout(()=>{console.error(\"timed out\"); cp.kill(); process.exit(1);},5000); function send(msg){cp.stdin.write(JSON.stringify(msg)+\"\\n\");} cp.stdout.on(\"data\", d=>{buf+=d; for(;;){const i=buf.indexOf(\"\\n\"); if(i<0) break; const line=buf.slice(0,i).trim(); buf=buf.slice(i+1); if(!line) continue; const msg=JSON.parse(line); if(msg.id===1){send({jsonrpc:\"2.0\",method:\"notifications/initialized\",params:{}}); send({jsonrpc:\"2.0\",id:2,method:\"tools/list\",params:{}});} if(msg.id===2){clearTimeout(timer); const tools=msg.result.tools||[]; console.log(JSON.stringify({tool_count:tools.length, first_tools:tools.slice(0,5).map(t=>t.name)})); cp.kill(); process.exit(0);}}}); send({jsonrpc:\"2.0\",id:1,method:\"initialize\",params:{protocolVersion:\"2024-11-05\",capabilities:{},clientInfo:{name:\"straddle-ai-local-smoke\",version:\"0\"}}});'","make clean"],"blockers":["packaged-client smoke is only planned or local evidence until run and reviewed","broad public launch remains blocked"]}
{"name":"release","surface":"compatibility","public_straddle_replacement_approved":false,"local_evidence_only":true,"proof_commands":["/opt/homebrew/bin/straddle --version","/opt/homebrew/bin/straddle --help","/opt/homebrew/bin/straddle charges create --help"]}
{"name":"release","surface":"naming","current_preview":"straddle-pp-cli","public_straddle_approved":false,"blockers":["Public binary name is undecided.","Existing Straddle CLI compatibility review is incomplete.","No migration or alias plan is approved.","Public install docs and support wording are not approved.","Live smoke is not approved or run."]}
{"name":"smoke","scope":"approval","requires_explicit_approval":true,"requires_secure_credential_flow":true,"no_live_execution_in_command":true,"evidence":["redacted command","exit code","endpoint or tool name","environment classification","object count or empty-list proof","no token exposure"]}
```

Packaged-client credential smoke:

```bash
make package-readiness
dist/local/straddle-pp-cli --help
dist/local/straddle-pp-cli setup check --json
dist/local/straddle-pp-cli credentials plan packaged-client --json
dist/local/straddle-pp-cli auth status --json
# JSON-RPC initialize, initialized notification, tools/list against dist/local/straddle-pp-mcp
make clean
```

Observed summaries:

```json
{"name":"package-readiness","result":"pass","local_binaries":["dist/local/straddle-pp-cli","dist/local/straddle-pp-mcp"]}
{"name":"setup_check","calls_straddle_api":false,"executes_mcp":false,"configured":false,"mcp_available":true}
{"name":"credentials_packaged_client","guidance_only":true,"local_only":true,"executes_mcp_tools":false,"approves_launch":false}
{"name":"auth_status","exit_code":4,"authenticated":false,"expected":"unauthenticated local state","token_printed":false}
{"name":"mcp_packaged_tools_list","tool_count":87,"first_tools":["account-settings_get-settings","accounts_capability-requests_create","accounts_capability-requests_list","accounts_create","accounts_get"],"mcp_tools_executed":false}
{"name":"make_clean","result":"pass","removed":["bin","build","dist"]}
```

## Missing Work

These are blockers for claiming the activated goal is complete:

1. Public release is not published. There is no public Homebrew tap update, `npx` package, release download, signed or notarized macOS path, desktop MCP package, or final public install doc.
2. No approved live read-only smoke has run with scoped sandbox credentials and expected outputs. `smoke plan approval --json` now structures the required approval packet, but it does not run live smoke.
3. The public-launch product review gate exists at `cli-plans/2026-05-10-straddle-cli-public-launch-product-review.md`, but it rejects approval until owner decisions and approved live smoke happen.
4. Credential launch posture is still not approved for broad public launch. The repo now has opt-in preview keychain support, a local-only `credentials plan packaged-client` surface for built CLI/MCP binary smoke steps, and a passed local packaged-client credential smoke. Broad public launch still needs owner/security approval, approved live read-only smoke, approved public docs wording, signed/notarized packaging posture, and desktop MCP packaging posture.
5. Operational workflows are still planning guidance. Reconciliation, fraud monitoring, collections, reporting, and monitoring have useful local plans, but no approved live read execution or workflow engines.
6. Public docs and support are still not approved. `straddle-pp-cli release plan docs-support --json` now documents the missing docs owner approval, support owner, issue intake path, install path, command name, support boundaries, known limits, security wording, final docs review, and live smoke.
7. The generated preview is still named `straddle-pp-cli`. `straddle-pp-cli release plan compatibility --json` now gives local evidence commands for the current Stainless-generated CLI and installed `straddle` behavior, and `straddle-pp-cli release plan naming --json` documents that `straddle` is not approved yet. Replacing or publishing the public `straddle` binary still needs an explicit naming and migration decision.
8. Phase 5 live smoke remains not done.
9. Durable subagent/review evidence for the recent committed slices now exists in `cli-plans/2026-05-10-straddle-cli-subagent-review-log.md`. Older historical slices may still lack complete reviewer evidence. Future slices must commit implementer, spec-review, quality-review, controller-verification, and commit evidence before selecting the next slice, or keep the checklist partial.

## Next Slice

The next slice should be selected from the blocker list, not from new feature ideas. The highest-leverage next slice is an approved live read-only smoke, because it would test the generated CLI against real sandbox API behavior and give product review concrete outputs. If live smoke is not approved yet, use `smoke plan approval --json` as the local approval packet surface, or run a public-release decision pass that resolves command name, Homebrew or archive publish target, MCP desktop packaging, and credential-storage posture.

Do not mark the goal complete until a fresh audit maps every blocker above to evidence or to an explicit user-approved exclusion.
