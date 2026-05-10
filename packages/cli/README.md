# Straddle Printing Press CLI Preview

This package documents the generated Straddle CLI preview. The preview lives in `packages/cli/straddle-pp-cli` and is generated from Straddle's public OpenAPI file:

```text
/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json
```

Printing Press is required for this work. The actual generator is `mvanhorn/cli-printing-press`. `mvanhorn/printing-press-library` is the public catalog, examples, and distribution reference, not the generator used to produce this preview.

The generated project includes the CLI first and an MCP sibling from the same Printing Press command tree. The preview binary is `straddle-pp-cli`. The generated MCP binary is `straddle-pp-mcp`.

## Current Contract

This generated CLI is a local preview, not a published public launch artifact. Printing Press remains the source for the generated tree. There is no current public `npx` install path, pre-built binary, public-library release link, Hermes install path, or public MCP package bundle for this Straddle preview. Local archive, Homebrew cask, MCP bundle, and private npm package assembly proofs exist under `dist/`, but public publication remains blocked.

Current local build and install paths:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go build -o /tmp/straddle-pp-cli ./cmd/straddle-pp-cli
/tmp/straddle-pp-cli --help

# Optional local Go install into GOPATH/bin:
go install ./cmd/straddle-pp-cli
```

Local packaging readiness, without requiring GoReleaser:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
make package-readiness
```

This builds `straddle-pp-cli` and the generated `straddle-pp-mcp` sibling into `dist/local/`, verifies both binaries exist, runs packaged `shipcheck local`, verifies packaged `shipcheck public` fails on public approval blockers while proving local preview passed, and produces a local desktop MCP bundle under `dist/local/mcp-bundle`. It is a local proof only. It does not publish release artifacts, upload archives, update a Homebrew tap, create an `npx` package, install MCP, write user desktop config, or approve public desktop MCP support.

GoReleaser archive validation is also available as a non-publishing local check:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
make release-readiness
make clean
```

`make release-readiness` is the canonical non-publishing release gate. It runs Go tests, local package-readiness, GoReleaser config validation, GoReleaser snapshot archive generation, archive and checksum verification, local cask binary checks, current-platform archive extraction, archived `shipcheck local`, archived `shipcheck public` blocker verification, archived `mcp bundle`, and local npm package assembly plus verification. The npm verification checks private package metadata, bundled vendor binaries, current-platform CLI and MCP wrapper smokes, packaged `shipcheck public` blocker verification, token-shaped strings, publishing-command strings, `npm pack --dry-run`, and offline local tarball execution. The snapshot archives include `straddle-pp-cli`, `straddle-pp-mcp`, `.printing-press.json`, `manifest.json`, `README.md`, and `LICENSE`. It still writes only local `dist/` output and does not publish, upload, push, publish to npm, or write to a Homebrew tap. `make release-check` and `make release-snapshot` remain lower-level troubleshooting targets. Run `make clean` after inspection to remove generated artifacts.

The manual GitHub Actions workflow `.github/workflows/cli-release-candidate.yml` turns the same local proof into a review artifact. It accepts a strict `shipcheck public --approval-file` JSON record as raw JSON or base64 JSON, runs the plugin and CLI validation gates, runs `make release-readiness`, validates the approval against the built CLI, and uploads `dist/` plus redacted release-candidate metadata for review. It writes the raw approval JSON and raw shipcheck evidence only to a temporary runner path, so the artifact does not include approval contents. It is still non-publishing: no release creation, npm publish, Homebrew publish, signing, notarization, Straddle API calls, credential-bearing MCP tool calls, or secret reads.

Agent mode expands to `--json --compact --no-input --no-color --yes`. Provenance-backed generated list and read commands now emit the target envelope from the spec. Command-specific local helpers that use `printJSONFiltered`, including `which --agent`, also use this target envelope. `agent-context --agent` uses the same envelope, with the existing v3 agent context object under `data`:

```json
{
  "schema_version": "1.0",
  "data": [],
  "pagination": null,
  "warnings": [],
  "trace_id": null,
  "error": null
}
```

The target envelope does not include a provenance field, so the old `meta` object is not present in JSON output. `sync --agent` and real `tail --agent` stream lines now use the same target envelope while normal `--json` streams stay raw NDJSON for compatibility.

The root `straddle-pp-cli --help` screen and `straddle-pp-cli about` both print Straddle ASCII word art for the human first-run path. `about` is local-only and prints concise preview status for humans. `about --json` emits a stable machine object, and `about --agent` emits the target agent envelope. It does not read credentials, call Straddle APIs, or write production data.

`straddle-pp-cli setup check` is a local-only first-run readiness command. It reports config path, resolved base URL, sandbox/production/custom/unset classification, auth source, profile names, MCP sibling file presence, docs search readiness, sandbox guide readiness, and safe next steps. It does not call Straddle APIs, docs endpoints, MCP, webhooks, or production. `setup check --json` emits a stable machine object, and `setup check --agent` emits the target agent envelope.

`straddle-pp-cli docs search <query>` is the docs lookup command. It defaults to unauthenticated product docs search through `https://docs.straddle.com/mcp`, supports `--endpoint` and `STRADDLE_DOCS_MCP_URL` only for loopback local tests, and keeps API or SDK reference guidance separate from the local synced-data `search` command. Use `--source commands` to search local generated command capabilities.

