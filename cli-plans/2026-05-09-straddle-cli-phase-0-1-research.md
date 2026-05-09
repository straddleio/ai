# Straddle CLI Phase 0 and Phase 1 Research

## Scope

This artifact covers Phase 0 Resolve + Reuse and Phase 1 Research Brief for the Straddle Printing Press CLI full workflow. It is research and planning only. It does not authorize implementation code changes.

Repo: `/Users/js/clawd/straddle/straddle-ai`

Straddle AI commit: `22bab6a876a0ec7815bb8e250eb12806b9ba325e`

## Phase 0 Resolve + Reuse

### OpenAPI source

- Source file: `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`
- Source repo commit: `353b0bd2f4291881a84063f00385a3800bd363b8`
- Source URL: `https://github.com/straddleio/straddle-docs/blob/353b0bd2f4291881a84063f00385a3800bd363b8/docs/api-reference/openapi.json`
- Generated copy: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/spec.json`
- Evidence: the spec names the OpenAPI source at `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json` in the CLI spec, and `.printing-press.json` records the same value as both `spec_url` and `spec_path` with checksum `sha256:90bb4d941ce5860a3ef5550932efb3dca26f78062753b9bd9ecdd80b260142d8`. See `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:15`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:16`, and `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/.printing-press.json:10`.

### Existing artifacts

- Master workflow: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md`
- Existing spec: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md`
- Existing plan: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-plan.md`
- Existing audit: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`
- Package README: `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md`
- Generated CLI README: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md`
- Generated CLI root: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli`
- Generated CLI entrypoint: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/cmd/straddle-pp-cli/main.go`
- Generated MCP entrypoint: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/cmd/straddle-pp-mcp/main.go`
- Generated MCP internals: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/internal/mcp`
- Generated MCP bundle manifest: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/manifest.json`
- Printing Press generator checkout: `/tmp/straddle-cli-research-generator`, commit `3b929c6ec55a309e10ffac58d4d7e576c80fdfae`, remote `https://github.com/mvanhorn/cli-printing-press`
- Existing Stainless Straddle CLI reference: `/Users/js/clawd/straddle/sdks/sdks/straddle-cli`, commit `c0f702d5f87e8022bce37c5b9c6445d4dbcd6bd5`

The workflow requires exact paths for existing spec, plan, audit, generated CLI, generated MCP, and README before generation or validation. See `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:54` and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:67`.

### Token requirements

- The generated CLI uses bearer token auth.
- The generated config records `auth_type` as `bearer_token`.
- The configured environment variable is `STRADDLE_TOKEN`.
- The MCP bundle manifest marks `straddle_token` as sensitive and required.
- The current generated auth command stores a token through `straddle-pp-cli auth set-token <token>`, which passes the token through argv. The next slice already calls for a safer stdin or equivalent path.
- No secret value was read, printed, requested, or used.

Evidence: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/.printing-press.json:18`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/.printing-press.json:19`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/manifest.json:23`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/manifest.json:27`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/internal/cli/auth.go:77`, and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:215`.

### Reused artifacts

- Reused the master workflow because it states this work is planning and documentation, not implementation. See `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:5` and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:7`.
- Reused the existing spec for source path, generator, CLI target, MCP target, and first-slice boundaries. See `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:15`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:20`, and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:143`.
- Reused the existing plan for the implementation order and architecture decisions. See `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-plan.md:13` and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-plan.md:23`.
- Reused the existing audit for current status and remaining blockers. See `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-audit.md:9`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-audit.md:15`, and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-audit.md:124`.
- Reused the package README for regeneration, verification, Ramp benchmark, Stainless reference, and launch blocker notes. See `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:24`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:43`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:80`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:95`, and `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:107`.
- No cached `/tmp` Ramp or Firecrawl artifact was used. A local `/tmp` search for Ramp, Stainless, and Firecrawl artifacts returned no usable files at the searched depth.

## Phase 1 Research Brief

### API identity

- Product name: Straddle API.
- Source spec: `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`.
- Generated spec copy: `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/spec.json`.
- Auth model: bearer token auth with JWT API keys in the `Authorization` header.
- CLI target: `straddle-pp-cli`, a Go CLI generated by Printing Press.
- MCP sibling: `straddle-pp-mcp`, generated from the same Printing Press command tree.
- Launch surface: local preview under `packages/cli/straddle-pp-cli` until release packaging, auth polish, agent JSON, sandbox-safe examples, docs search, and product review are complete.

