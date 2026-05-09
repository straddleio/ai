# Straddle CLI Product Review

Date: 2026-05-09

Scope: product readiness review for the current Printing Press generated CLI and MCP preview. This is a review artifact only. It does not approve live API work, public release, production writes, or new packaging.

## Decision

Approved for local preview: yes, with documented limits.

Approved for public launch: no.

The current preview is good enough for local reviewer dogfood, local command discovery, MCP surface inspection, dry-run request-shape checks, docs and command search checks, and sandbox planning. It is not ready for public users because release packaging is not published, no approved live smoke has been run, and the operational workflows are still guidance-first rather than proven live workflows.

## Inputs Reviewed

- `packages/cli/README.md`
- `packages/cli/straddle-pp-cli/README.md`
- `packages/cli/straddle-pp-cli/SKILL.md`
- `packages/cli/straddle-pp-cli/.printing-press.json`
- `packages/cli/straddle-pp-cli/.printing-press-patches.json`
- `cli-plans/2026-05-09-straddle-cli-shipcheck-scorecard.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-plan.md`
- `cli-plans/2026-05-09-straddle-printing-press-cli-audit.md`
- Credential-free local checks listed below.

No token literals, secrets, production calls, or live Straddle API calls were used.

## Fresh Local Checks

Run from `/Users/js/clawd/straddle/straddle-ai` and `packages/cli/straddle-pp-cli`.

| Check | Result | Product meaning |
| --- | --- | --- |
| Build CLI and MCP preview binaries to `/tmp` | Pass | Local reviewers can inspect the generated CLI and MCP sibling without publishing. |
| `/tmp/straddle-pp-cli-product-review --help` | Pass | Root help presents setup, docs, sandbox, ops, endpoint groups, workflow, sync, tail, and MCP-relevant commands. |
| `/tmp/straddle-pp-cli-product-review setup check --json` | Pass | Local setup preflight reports config, auth, environment classification, MCP source, docs search, sandbox guide, and safety flags without network calls. |
| `/tmp/straddle-pp-cli-product-review customers list --dry-run --agent` | Pass | Agent dry-run output is a single target envelope and does not include human preview text around JSON. |
| `/tmp/straddle-pp-cli-product-review docs search payment --source commands --json` | Pass | Local command search works without auth or live API calls. |
| `/tmp/straddle-pp-cli-product-review sandbox guide --json` | Pass | Sandbox guide is help-only and requires current docs lookup plus separate approval before live sandbox execution. |
| `/tmp/straddle-pp-cli-product-review ops guide --json` | Pass | Ops guide covers reconciliation, fraud monitoring, collections, reporting, and monitoring as local guidance only. |
| MCP `tools/list` against `/tmp/straddle-pp-mcp-product-review` | Pass | Runtime returned 83 tools and included `setup_check`, `docs_search`, `sandbox_guide`, and `ops_guide`. |

## CLI First And MCP Sibling

The preview satisfies the CLI-first requirement for local review. The primary user surface is `straddle-pp-cli`, with a generated `straddle-pp-mcp` sibling from the same Printing Press command tree. This matters because command breadth, docs, and MCP exposure are not separate hand-built products.

The MCP sibling is reviewable today. It is not a public MCP package. Current evidence proves a local stdio MCP binary starts and exposes tools. It does not prove desktop packaging, hosted MCP parity, or public distribution.

## Printing Press And OpenAPI Provenance

The provenance is clear enough for local preview. `.printing-press.json` records:

- Generator: Printing Press `4.2.0`
- CLI name: `straddle-pp-cli`
- MCP binary: `straddle-pp-mcp`
- OpenAPI source: `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`
- Spec checksum: `sha256:90bb4d941ce5860a3ef5550932efb3dca26f78062753b9bd9ecdd80b260142d8`
- Generated endpoint MCP count: 70

The patch catalog is also clear enough for local review. `.printing-press-patches.json` explains the local changes that make the generated tree safer and more useful, including safe token input, target agent envelopes, dry-run agent output, setup check, docs search, sandbox guide, ops guide, MCP count breakdown, and stream agent envelopes.

## Agent-Friendly Behavior

The current preview is agent-friendly enough for local review.

Target envelope: generated list and read commands, local helper commands under `--agent`, `agent-context --agent`, `about --agent`, `setup check --agent`, `sync --agent`, and real `tail --agent` are documented as using the target envelope.

Dry-run agent purity: `customers list --dry-run --agent` emitted one JSON envelope with `data.dry_run: true` and no surrounding human text. This clears the local dry-run output concern for the checked path.

Setup check: `setup check` is the right first command. It reports local state and safety flags without calling Straddle APIs, docs endpoints, MCP, webhooks, or production.

Docs search: `docs search` is correctly separate from local synced-data `search`. Command search is local. Product docs search can call the unauthenticated docs MCP endpoint, and endpoint overrides are constrained to loopback local tests.