`straddle-pp-cli mcp config [client] --binary <path> --json` is local-only MCP client config generation for the generated `straddle-pp-mcp` stdio sibling. Supported clients are `claude-desktop`, `codex`, `cursor`, `stdio`, and `all`; no client lists available clients and safety metadata. It defaults `--binary` to `straddle-pp-mcp`, rejects blank binary paths and token literals, prints config fragments only, names `STRADDLE_TOKEN` only in notes or env var name lists, and does not install, write desktop config files, read profiles, read secrets, call APIs, execute MCP, publish, sign, or approve launch. It reduces the local desktop setup blocker, but public desktop MCP packaging and install approval are still not done.

`straddle-pp-cli mcp bundle --mcp-binary <path> --output <dir> --json` writes a local desktop MCP bundle artifact. It verifies the MCP binary exists and is a file, copies it into the bundle as `straddle-pp-mcp`, writes `manifest.json`, and writes reviewable config fragments for `claude-desktop`, `codex`, `cursor`, and `stdio`. The fragments name `STRADDLE_TOKEN` only as an env var name. It does not install, write user config, read profiles, read secrets, execute MCP, call APIs, publish, sign, notarize, or approve launch. Public desktop MCP install, marketplace packaging, signing, notarization, and support approval remain blocked.

`straddle-pp-cli sandbox guide [scenario|all]` is a local help-only sandbox testing guide. It absorbs the previous `/sandbox-test` scenario list without executing writes, calling Straddle APIs, or calling the docs endpoint. Run `docs search` first before any separately approved live sandbox execution to verify current simulation parameters.

`straddle-pp-cli ops guide [workflow]` is local-only operational planning guidance. Supported workflows are `reconciliation`, `fraud-monitoring`, `collections`, `reporting`, `monitoring`, and `all`. It lists docs lookup queries and CLI surfaces to inspect, but it does not call Straddle APIs, call docs endpoints, execute MCP tools, post webhooks, or write production data. Live operational execution requires separate approval and a fresh docs lookup.

`straddle-pp-cli workflow plan [workflow]` is local-only structured command planning for `reconciliation`, `fraud-monitoring`, `collections`, `reporting`, `monitoring`, or `all`. It turns the same workflow areas into phases, steps, docs search topics, read-only CLI commands, dry-run command suggestions, blocked write actions, and required approvals. It does not call Straddle APIs, docs endpoints, MCP tools, webhooks, sandbox, production, credentials, or write paths, and it does not approve live execution.

