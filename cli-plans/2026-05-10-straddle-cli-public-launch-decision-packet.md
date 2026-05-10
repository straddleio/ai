# Public Launch Decision Packet: Straddle Printing Press CLI

Date: 2026-05-10

## Objective And Scope

This packet reduces the public-launch blocker from the completion audit by turning open questions into approval choices, evidence requirements, and explicit stop lines.

Scope: public Straddle CLI launch readiness for `straddle-pp-cli` and `straddle-pp-mcp`.

Not scope: public launch approval. This packet does not approve publishing, signing, notarization, live API calls, production use, public docs, public support commitments, or replacement of any existing Straddle CLI surface.

## Current Known Evidence

- Local preview is approved with limits in `cli-plans/2026-05-09-straddle-cli-product-review.md`.
- Public launch is not approved. Existing docs say public release artifacts are not published and no public-launch product review has approved packaging, live smoke, docs, command name, support expectations, or MCP distribution.
- Printing Press and OpenAPI provenance are documented. `.printing-press.json` records Printing Press `4.2.0`, `cli_name: straddle-pp-cli`, `mcp_binary: straddle-pp-mcp`, and the OpenAPI source at `/Users/js/clawd/straddle/sdks/straddle-docs/docs/api-reference/openapi.json`.
- The generated MCP sibling exists from the same Printing Press command tree. The latest completion audit records a credential-free runtime `tools/list` smoke with `tool_count: 87`.
- Release archive local proof exists. Prior release validation produced local darwin, linux, and windows snapshot archives containing both `straddle-pp-cli` and `straddle-pp-mcp`, plus a local Homebrew cask. Nothing was published, uploaded, pushed, signed, notarized, or written to a tap.
- Safe token stdin exists. Docs prefer `auth set-token --stdin`, allow caller-supplied environment injection, and warn against checked-in config, logs, argv, and shell-history exposure.
- Credential launch posture remains undecided. `credentials plan launch` reports that no OS keychain or secure-store implementation exists yet, and launch needs a decision between env/config-only for first public release and implementing OS secure storage.
- Live smoke has not run. Existing docs keep approved live read-only smoke open until sandbox or approved-environment credentials, command scope, data boundaries, expected outputs, and stop criteria are explicitly approved.
- Ramp is a benchmark only. It should inform ergonomics, docs posture, MCP positioning, packaging expectations, and presentation checks.
- Stainless is a reference only. It can inform existing Straddle behavior and compatibility questions, but it is not the architecture.
- Printing Press and OpenAPI remain the source and foundation for this CLI and MCP sibling.

## Decision Table