Sandbox guide: `sandbox guide` gives scenario guidance and requires current docs lookup plus separate approval before live sandbox work.

Ops guide: `ops guide` is useful as planning guidance. It does not run operational workflows, call APIs, execute MCP tools, post webhooks, or write production data.

Stream contract: `sync --agent` and real `tail --agent` have a documented stream contract, one target envelope per stdout line, with terminal chatter on stderr. This is enough for local contract review. It is not a substitute for approved live monitoring smoke.

## Practical Workflow Readiness

Setup: ready for local preview. The setup path has `about`, `setup check`, safe stdin token guidance, environment classification, and optional sandbox reachability through `doctor` only after explicit sandbox configuration.

Customers: ready for local command discovery, read-side planning, and dry-run request-shape checks. Not approved for live creates, updates, deletes, or public examples that imply write safety.

Payments: ready for local command discovery across charges, payouts, paykeys, payments, funding events, and reports. Read-only examples are documented. Live payment writes and status simulations remain out of scope.

Reconciliation: partially ready. `ops guide reconciliation` gives docs queries, funding event surfaces, charge and payout surfaces, and local analysis hints. It does not implement a matching workflow or prove live reads.

Fraud monitoring: partially ready. `ops guide fraud-monitoring` points to customers, paykeys, charges, return-code docs, and escalation boundaries. It does not block paykeys, update customers, or run a risk workflow.

Collections: partially ready. `ops guide collections` points to failed charges, returns, paykeys, and resubmit request-shape help. It does not send notices, retry payments, or run collection actions.

Reporting: partially ready. `ops guide reporting` points to customers, payments, funding events, reports, analytics, search, and SQL. It does not run live reports or produce public-ready exports.

Monitoring: partially ready. `ops guide monitoring` points to payment, funding event, webhook, tail, and local analytics surfaces. It does not poll production, send alerts, deliver webhooks, or prove live event flow.

Sandbox testing: ready for planning, not execution. `sandbox guide` covers payment lifecycle, payout flow, failures, ACH returns, funding, Bridge, Embed onboarding, and webhooks. Live sandbox writes still need separate approval, sandbox credentials, and a fresh docs lookup.

Docs and search: ready for local preview. The split between product docs, API or SDK guidance, generated command capabilities, and synced local data is now clear enough for reviewers.

## Ramp And Reference Parity

Ramp remains a high-level benchmark only. The preview now has the important local-review pieces Ramp made obvious: CLI-first presentation, agent output discipline, MCP positioning, docs-search separation, setup health, and safe workflow guidance. It does not yet have public installer polish, public MCP packaging, or production-grade workflow execution.

The existing Stainless CLI remains a reference only. The Printing Press preview has broad generated resource coverage and useful agent flags, but it should not copy Stainless architecture. Public launch should still include a focused comparison against the existing Straddle CLI behavior before replacing or publishing anything.

## Safety Review

Safe token guidance is good enough for local preview. The docs prefer `auth set-token --stdin`, allow `STRADDLE_TOKEN` through a secure caller-supplied flow, and warn against checked-in config, logs, argv, and shell-history exposure.

No production writes are approved. The current review only approves local preview dogfood and credential-free inspection.

No approved live smoke has happened. The scorecard should keep approved live smoke open until someone explicitly scopes sandbox credentials, commands, data boundaries, and expected outputs.

`ops guide`, `setup check`, and `sandbox guide` correctly avoid live side effects. Product docs search can make a docs endpoint call when used with the product source, but that is separate from Straddle transactional APIs and should still be called out in live-review instructions.

## Launch Decision

Local preview: approved.

Use the preview for internal product review, local command discovery, generated surface review, safe dry-run checks, MCP tools/list smoke, and docs or workflow planning.

Public launch: not approved.

Public launch blockers:

1. No published installer, Homebrew release, `npx` package, release archives, or desktop MCP bundle.
2. No approved live sandbox smoke with scoped credentials and expected read-only outputs.
3. No final public-launch product review after packaging and live smoke.
4. Operational workflows are guidance-only and do not prove reconciliation, fraud monitoring, collections, reporting, or monitoring execution.
5. Public docs still need launch packaging, versioning, support, and replacement-name decisions.
6. Keychain or secure-store decision remains open for launch-grade credential handling.
7. Public MCP distribution and hosted MCP relationship still need launch packaging review.

## Scorecard Impact

This artifact clears the open product-review blocker for local preview readiness. It specifically clears review of the CLI-first shape, MCP sibling relationship, Printing Press/OpenAPI provenance, agent-friendly local behavior, setup check, docs search, sandbox guide, ops guide, stream contract, and practical workflow coverage at the planning level.

It only partially clears product readiness for public launch. Public launch remains blocked by packaging, approved live smoke, launch docs, secure credential storage decisions, and workflow execution proof.