`straddle-pp-cli smoke plan [scope]` is local-only live-smoke planning guidance for `setup`, `customers`, `payments`, `funding`, `mcp`, `approval`, or `all`. The `approval` scope prints the written approval packet fields required before a future live read-only smoke, including environment and base URL classification, secure credential flow, allowed read-only commands, transcript path, expected evidence, stop criteria, and reviewer signoff. It does not call Straddle APIs, docs endpoints, MCP tools, webhooks, sandbox, or production, and it does not approve or run live smoke.

`straddle-pp-cli smoke run <scope> --approval-file <path>` is the approval-file-gated executable smoke surface. The first slice supports only `setup` and `customers`. It rejects missing approval, scope mismatch, production-looking base URLs, URL credentials, URL queries or fragments, and token literals in the approval file. `setup` stays local-only. `customers` performs one read-only `GET /v1/customers` request against the approved base URL. The run writes the redacted transcript artifact to the approval file `transcript_path`, creating parent directories as needed. It attaches caller-supplied `STRADDLE_TOKEN` only when the approval file names `env:STRADDLE_TOKEN` and the target is trusted, such as `sandbox.straddle.com` or a local test server.

`straddle-pp-cli release plan [surface]` is local-only public-release readiness guidance for `archives`, `compatibility`, `docs-support`, `homebrew`, `mcp`, `naming`, `npm`, `owner-decisions`, `signing`, or `all`. It prints local proof commands, future approvals, public artifact surfaces, and blockers. It does not publish, push, upload, sign, notarize, call Straddle APIs, call GitHub APIs, call Homebrew, call npm, execute MCP tools, or read secrets. The `compatibility` surface inventories the installed Stainless-generated `straddle` command and source tree as local evidence only before any rename, alias, replacement, or migration decision. The `docs-support` surface states that public docs and support are not approved yet and that public docs must not imply workflow execution, production readiness, or replacement of public `straddle`. The `naming` surface states that the current preview command is `straddle-pp-cli`, the public `straddle` command or binary is not approved yet, and the recommended default is to keep `straddle-pp-cli` for preview until a compatibility review approves a replacement or migration plan. The `owner-decisions` surface turns the public-launch decision packet into machine-readable local output for owner review while stating that public release, command replacement, release channel, signing, MCP packaging, credential posture, live smoke, docs/support scope, and workflow execution claims are not approved.

`straddle-pp-cli shipcheck public --approval-file <path>` is the strict local final gate after owners have approved launch. The JSON approval record must include `approver`, RFC3339 `approved_at`, the current `local_preview_commit`, true values for `owner_approval`, `public_distribution`, `docs_support`, `desktop_mcp`, `live_smoke`, and `signing_notarization`, plus non-empty evidence strings for each approval. It validates only; it does not publish, upload, call external services, execute MCP tools, read secrets, sign, notarize, or write production.

## Streaming Agent Contract

This contract is implemented for `sync --agent` and real `tail --agent`.

`sync` and real `tail` are NDJSON streams, not single response objects. Normal human output and normal `--json` streaming behavior must remain backward compatible until a deliberate breaking change is approved.

Agent stream lines write one JSON object per line to stdout. Each line uses the same top-level keys as the target envelope, with `data` holding the event-specific payload:

```json
{
  "schema_version": "1.0",
  "data": {
    "event": "sync_start",
    "timestamp": "2026-05-09T00:00:00Z"
  },
  "pagination": null,
  "warnings": [],
  "trace_id": null,
  "error": null
}
```

Each stream line has a stable event name in `data.event`, an ISO timestamp in `data.timestamp`, and no secrets or token-shaped values. Existing events such as `sync_start`, `sync_warning`, `sync_summary`, and real tail data events live under `data`.

Terminal and status chatter belongs on stderr. Agent stream data belongs on stdout. `sync_summary` and final tail shutdown or end events are final envelope lines in agent mode, not out-of-band text.

## Patch Layer

