# Spec: Straddle Printing Press CLI

## Objective

Build a new public Straddle CLI from Straddle's public OpenAPI spec using Printing Press as the required foundation.

The user is a developer or AI agent integrating with Straddle. The CLI must make setup, API exploration, sandbox testing, customer work, payment work, reconciliation, fraud review, collections, and docs lookup easier from a terminal. It must also produce a Printing Press MCP sibling from the same generated command tree, but the CLI is the primary first deliverable.

Ramp is a benchmark for packaging, agent output, command ergonomics, MCP positioning, docs, and presentation. Ramp is not the architecture. Stainless is a downstream behavior reference for existing Straddle command coverage and flags. Stainless is not the architecture.

Success means a reviewer can trace every shipped command surface back to the Straddle OpenAPI source, run local validation, and see a clear gap list for what remains before replacing or publishing the public CLI.

## Tech Stack

- Repository: `/Users/js/clawd/straddle/straddle-ai`
- OpenAPI source: `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`
- Generator: `mvanhorn/cli-printing-press`, with catalog and examples from `mvanhorn/printing-press-library`
- Generated CLI language: Go, as produced by Printing Press
- CLI binary: `straddle-pp-cli` for the generated preview
- MCP binary: `straddle-pp-mcp` when produced by Printing Press
- Existing reference CLI: `/Users/js/clawd/straddle/sdks/sdks/straddle-cli`
- Repo validation: Node scripts already present in `straddle-ai`

## Commands

Controller commands:

```bash
cd /Users/js/clawd/straddle/straddle-ai
npm run validate
npm test
git status --short --branch
```

OpenAPI inspection:

```bash
jq '.info, .servers, (.paths | length)' /Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json
```

Printing Press generation:

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

Generated CLI verification:

```bash
cd /Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli
go test ./...
go build -o /tmp/pp-cli-verify ./cmd/straddle-pp-cli
go build -o /tmp/pp-mcp-verify ./cmd/straddle-pp-mcp
/tmp/pp-cli-verify --help
/tmp/pp-cli-verify agent-context --json
rm -f /tmp/pp-cli-verify /tmp/pp-mcp-verify
```

Verification must not leave generated binaries in the repo. Build command packages to `/tmp`, run the `/tmp` CLI binary, then remove the temp binaries.

## Project Structure

```text
cli-plans/2026-05-09-straddle-printing-press-cli-spec.md
  Source of truth for requirements and acceptance criteria.

cli-plans/2026-05-09-straddle-printing-press-cli-plan.md
  Ordered task breakdown for subagent-driven implementation.

packages/cli/straddle-pp-cli/
  Generated Printing Press CLI and MCP preview.

packages/cli/README.md
  Human-facing overview, regeneration instructions, and Ramp comparison checklist.

scripts/validate.js
  Existing repo validation. It may be extended only with fast checks that do not require network or credentials.
```

Provider synced copies under `providers/*/plugin` are not source files for this work. Do not edit them directly.

## Code Style

Keep source edits plain and local. Generated Go should follow Printing Press output. Hand-authored JavaScript must use the existing repo style: Node built-ins, no new dependencies unless explicitly approved, and formatting consistent with the surrounding file.

Expected hand-authored validation style:

```js
const fs = require('node:fs')
const path = require('node:path')

function mustExist(filePath, label) {
    if (!fs.existsSync(filePath)) {
        throw new Error(`${label} is missing: ${filePath}`)
    }
}
```

Target agent JSON contract for the CLI:

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

Provenance-backed generated list and read commands now emit this target envelope for `--agent` output. Command-specific local helpers routed through `printJSONFiltered`, such as `which --agent`, also emit this target envelope only when `--agent` is active; normal `--json` output stays raw. `agent-context --agent` emits the target envelope with the existing v3 agent context object under `data`. `about --agent` also emits the target envelope for local preview status. `sync` and real `tail` event streams remain open because their streaming output paths are separate from `printJSONFiltered`.

## Streaming Agent Contract

