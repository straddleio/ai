# Straddle Printing Press CLI Preview

This package documents the generated Straddle CLI preview. The preview lives in `packages/cli/straddle-pp-cli` and is generated from Straddle's public OpenAPI file:

```text
/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json
```

Printing Press is required for this work. The actual generator is `mvanhorn/cli-printing-press`. `mvanhorn/printing-press-library` is the public catalog, examples, and distribution reference, not the generator used to produce this preview.

The generated project includes the CLI first and an MCP sibling from the same Printing Press command tree. The preview binary is `straddle-pp-cli`. The generated MCP binary is `straddle-pp-mcp`.

## Current Slice

Task 1 created the first generated baseline with these quality facts:

- No local build binaries are kept in the repo.
- Credential-shaped Postman environment details were scrubbed from generated artifacts.
- `gofmt` was clean.
- `go test ./...` passed.

The first auth contract slice added `straddle-pp-cli auth set-token --stdin` so config-file token setup no longer requires a token in argv. This is still not a public launch candidate. Reviewers still need to inspect command coverage, generation provenance, MCP shape, and the remaining workflow gaps.

## Auth Paths

The preview supports three credential paths:

- `STRADDLE_TOKEN` for shells, CI, and MCP launches that inject credentials through the environment.
- Config-file auth through safe stdin input:
  ```bash
  read -r -s STRADDLE_TOKEN_INPUT
  straddle-pp-cli auth set-token --stdin <<<"$STRADDLE_TOKEN_INPUT"
  unset STRADDLE_TOKEN_INPUT
  ```
- A custom config file with `--config /path/to/config.toml`, including `auth set-token --stdin --config /path/to/config.toml` and `auth status --config /path/to/config.toml`.

Do not commit tokens. Do not print tokens in logs. Do not pass tokens in argv unless you are using the legacy compatibility path and have accepted the shell history and process-list risk.

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

- Installer and release packaging are not done.
- Safe token input exists for config-file auth, but auth setup and token handling still need broader review before launch.
- Agent JSON envelope may not match the target Straddle contract.
- Command grammar needs review against real developer and agent workflows.
- Setup, customers, and payments workflows need end-to-end examples and sandbox-safe verification.
- Sandbox testing and docs search need first-class terminal flows or clear guidance.

## Later Polish

These gaps should stay visible, but they do not block the first public replacement decision unless product review makes them launch-critical:

- Skills and agent-facing guidance need parity work.
- MCP output exists from the generated command tree, but still needs product review.
- Docs parity and examples need review beyond the launch-critical setup, customer, payment, sandbox, and docs-search paths.
- The word art and presentation polish are still open.
- The reconciliation, fraud monitoring, and collections workflows need practical command review and staged follow-up plans.