Generated files may contain intentional local changes. Mark each generated-code change with a concise `// PATCH: <id>` comment and keep the patch catalog in `straddle-pp-cli/.printing-press-patches.json` current. That catalog is the reviewer map for what survives regeneration and why.

Do not use root registration as the durable extension point, because generated root wiring can be overwritten. MCP workflow exposure must come from the generated command tree, or from a documented patch in `.printing-press-patches.json`, not from a separate hand-built MCP tree.

## MCP Smoke

`straddle-pp-mcp` is generated from the same Printing Press tree as `straddle-pp-cli` and currently runs over stdio. A credential-free runtime smoke can build the MCP binary and ask it for `tools/list` over JSON-RPC:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go build -o /tmp/straddle-pp-mcp ./cmd/straddle-pp-mcp
node -e 'const {spawn}=require("node:child_process"); const cp=spawn("/tmp/straddle-pp-mcp"); let buf=""; let timer=setTimeout(()=>{console.error("timed out"); cp.kill(); process.exit(1);},5000); function send(msg){cp.stdin.write(JSON.stringify(msg)+"\n");} cp.stdout.on("data", d=>{buf+=d; for(;;){const i=buf.indexOf("\n"); if(i<0) break; const line=buf.slice(0,i).trim(); buf=buf.slice(i+1); if(!line) continue; const msg=JSON.parse(line); if(msg.id===1){send({jsonrpc:"2.0",method:"notifications/initialized",params:{}}); send({jsonrpc:"2.0",id:2,method:"tools/list",params:{}});} if(msg.id===2){clearTimeout(timer); const tools=msg.result.tools||[]; console.log(JSON.stringify({tool_count:tools.length, first_tools:tools.slice(0,5).map(t=>t.name)})); cp.kill(); process.exit(0);}}}); send({jsonrpc:"2.0",id:1,method:"initialize",params:{protocolVersion:"2024-11-05",capabilities:{},clientInfo:{name:"straddle-ai-doc-smoke",version:"0"}}});'
rm -f /tmp/straddle-pp-mcp
```

If the runtime smoke is too noisy for an environment, use the source validation check from the repo root:

```bash
cd /Users/js/clawd/straddle/straddle-ai
node scripts/validate-cli.js
```

Resolved count breakdown: `.printing-press.json` `mcp_tool_count` tracks generated endpoint tools only. `internal/mcp/tools.go` currently has 73 typed tools: 70 endpoint tools plus 3 local framework typed tools, `search`, `sql`, and `context`. The runtime `tools/list` count is now 93 because the MCP runtime also exposes 20 Cobra shell-out tools: `analytics`, `benchmark_ramp`, `credentials_plan`, `docs_search`, `import`, `mcp_bundle`, `mcp_config`, `ops_guide`, `release_plan`, `sandbox_guide`, `setup_check`, `shipcheck_local`, `shipcheck_public`, `smoke_plan`, `smoke_run`, `sync`, `tail`, `workflow_archive`, `workflow_plan`, and `workflow_status`. The validator asserts the source invariant: 73 typed tools minus 3 framework typed tools equals the 70 endpoint tools in `.printing-press.json`.

## Sandbox-Safe Walkthrough

Use sandbox configuration only. For this slice, production calls are out of scope, and write calls are out of scope. Do not include real tokens in docs, logs, shell history, or examples.

Help-only and local-build checks:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go build -o /tmp/straddle-pp-cli ./cmd/straddle-pp-cli
/tmp/straddle-pp-cli --help
/tmp/straddle-pp-cli setup check --json
/tmp/straddle-pp-cli customers list --help
/tmp/straddle-pp-cli charges get --help
/tmp/straddle-pp-cli sandbox guide --help
/tmp/straddle-pp-cli sandbox guide --json
/tmp/straddle-pp-cli sandbox guide all --json
/tmp/straddle-pp-cli smoke plan --json
/tmp/straddle-pp-cli smoke plan approval --json
/tmp/straddle-pp-cli smoke plan all --json
/tmp/straddle-pp-cli workflow plan --json
/tmp/straddle-pp-cli workflow plan all --json
/tmp/straddle-pp-cli release plan --json
/tmp/straddle-pp-cli release plan compatibility --json
/tmp/straddle-pp-cli release plan docs-support --json
/tmp/straddle-pp-cli release plan naming --json
/tmp/straddle-pp-cli release plan owner-decisions --json
/tmp/straddle-pp-cli release plan all --json
/tmp/straddle-pp-cli credentials plan --json
/tmp/straddle-pp-cli credentials plan packaged-client --json
/tmp/straddle-pp-cli credentials plan all --json
```