This contract is proposed for the next implementation slice. It is not implemented yet.

`sync` and real `tail` are NDJSON streams, not single response objects. Normal human output and normal `--json` streaming behavior must remain backward compatible until a deliberate breaking change is approved.

Future `sync --agent` and `tail --agent` stream lines should write one JSON object per line to stdout. Each line should use the same top-level envelope keys as the target agent envelope:

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

The `data` object holds the event-specific payload. Every agent stream line needs a stable event name in `data.event`, an ISO timestamp in `data.timestamp` when the source has one, and no secrets or token-shaped values. Existing events such as `sync_start`, `sync_warning`, `sync_summary`, and real tail data events should map into that `data` payload instead of changing the top-level envelope.

Terminal and status chatter belongs on stderr in human mode. Agent stream data belongs on stdout. Once implemented, `sync_summary` and final tail shutdown or end events should be final envelope lines, not out-of-band text.

## Testing Strategy

Testing must prove three different things:

1. The repo still validates with `npm run validate`.
2. The generated Printing Press project has the expected files and binaries for CLI and MCP.
3. The generated Go project builds or reports a concrete upstream or spec blocker.

Fast repo checks may be wired into `npm run validate`. Heavy Go generation, Go build, or network-dependent checks should stay as explicit verification commands unless they are fast and deterministic.

Minimum checks for the first slice:

- `.printing-press.json` exists.
- `cmd/straddle-pp-cli/main.go` exists.
- `cmd/straddle-pp-mcp/main.go` exists if Printing Press generated MCP.
- `internal/mcp/` exists if the MCP binary exists.
- `spec.json` exists and reports `Straddle API`.
- `README.md` and `SKILL.md` exist in the generated project.
- Root docs explain the source OpenAPI path and regeneration command.

## Boundaries

Always:

- Use Printing Press as the generator foundation.
- Keep Ramp as a benchmark checklist only.
- Keep Stainless as a downstream behavior reference only.
- Prefer Straddle public OpenAPI over hand-authored command definitions.
- Preserve generated MCP output from Printing Press when present.
- Use subagent-driven implementation after this spec and plan exist.
- Run verification before claiming completion.
- Keep generated and hand-authored files clearly separated.
- Keep generated source and manifests, but do not keep local build binaries in this repo slice.

Ask first:

- Publishing packages, pushing tags, or replacing the public `straddle` binary.
- Adding dependencies to the root `straddle-ai` package.
- Changing the public OpenAPI source in `straddle-docs`.
- Editing generated Go by hand beyond small, documented fixes.
- Making production API calls.

Never:

- Treat Ramp as the architecture.
- Treat the Stainless CLI as the source of truth.
- Hand-build a separate MCP command tree that diverges from the generated CLI.
- Commit secrets, API keys, or local credential files.
- Edit `providers/*/plugin` synced copies directly for this CLI work.
- Claim completion from generator success alone.
- Commit local `build/stage/bin` binaries unless release packaging is explicitly in scope.

## Success Criteria

- A spec and implementation plan exist in `cli-plans/`.
- A Printing Press generated Straddle CLI preview exists under `packages/cli/straddle-pp-cli`.
- The preview is generated from the public Straddle OpenAPI spec.
- The generated CLI includes customer and payment resource commands from the spec.
- The generated MCP sibling exists or a precise Printing Press blocker is documented.
- A `packages/cli/README.md` explains how to regenerate, verify, and compare against Ramp and Stainless.
- Fast validation checks are added for the generated artifact shape.
- `npm run validate` passes.
- Generated Go verification is run, or a concrete failure is documented with command output.
- A subagent spec reviewer confirms the implementation matches this spec.
- A subagent code-quality reviewer confirms the implementation is simple, scoped, and maintainable.

## First Slice

The first implementation slice is not the full public launch. It must create the default Printing Press baseline and enough verification to make the next gaps obvious.

Included:

- Full public OpenAPI generation.
- CLI and MCP generated output.
- Shape validation.
- README with regeneration, verification, and comparison checklist.
- Documented gaps for agent JSON envelope, installer, auth polish, word art, skills, docs parity, and workflow commands.

Not included unless Printing Press generates it by default:

- Replacing Homebrew or public install channels.
- Publishing a release.
- Production API calls.
- Full custom workflow commands for reconciliation, fraud monitoring, collections, and sandbox scenarios.
- Manual generated-code overhaul.

## Completed Slice: CLI contract and honesty

This slice reduced launch-blocking ambiguity without trying to build the full workflow engine. It is still not the full public launch.

Scope:

- Add a safe token input path such as `auth set-token --stdin`, or an equivalent non-echo, non-argv credential path.
- Document the supported auth paths clearly: environment variable, config file, and any new stdin token path.
- Document that provenance-backed generated list/read output, `printJSONFiltered` command-specific local output under `--agent`, and `about --agent` use the target envelope.
- Document that normal `printJSONFiltered --json` output stays raw, and that `sync` and real `tail` event streams still do not use the target envelope.
- Update generated README and SKILL install docs so they stop implying unavailable published artifacts. They must clearly separate local preview, future release, MCP registration, and public launch.
- Add MCP smoke instructions that prove `straddle-pp-mcp` starts and exposes generated tools from the generated command tree.
- Add one sandbox-safe walkthrough for setup plus read-only customer and payment exploration. The walkthrough must not make production calls.
- Document the extension point for hand-authored commands as a patch layer. Use `// PATCH:` comments plus `.printing-press-patches.json`, because root registration is generated and can be overwritten.

Boundaries:

- Do not publish packages.
- Do not add OAuth.
- Do not build a full skill manager.
- Do not create word art.
- Do not hand-build a separate MCP tree.
- Do not hand-edit MCP tools to expose workflow commands.
- Do not edit `providers/*` synced copies.
- Do not make production API calls.
- Keep implementation changes small enough for focused spec and quality review.

Acceptance criteria:

- The auth path accepts a token without echoing it in the terminal and without passing it through argv, or the chosen equivalent is documented with the same safety properties.
- The README documents env, config, and stdin or equivalent auth paths without implying that secrets should be committed.
- The `--agent` output contract is documented. The README and audit state that provenance-backed generated list/read output, `printJSONFiltered` command-specific local output under `--agent`, and `about --agent` use the target envelope, while `sync` and real `tail` event streams remain an agent JSON gap that is not launch-ready.
- Generated install docs separate local preview, future release, MCP registration, and public launch.
- MCP smoke docs build or run `straddle-pp-mcp` from the generated project and verify that generated tools are exposed without a separate MCP tree.
- The walkthrough uses sandbox-safe setup and read-only customer and payment exploration only.
- The patch layer is documented with `// PATCH:` comments and `.printing-press-patches.json`, and the docs explain why root registration should not be hand-edited.
- Spec and quality review gates pass before the slice is marked complete.

Verification:

- Run root validation with `npm run validate`.
- Run generated Go tests and builds to `/tmp`.
- Run a CLI auth help or dry-run check that proves the new token input path is discoverable without printing a token.
- Verify the docs explicitly mark `sync` and real `tail` event streams as not launch-ready for the target envelope.
- Run the MCP smoke command from the generated project and record the output that proves generated tools are exposed.
- Review generated README and SKILL docs for local preview, future release, MCP registration, and public launch wording.
- Run the sandbox-safe walkthrough without production credentials or production API calls.
- Run a text check for banned punctuation, banned terms, and emoji in the planning and CLI docs.

## Open Questions

- Should the preview binary eventually be renamed from `straddle-pp-cli` to `straddle`, or should the Printing Press preview remain side-by-side until release?
- Should secrets be stored through OS keychain in the first public replacement, or should the first replacement keep environment-variable auth only?
- Which workflows are launch blockers: reconciliation, fraud monitoring, collections, sandbox testing, docs search, or all of them as staged follow-ups?
