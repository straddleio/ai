# Current CLI Compatibility Inventory: Stainless `straddle` And Printing Press Preview

Date: 2026-05-10

## Scope

This is local compatibility evidence only.

It compares the installed Stainless-generated `straddle` command at `/opt/homebrew/bin/straddle` with the Printing Press preview command built locally as `/tmp/straddle-pp-cli-compat`.

Stainless is a downstream behavior reference only. Printing Press remains the required generator and foundation for the preview CLI and MCP sibling.

This artifact does not approve replacing the public `straddle` command, aliasing, migration, public launch, support wording, docs wording, publishing, signing, notarization, live smoke, or Straddle API calls.

## Commands Run

Run from `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli`.

| Command | Exit | Evidence |
|---------|------|----------|
| `go build -o /tmp/straddle-pp-cli-compat ./cmd/straddle-pp-cli` | 0 | Built the preview binary locally. |
| `/opt/homebrew/bin/straddle --version` | 0 | Printed `straddle version 0.1.0`. |
| `/opt/homebrew/bin/straddle --help` | 0 | Printed installed public command help. |
| `/opt/homebrew/bin/straddle charges create --help` | 0 | Confirmed installed `charges create` help exists. |
| `/opt/homebrew/bin/straddle customers list --help` | 0 | Confirmed installed `customers list` help exists. |
| `/tmp/straddle-pp-cli-compat --help` | 0 | Printed preview command help. |
| `/tmp/straddle-pp-cli-compat charges create --help` | 0 | Confirmed preview `charges create` help exists. |
| `/tmp/straddle-pp-cli-compat customers list --help` | 0 | Confirmed preview `customers list` help exists. |
| `/tmp/straddle-pp-cli-compat release plan compatibility --json` | 0 | Printed local-only compatibility planning output. |
| `git -C /Users/js/clawd/straddle/sdks/sdks/straddle-cli remote -v` | 0 | Confirmed source remote. |
| `rg -n "generated with Stainless|stainless" /Users/js/clawd/straddle/sdks/sdks/straddle-cli/README.md /Users/js/clawd/straddle/sdks/sdks/straddle-cli/pkg/cmd/cmd.go` | 0 | Found Stainless marker in README. |

The temporary binary was removed after capture.

## Installed Stainless CLI Evidence

| Evidence | Observed value |
|----------|----------------|
| Public command | `straddle` |
| Installed path | `/opt/homebrew/bin/straddle` |
| Version | `0.1.0` |
| Source remote | `https://github.com/stainless-sdks/straddle-cli` |
| Stainless source marker | `/Users/js/clawd/straddle/sdks/sdks/straddle-cli/README.md:5` says the CLI is generated with Stainless. |
| `pkg/cmd/cmd.go` marker search | The requested marker search returned no Stainless line from `pkg/cmd/cmd.go`. |

High-level installed help shape:

- Name: `straddle`, described as a CLI for the Straddle API.
- API resource groups shown in help: `embed:accounts`, `embed:accounts:capability-requests`, `embed:linked-bank-accounts`, `embed:organizations`, `embed:representatives`, `bridge`, `bridge:link`, `customers`, `customers:review`, `paykeys`, `paykeys:review`, `charges`, `funding-events`, `payments`, `payouts`, `reports`.
- Global output controls include debug, base URL, response format, transforms, environment, help, and version.
- Help includes credential-related global options. Those details are intentionally not repeated here because this artifact should not create token examples or token-literal guidance.

## Printing Press Preview Evidence

| Evidence | Observed value |
|----------|----------------|
| Preview command | `straddle-pp-cli` |
| Built path | `/tmp/straddle-pp-cli-compat` |
| Foundation | Generated preview from Printing Press, with local patch surfaces for Straddle CLI work. |
| Compatibility planning surface | `release plan compatibility --json` |
| Compatibility command result | Local-only, guidance-only, no API calls, no publishing, no signing, no notarization, no secret reads, no MCP execution. |

High-level preview help shape:

- Name: `straddle-pp-cli`, described as managing Straddle resources via the Straddle API.
- API groups shown in help include `account-settings`, `accounts`, `bridge`, `charges`, `customers`, `funding-events`, `funding-event-payments`, `linked-bank-accounts`, `organizations`, `paykeys`, `payments`, `payouts`, `reports`, and `representatives`.
- Preview-only local and agent surfaces include `about`, `agent-context`, `analytics`, `api`, `auth`, `credentials`, `docs`, `doctor`, `feedback`, `import`, `ops`, `profile`, `release`, `sandbox`, `search`, `setup`, `smoke`, `sync`, `tail`, `which`, and `workflow`.
- Global preview flags include agent mode, compact output, CSV, dry-run, data source, delivery sinks, JSON, no-input, profile, rate limit, field selection, timeout, and confirmation control.

## Command-Level Comparison

| Surface | Installed `straddle` | Preview `straddle-pp-cli` | Compatibility note |
|---------|----------------------|---------------------------|--------------------|
| Public command name | `straddle` | `straddle-pp-cli` | The preview name avoids taking over the public command. Publishing as `straddle` remains an explicit owner decision. |
| Version output | `straddle version 0.1.0` | Not part of this capture. | Installed version is captured. Preview version was not required for this inventory. |
| Top-level API groups | API resource groups only. | API groups plus local planning, setup, docs, release, MCP-adjacent, sync, search, and workflow surfaces. | The preview is broader than the current public API wrapper. |
| Charges create | Exists. Flags include amount, config, consent type, currency, description, device, external ID, paykey, payment date, metadata, and request headers. | Exists. Flags largely overlap and add preview ergonomics such as stdin body input plus global dry-run, JSON, agent, no-input, and selection controls. | Good command-name overlap, with preview-specific execution and output controls. |
| Customers list | Exists. Flags include created date filters, email, external ID, name, page number, page size, search text, sort, status, type, request headers, and max items. | Exists. Flags largely overlap and add `--all`, preview global output controls, local or live data source selection, and agent-friendly non-interactive controls. | Good command-name overlap, with pagination and agent differences to review before migration. |
| Resource naming | Uses some colon-delimited groups, especially `embed:*` and review groups. | Uses more direct groups such as `accounts`, `linked-bank-accounts`, `organizations`, and `representatives`. | A migration plan must decide whether to preserve colon names, add aliases, or document changes. |
| Local planning features | Not present in top-level help. | Present: release, smoke, workflow, ops, credentials, setup, docs, search, sync, analytics, profile, agent-context. | These are preview additions, not compatibility proof for replacing public `straddle`. |

## Overlaps

- Both expose `charges create`.
- Both expose `customers list`.
- Both expose common API areas: bridge, customers, paykeys, charges, funding events, payments, payouts, and reports.
- Both expose help-first command discovery without requiring credentials.
- Both can be inspected locally without Straddle API calls.

## Differences

- The installed public command is `straddle`; the preview command is `straddle-pp-cli`.
- The installed CLI source remote points to `stainless-sdks/straddle-cli`; the preview is generated from Printing Press and lives under `straddle-ai`.
- Installed help presents a narrower API-resource wrapper shape.
- Preview help presents API operations plus local-first planning, release, docs, MCP-adjacent, sync, search, workflow, and agent-output features.
- Installed resource naming includes colon-delimited `embed:*` and review groups. Preview uses direct resource groups in top-level help.
- Preview `customers list` has `--all`; installed `customers list` has `--max-items`.
- Preview commands include `--stdin`, `--dry-run`, `--agent`, and structured output controls that are not equivalent to the installed CLI help shape.

## Migration Implications

- The preview cannot silently replace `/opt/homebrew/bin/straddle` based on this evidence.
- A public command-name decision is still open: keep `straddle-pp-cli`, publish as `straddle`, add an alias, or defer replacement.
- If owners choose `straddle`, the next review needs a compatibility matrix for colon-delimited resource names, pagination flags, global output flags, request-header flags, examples, exit behavior, and generated command descriptions.
- If owners keep `straddle-pp-cli` for preview, docs can honestly describe it as a local preview without promising replacement compatibility.
- Public docs and support wording must not imply that this inventory approves migration or existing-user support.

## Local Compatibility Verdict

Evidence improved.

The installed Stainless-generated CLI and the Printing Press preview share important Straddle API command names and resource areas. The preview also adds local planning and agent features that are not present in the installed public command.

The naming and migration decision remains unresolved. This inventory supports a future owner decision, but it does not make that decision.