Local-first setup checks:

```bash
SANDBOX_CONFIG=/tmp/straddle-pp-cli-sandbox.toml
STRADDLE_BASE_URL=https://sandbox.straddle.com /tmp/straddle-pp-cli setup check --json --config "$SANDBOX_CONFIG"
```

`auth status` is not a passing check before credential setup. In a clean config, it is expected to report an unauthenticated state and exit non-zero, currently auth error exit 4. Use it only when you want to inspect that state:

```bash
STRADDLE_BASE_URL=https://sandbox.straddle.com /tmp/straddle-pp-cli auth status --json --config "$SANDBOX_CONFIG" || true
```

Read-only exploration, only after a sandbox credential is supplied through the caller's secure secret flow:

```bash
STRADDLE_BASE_URL=https://sandbox.straddle.com /tmp/straddle-pp-cli customers list --agent --page-size 5 --config "$SANDBOX_CONFIG"
STRADDLE_BASE_URL=https://sandbox.straddle.com /tmp/straddle-pp-cli payments list --agent --page-size 5 --config "$SANDBOX_CONFIG"
STRADDLE_BASE_URL=https://sandbox.straddle.com /tmp/straddle-pp-cli charges get <sandbox-charge-id> --agent --config "$SANDBOX_CONFIG"
```

Customer and payment exploration must stay read-only. Use `--dry-run --agent` first when checking request shape:

```bash
STRADDLE_BASE_URL=https://sandbox.straddle.com /tmp/straddle-pp-cli customers list --dry-run --agent --config "$SANDBOX_CONFIG"
```

## Current Slice

Task 1 created the first generated baseline with these quality facts:

- No local build binaries are kept in the repo.
- Credential-shaped Postman environment details were scrubbed from generated artifacts.
- `gofmt` was clean.
- `go test ./...` passed.

The auth contract slices added `straddle-pp-cli auth set-token --stdin` for config-file token setup and `straddle-pp-cli auth set-token --stdin --keychain` for opt-in OS keychain storage. This is still not a public launch candidate. Reviewers still need to inspect command coverage, generation provenance, MCP shape, packaged-client smoke, docs wording, and the remaining workflow gaps.

The first presentation slice added `straddle-pp-cli about` for local preview status, ASCII word art, OpenAPI source, MCP sibling, and next checks: `setup check`, `agent-context`, and `which`. JSON and agent output are structured.

## Auth Paths

The preview supports three credential paths:

- `STRADDLE_TOKEN` for shells, CI, and MCP launches that inject credentials through the environment.
- Config-file auth through safe stdin input:
  ```bash
  read -r -s STRADDLE_TOKEN_INPUT
  straddle-pp-cli auth set-token --stdin <<<"$STRADDLE_TOKEN_INPUT"
  unset STRADDLE_TOKEN_INPUT
  ```
- Opt-in OS keychain auth through safe stdin input:
  ```bash
  read -r -s STRADDLE_TOKEN_INPUT
  straddle-pp-cli auth set-token --stdin --keychain <<<"$STRADDLE_TOKEN_INPUT"
  unset STRADDLE_TOKEN_INPUT
  ```