<table>
<thead>
<tr>
<th>Decision</th>
<th>Owner choice prompt</th>
<th>Recommended default</th>
<th>Rationale</th>
<th>Evidence required before approval</th>
<th>Must not happen without approval</th>
</tr>
</thead>
<tbody>
<tr>
<td>Public binary name</td>
<td>Should the public command be <code>straddle</code> or stay preview-scoped as <code>straddle-pp-cli</code>?</td>
<td>Keep <code>straddle-pp-cli</code> for any preview publish. Reserve <code>straddle</code> for a replacement decision after compatibility review.</td>
<td>The current generated name is honest. Publishing <code>straddle</code> implies an official user-facing CLI and possible replacement of existing behavior.</td>
<td>Inventory of existing Straddle CLI behavior, command collision review, migration or alias plan, public help output review, and product approval for the name.</td>
<td>Do not publish, document, or alias the command as <code>straddle</code>. Do not replace an existing public or internal CLI path.</td>
</tr>
<tr>
<td>Release channel</td>
<td>Which first public channel should be approved: GitHub archives, Homebrew, npm, <code>npx</code>, or a smaller private preview channel?</td>
<td>Start with GitHub release archives for an approved preview. Add Homebrew and npm or <code>npx</code> only after installer and support expectations are accepted.</td>
<td>Local archive proof exists and is closest to current evidence. Homebrew and npm add registry ownership, versioning, install docs, support, and rollback obligations.</td>
<td>Fresh non-publishing release check, archive inspection for both binaries, versioning plan, checksum plan, release notes draft, rollback plan, owner approval for the selected channel, and proof no secrets enter release logs.</td>
<td>Do not upload GitHub releases, push Homebrew taps, publish npm packages, create <code>npx</code> install docs, or imply public availability.</td>
</tr>
<tr>
<td>macOS signing and notarization</td>
<td>Is unsigned preview distribution acceptable, or must macOS binaries be signed and notarized before any external user can install them?</td>
<td>Require signing and notarization before broad public launch. Allow unsigned binaries only for tightly scoped internal or partner preview with explicit warning text.</td>
<td>Unsigned macOS binaries create user friction and trust risk. Signing posture is part of public launch quality, not a code detail.</td>
<td>Apple developer account owner, certificate storage plan, CI signing flow, notarization proof on a clean macOS machine, Gatekeeper install evidence, and approved user-facing warning text if unsigned preview is allowed.</td>
<td>Do not ship broad public macOS install instructions, Homebrew casks, or marketing copy that hides unsigned or unnotarized status.</td>
</tr>
<tr>
<td>Desktop MCP packaging</td>
<td>Should <code>straddle-pp-mcp</code> ship as a public desktop MCP binary, stay manual local-build only, or defer to hosted MCP?</td>
<td>Keep manual local-build MCP for preview. Treat desktop MCP packaging as a staged follow-up unless a public MCP owner approves packaging and support.</td>
<td>The MCP runtime smoke proves local stdio behavior and 87 tools. It does not prove desktop packaging, client install flows, automatic configuration, or hosted MCP parity.</td>
<td>Desktop client matrix, install and uninstall instructions, secure token injection examples with no token literals, tool count smoke from packaged binary, hosted MCP relationship decision, and support owner approval.</td>
<td>Do not publish a desktop MCP bundle, claim hosted parity, auto-edit user MCP configs, or document token-bearing command lines.</td>
</tr>
<tr>
<td>Credential storage posture</td>
<td>For first public release, is env/config-only approved, or must OS secure storage ship first?</td>
<td>Use env/config-only only for internal or approved preview. For broad public launch, require OS secure storage or a signed risk acceptance from product and security owners.</td>
<td>Safe stdin reduces exposure, but config-file auth is not the same as launch-grade credential storage. The current docs say this remains open.</td>
<td>Security owner decision, threat model for local config and MCP launches, token redaction checks, no argv token paths in examples, storage migration plan if secure storage is deferred, and approved docs wording.</td>
<td>Do not describe env/config-only as sufficient for launch, do not print token literals, do not store secrets in generated docs, and do not add public onboarding that treats config-file tokens as final without approval.</td>
</tr>
<tr>
<td>Live smoke scope</td>
<td>Which read-only live smoke is approved: setup only, customers, payments, funding, MCP tools/list, all, or none?</td>
<td>Approve setup plus one narrow read-only sandbox entity-list path first. Keep payments, funding, and broader MCP use staged until the first run is reviewed.</td>
<td>The highest value blocker is proof that the generated CLI can read from an approved environment. Starting narrow limits credential and data risk.</td>
<td>Written approval naming environment, credential source, allowed commands, expected redacted outputs, data boundaries, stop criteria, transcript storage path, and reviewer signoff.</td>
<td>Do not run production commands, write commands, webhook posts, token-bearing examples, live docs claims, or broad workflow runs.</td>
</tr>
<tr>
<td>Public docs and support scope</td>
<td>What public docs are approved for launch, and who owns support for issues, install failures, credential questions, and MCP client setup?</td>
<td>Publish a preview-scoped README and release notes only after launch decisions are accepted. Defer broad docs, tutorials, and support promises until owners are named.</td>
<td>Public docs create commitments. Current docs are honest for local preview, but not approved public onboarding.</td>
<td>Approved install path, command name, support owner, issue intake path, support boundaries, known limits, security wording, docs owner approval, and final review against current generated behavior.</td>
<td>Do not publish public quickstarts, customer workflow tutorials, payment examples, support promises, or replacement language.</td>
</tr>
<tr>
<td>Workflow execution blocker</td>
<td>Must reconciliation, fraud monitoring, collections, reporting, and monitoring execution be proven before launch, or can they be staged follow-up after CLI discovery and read-only smoke?</td>
<td>Do not block preview launch on workflow execution. Block broad public launch on clear wording that workflow commands are planning guidance unless live execution is later approved and proven.</td>
<td>The current workflow commands are useful planning guidance, not engines. Treating them as public operational workflows would overclaim the product.</td>
<td>For staged follow-up: docs wording that says planning guidance only, public examples limited to read-only discovery, and backlog items for each workflow. For launch blocker: approved workflow specs, live read evidence, error handling, audit logs, and owner signoff.</td>
<td>Do not market workflow execution, imply reconciliation or collections automation, run write actions, or publish examples that look like operational approval.</td>
</tr>
</tbody>
</table>