Evidence: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:5`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:18`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:20`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:11`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:21`, and `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:23`.

### Competitor notes

- Ramp benchmark only: use Ramp to compare installer quality, auth setup, agent JSON envelope, command grammar, skills packaging, MCP positioning, docs coverage, examples, and presentation polish. Do not use Ramp as architecture.
- Stainless reference only: use the existing Straddle Stainless CLI to compare resource coverage, useful flags, and behavior that existing users may rely on. Do not use Stainless as source code or source of truth.
- Printing Press required: the generated Go CLI and generated MCP server must come from Printing Press and the Straddle public OpenAPI source.

Evidence: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:13`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:14`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:15`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:80`, and `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:95`.

### Data-flow notes

- Local CLI behavior: the CLI can run local help, dry-run, validation, generated Go tests, and generated builds without production calls. The config defaults to `https://sandbox.straddle.com`, but local verification should stay at help, dry-run, build, and sandbox-safe read-only flows unless credentials are explicitly approved.
- Sandbox API behavior: sandbox is the testing and development environment. Sandbox keys are separate from production keys. Sandbox-only endpoints exist, including simulated funding events and account status simulation.
- Production API behavior: production is live transaction infrastructure. This research did not make production calls, and production calls remain out of scope unless explicitly approved in a later live smoke step.
- MCP behavior: the generated MCP binary is `straddle-pp-mcp`, and the existing Straddle MCP reference shows production read-only and destructive-operation blocking patterns that should inform launch safety review.

Evidence: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:16`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:18`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:9`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:15`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:16`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:42`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:45`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md:590`, and `/Users/js/clawd/straddle/straddle-ai/skills/straddle-integrate/references/mcp-server.md:151`.

### Product thesis

The Straddle CLI should turn the public OpenAPI surface into a terminal product that helps developers and agents set up auth, explore the API, test safely in sandbox, inspect customers and payments, and connect to MCP from the same generated command tree. The first useful launch surface is a local preview that proves provenance, command coverage, safety boundaries, and upgrade gaps before replacing any public binary.

### Launch-blocker list

- Safe token input is not done. Current generated docs and command shape still expose an argv token path.
- Auth docs are not final across environment variable, config file, and safer stdin or equivalent input.
- Agent JSON output is not launch-ready for the target envelope.
- Generated README and SKILL install docs still imply unavailable published artifacts in some places.
- MCP smoke proof is not yet documented for the generated `straddle-pp-mcp` binary.
- Sandbox-safe setup plus read-only customer and payment walkthrough is not complete.
- Installer and release packaging are not done.
- Command grammar still needs review against real developer and agent workflows.
- Docs search, sandbox testing, reconciliation, fraud monitoring, and collections workflows need staged product review.

Evidence: `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:107`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:111`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:112`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:113`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:115`, `/Users/js/clawd/straddle/straddle-ai/packages/cli/README.md:116`, and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-audit.md:126`.

### Non-goals

- Do not edit `providers/*` synced copies for this research artifact.
- Do not touch implementation code.
- Do not make production API calls.
- Do not read, print, request, or commit secrets.
- Do not treat Ramp as architecture.
- Do not treat Stainless as source of truth.
- Do not hand-build a separate MCP command tree.
- Do not publish, tag, replace the public `straddle` binary, or change install channels in this phase.
- Do not implement the full agent JSON target envelope in Phase 0 or Phase 1.
- Do not build full reconciliation, fraud monitoring, collections, or sandbox workflow engines in this phase.

Evidence: `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:12`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:16`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-cli-full-workflow.md:17`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:157`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:165`, `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:201`, and `/Users/js/clawd/straddle/straddle-ai/cli-plans/2026-05-09-straddle-printing-press-cli-spec.md:217`.

## Phase 0 and Phase 1 verdict

Phase 0 is resolved enough for the next documentation or spec review slice: the OpenAPI source is identified, reused artifacts are listed, token requirements are stated without secrets, and generated CLI plus MCP paths are known.

Phase 1 is resolved enough for review: the API identity, competitor boundaries, data-flow boundaries, product thesis, launch blockers, and non-goals are explicit. No browser research or live API smoke was needed for this artifact.