- A custom config file with `--config /path/to/config.toml`, including `auth set-token --stdin --config /path/to/config.toml` and `auth status --config /path/to/config.toml`.

Do not commit tokens. Do not print tokens in logs. Do not pass tokens in argv.

For credential storage launch readiness, use:

```bash
straddle-pp-cli credentials plan --json
straddle-pp-cli credentials plan packaged-client --json
straddle-pp-cli credentials plan all --json
straddle-pp-cli credentials plan keychain --agent
```

`credentials plan` covers `config`, `environment`, `mcp`, `keychain`, `packaged-client`, `launch`, and `all`. It is local-only guidance. It does not build packages, run binaries, read secrets, print secrets, write credentials, call Straddle APIs, call docs endpoints, execute MCP tools, inspect the environment token value, publish, sign, notarize, or approve launch. It says plainly that safe stdin config-file auth exists, keychain-backed storage exists as opt-in preview support, environment and secret-manager injection are supported for shells, CI, and MCP launches, and MCP environment injection is separate from CLI config-file auth. The `packaged-client` surface makes the local built-binary smoke steps machine-readable for `dist/local/straddle-pp-cli` and `dist/local/straddle-pp-mcp`, including JSON-RPC `tools/list` only. Local packaged-client credential smoke evidence exists and passed on 2026-05-10, but it remains scoped to local built binaries and does not approve broad public launch. Broad public launch remains blocked and still needs owner/security approval, approved live read-only smoke, approved public docs wording, signed/notarized packaging posture, and desktop MCP packaging posture. Desktop MCP public install remains future work.

## Regenerate

Run generation from the local Printing Press checkout:

```bash
cd /tmp/straddle-cli-research-generator
go run ./cmd/printing-press generate \
  --spec /Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json \
  --name straddle \
  --owner straddleio \
  --output /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli \
  --force \
  --lenient \
  --spec-source official \
  --spec-url /Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json
```

After regeneration, keep generated source and manifests. Do not keep local build binaries unless release packaging is explicitly in scope.

## Verify

Run the repo checks from `straddle-ai`:

```bash
cd /Users/js/clawd/straddle/straddle-ai
npm run validate
npm test
git status --short --branch
```

Inspect the OpenAPI source:

```bash
jq '.info, .servers, (.paths | length)' /Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json
```