## Safe Live-Smoke Approval Packet

This packet is the minimum approval text needed before anyone runs live CLI commands.

### Required Approval Fields

- Approver name and role.
- Environment: sandbox, or another explicitly approved non-production environment. Production is out of scope for this packet.
- Credential source: secure caller-supplied secret flow only. No token literals in prompts, docs, shell history, command args, logs, screenshots, PR comments, or issue comments.
- Scope: one of the real CLI `smoke plan` scopes for the first run: `setup`, `customers`, `payments`, `funding`, or `mcp`. Approval must also state that only read-only commands are allowed inside that scope. Prefer `setup` plus one entity-list path for the first run. The broader `all` smoke scope requires a later expanded-smoke approval after the first narrow run is reviewed.
- Transcript location: local artifact path for redacted command output.
- Expected evidence: redacted command, exit code, endpoint or tool name, environment classification, object count or empty-list proof, and no token exposure.
- Stop criteria: any production base URL, any non-read-only operation, any token printed to stdout or stderr, any unexpected prompt for a token literal, any write-looking request, any unredacted customer or bank data beyond approved fixture identifiers, any HTTP 401 or 403 after one retry, any HTTP 5xx, or any output that cannot be safely shared.

### Allowed Command Categories

- Local preflight:
  - `straddle-pp-cli about --json`
  - `straddle-pp-cli setup check --json`
  - `straddle-pp-cli auth status --json`
  - `straddle-pp-cli doctor --json` only if the approved environment and credential source are already configured.
- Local planning and discovery:
  - `straddle-pp-cli smoke plan <scope> --json`
  - `straddle-pp-cli docs search <query> --source commands --json`
  - `straddle-pp-cli workflow plan <workflow> --json`
  - `straddle-pp-cli ops guide <workflow> --json`
- Read-only API inspection, only when the approver names the resource category:
  - list commands for approved resources such as customers, charges, payouts, paykeys, payments, funding events, reports, or webhooks.
  - read or get commands only for approved fixture IDs.
  - dry-run commands that do not call Straddle APIs.
- MCP runtime inspection:
  - JSON-RPC initialize and `tools/list` against a locally built or packaged `straddle-pp-mcp`.
  - No MCP tool execution unless the approval explicitly names the tool and confirms it is read-only.

### Disallowed Command Categories

- Any create, update, delete, cancel, retry, submit, resubmit, approve, reject, block, unblock, send, post, import, export, webhook delivery, payout creation, charge creation, paykey creation, customer mutation, credential write, package publish, tap push, npm publish, signing, notarization, or production command.
- Any command that places a token in argv.
- Any command that writes public docs, release artifacts, user config, MCP client config, or registry state.

### Expected Output Evidence

- Redacted command line with no token values.
- Base URL or environment label proving sandbox or approved non-production target.
- CLI version or commit identifier if available.
- Exit code.
- JSON output shape, with sensitive fields removed.
- Object count, empty-list proof, or specific approved fixture ID.
- For MCP `tools/list`, tool count and presence of expected read-only planning tools such as `smoke_plan`, `workflow_plan`, and `credentials_plan`.
- A short note saying whether observed behavior matched the expected result.

### Rollback And Stop Criteria

- Stop immediately if any command attempts a write, resolves to production unexpectedly, prints a token, returns unredacted sensitive data, or asks for token input outside the approved secure flow.
- Delete any temporary binaries and local transcripts that contain sensitive data.
- Rotate the token if it appears in stdout, stderr, shell history, logs, screenshots, issue comments, or PR comments.
- Do not continue to broader scope after a failure. File a follow-up issue or plan artifact with the redacted failure summary.

## Approval Options Summary

The launch owner can choose one of these paths:

1. Preview only, no public publish. Keep local preview approved, resolve live-smoke approval next.
2. Private external preview. Publish only approved GitHub archives under the `straddle-pp-cli` name, with unsigned or signed posture stated plainly, and with env/config-only credentials accepted by named owners.
3. Public preview. Publish approved archives and docs after signing, credential posture, support owner, live smoke, and MCP packaging wording are approved.
4. Broad public launch. Do not choose this yet. Current evidence does not support it.

## Next Slice Recommendation

Recommended next slice: get written approval for the narrow read-only live smoke, then run only `setup` plus one approved entity-list path in sandbox or another explicitly approved non-production environment.

If live smoke is not approved yet, the next best slice is owner review of this packet with explicit choices for command name, first release channel, credential posture, macOS signing, and desktop MCP packaging.