Verify the generated Go project:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go test ./...
go build -o /tmp/pp-cli-verify ./cmd/straddle-pp-cli
go build -o /tmp/pp-mcp-verify ./cmd/straddle-pp-mcp
/tmp/pp-cli-verify --help
/tmp/pp-cli-verify agent-context --json
rm -f /tmp/pp-cli-verify /tmp/pp-mcp-verify
```

Check generated artifact shape:

```bash
cd /Users/js/clawd/straddle/straddle-ai
jq '.info.title' packages/cli/straddle-pp-cli/spec.json
find packages/cli/straddle-pp-cli/cmd -maxdepth 2 -type f -print
```

## Ramp Benchmark

Ramp is a benchmark only. It is not the architecture and should not drive command definitions away from Straddle's public OpenAPI source.

Run the executable local benchmark with:

```bash
straddle-pp-cli benchmark ramp --json
straddle-pp-cli benchmark ramp --agent
```

`benchmark ramp` returns local evidence for CLI coverage, agent output, MCP readiness, docs discovery, credential guidance, presentation polish including Straddle ASCII word art, operational workflows, and release readiness. It does not browse Ramp, call Straddle APIs, call docs endpoints, execute MCP, read secrets, write credentials, publish, or approve launch. Public npm, npx, Homebrew, GitHub release, docs, support, and public desktop MCP install remain approval blockers.

Compare the preview against Ramp for:

- Installer quality.
- Auth setup and token handling.
- Agent JSON envelope.
- Command grammar and terminal ergonomics.
- Skills packaging and agent-facing guidance.
- MCP positioning and generated tool surface.
- Docs coverage and examples.
- Word art and presentation polish.

## Stainless Reference

Stainless is a reference only. It is useful for existing Straddle resource coverage and useful flags, but it is not the architecture for this preview.

Compare the preview against the existing Straddle Stainless CLI for:

- Resource coverage that already exists for Straddle.
- Useful flags that developers or agents rely on today.
- Behavior that should be preserved when the Printing Press preview moves toward replacement.

Do not copy Stainless architecture into this package.

## Launch Blockers

The generated baseline is not ready to replace the public CLI until these gaps are closed:

- Installer and public release packaging are not done. A local `make package-readiness` proof builds both preview binaries, and a local GoReleaser snapshot has built archives that include both the CLI and MCP sibling, but neither path publishes anything.
- Safe token input exists for config-file auth and opt-in keychain auth, and `credentials plan [surface]` now documents config, environment, MCP, keychain, packaged-client local smoke evidence, and launch decisions. Local packaged-client credential smoke evidence exists and passed on 2026-05-10, but it remains scoped to local built binaries and does not approve broad public launch. Broad public launch still needs owner/security approval, approved live read-only smoke, approved public docs wording, signed/notarized packaging posture, and desktop MCP packaging posture.
- Provenance-backed generated list and read commands now use the target Straddle envelope.
- Command-specific local helpers routed through `printJSONFiltered`, such as `which --agent`, now use the target Straddle envelope only for `--agent`; normal `--json` stays raw.
- `about --agent` uses the target Straddle envelope for local preview status.
- `sync --agent` and real `tail --agent` event streams now emit the target envelope while normal `--json` streams remain raw NDJSON.
- Command grammar needs review against real developer and agent workflows.
- Setup, customers, and payments workflows need end-to-end examples beyond the sandbox-safe read-only walkthrough.
- Sandbox testing now has the help-only `straddle-pp-cli sandbox guide [scenario]` terminal flow. Live writes remain out of scope.
- Reconciliation, fraud monitoring, collections, reporting, and monitoring now have the help-only `straddle-pp-cli ops guide [workflow]` terminal flow and the structured local-only `straddle-pp-cli workflow plan [workflow]` command plan flow. Live execution, API reads, docs lookup execution, MCP execution, webhook posts, production writes, and full workflow engines remain out of scope.
- Approved live-smoke planning now has the local-only `straddle-pp-cli smoke plan [scope]` terminal flow. The `approval` scope reduces the live-smoke blocker by turning required written approval into structured output, but it does not run live smoke or approve launch.
- Public-release readiness now has the local-only `straddle-pp-cli release plan [surface]` terminal flow. It reduces the distribution, compatibility, docs, support, and owner-decision blockers by making archive, current-CLI compatibility, docs/support, Homebrew, MCP, naming, npm, owner decision, and signing decisions explicit, but it does not publish, approve launch, replace `straddle`, approve public docs, approve support, approve live smoke, or approve workflow execution claims.
- Credential storage readiness now has the local-only `straddle-pp-cli credentials plan [surface]` terminal flow. It reduces the auth launch blocker by making config, environment, MCP, keychain, packaged-client local smoke, and launch decisions explicit, but it does not build packages, run binaries, read or write credentials, execute MCP tools, or approve launch.

## Later Polish

These gaps should stay visible, but they do not block the first public replacement decision unless product review makes them launch-critical:

- Skills and agent-facing guidance need parity work.
- MCP output exists from the generated command tree, but still needs product review.
- Docs parity and examples need review beyond the launch-critical setup, customer, payment, sandbox, and docs-search paths.
- Word art and presentation polish are partially done through `about`; richer product review remains open.
- The reconciliation, fraud monitoring, collections, reporting, and monitoring workflows have local-only `ops guide` planning guidance and structured `workflow plan` command plans, but still need practical command review, approved live-read paths, and full workflow engines before launch.
- Approved live-smoke planning now includes a structured approval packet scope, but the actual approved live read-only smoke with secure credentials has not been run.
