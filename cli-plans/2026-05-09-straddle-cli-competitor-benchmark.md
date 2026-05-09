# Straddle CLI Competitor Benchmark

## Scope

This artifact expands the Phase 1 Research Brief and Phase 1.5 Ecosystem Absorb Gate for the Straddle Printing Press CLI workflow.

This is benchmark research only. Ramp, Stripe, GitHub, Cloudflare, Vercel, Shopify, Supabase, Brex, Finch, Kiro, and LangChain Deep Agents are competitor or ecosystem references only. Printing Press remains the architecture for the Straddle CLI and generated MCP surface.

No implementation code was changed. No `providers/*` synced copies were edited.

## Research Method

Firecrawl search was used first for each current or unknown source. Firecrawl scrape was then used for official docs pages, official GitHub repos, and official product pages where needed. Random blog posts were not used as core evidence. Finch was included through an official company blog post because the useful public surface is MCP and API docs, not a CLI.

Saved web outputs live under `.firecrawl/`.

## Source Table

<table>
<thead>
<tr><th>Product</th><th>URL or Path</th><th>What Was Inspected</th><th>Why It Matters</th></tr>
</thead>
<tbody>
<tr><td>Ramp</td><td>https://agents.ramp.com/</td><td>Agent landing page and CLI install presentation.</td><td>Best visible benchmark for agent-first CLI positioning, human and agent output modes, and launch polish.</td></tr>
<tr><td>Ramp</td><td>https://docs.ramp.com/developer-api/v1/developer-mcp</td><td>Developer MCP docs, tools, search, schema lookup, resolve, read, list, root, feedback, and workflow guidance.</td><td>Strong benchmark for separating API docs search from transactional API operations.</td></tr>
<tr><td>Ramp</td><td>https://docs.ramp.com/developer-api/v1/mcp</td><td>Ramp MCP docs and integration framing.</td><td>Useful benchmark for connecting financial workflows to agent clients while keeping docs current.</td></tr>
<tr><td>Ramp</td><td>https://github.com/ramp-public/ramp-cli</td><td>Official CLI repository surface.</td><td>Repository presence confirms CLI as a public developer surface, but it is still benchmark only.</td></tr>
<tr><td>Stripe</td><td>https://docs.stripe.com/stripe-cli</td><td>Stripe CLI overview, install, login, listen, trigger, logs, samples, fixtures, and autocomplete links.</td><td>Best fintech benchmark for webhook tooling, event triggers, and docs ergonomics.</td></tr>
<tr><td>Stripe</td><td>https://docs.stripe.com/cli</td><td>Stripe CLI command reference.</td><td>Shows reference-first command docs and broad resource coverage.</td></tr>
<tr><td>Stripe</td><td>https://docs.stripe.com/cli/listen</td><td>Webhook listener docs.</td><td>Relevant to future Straddle webhook testing, but only after sandbox safety is explicit.</td></tr>
<tr><td>Stripe</td><td>https://github.com/stripe/stripe-cli</td><td>Official CLI repository.</td><td>Confirms hand-maintained CLI with public source and release conventions.</td></tr>
<tr><td>GitHub CLI</td><td>https://cli.github.com/manual/</td><td>Manual, command grammar, flags, and references.</td><td>Benchmark for discoverable grammar and stable terminal conventions.</td></tr>
<tr><td>GitHub CLI</td><td>https://docs.github.com/en/github-cli/github-cli/quickstart</td><td>Install, `gh auth login`, repo-sensitive defaults, aliases, extensions, and account switching.</td><td>Useful for Straddle profile, auth, and extension expectations.</td></tr>
<tr><td>GitHub CLI</td><td>https://github.com/cli/cli</td><td>Official CLI repository.</td><td>Benchmark for mature open-source CLI governance and extensibility.</td></tr>
<tr><td>Cloudflare Wrangler</td><td>https://developers.cloudflare.com/workers/wrangler/</td><td>Wrangler overview and core command set.</td><td>Benchmark for local dev, deployment, remote service binding, and configuration clarity.</td></tr>
<tr><td>Cloudflare Wrangler</td><td>https://developers.cloudflare.com/workers/wrangler/commands/</td><td>Command reference.</td><td>Shows a large command tree organized around runtime tasks.</td></tr>
<tr><td>Cloudflare Wrangler</td><td>https://developers.cloudflare.com/workers/wrangler/configuration/</td><td>Config file behavior.</td><td>Useful for Straddle profile and environment file design.</td></tr>
<tr><td>Cloudflare Wrangler</td><td>https://github.com/cloudflare/workers-sdk</td><td>Official workers SDK and Wrangler repo.</td><td>Benchmark for CLI plus SDK repo organization.</td></tr>
<tr><td>Vercel</td><td>https://vercel.com/docs/cli</td><td>Vercel CLI docs, commands, login, link, deploy, env, inspect, logs, promote, and rollback.</td><td>Benchmark for project linking, environment handling, and operational status commands.</td></tr>
<tr><td>Vercel</td><td>https://vercel.com/docs/project-configuration/global-configuration</td><td>Global configuration docs.</td><td>Relevant to Straddle CLI config file expectations.</td></tr>
<tr><td>Vercel</td><td>https://vercel.com/docs/agent-resources/workflows</td><td>Agent workflow docs.</td><td>Useful agent-facing benchmark, but it should not replace the Straddle MCP architecture.</td></tr>
<tr><td>Vercel</td><td>https://github.com/vercel/vercel</td><td>Official CLI repository.</td><td>Benchmark for polished deploy CLI packaging.</td></tr>
<tr><td>Shopify</td><td>https://shopify.dev/docs/api/shopify-cli</td><td>CLI command docs and developer workflow.</td><td>Benchmark for app scaffolding, extension workflows, and docs structure.</td></tr>
<tr><td>Shopify</td><td>https://shopify.dev/docs/apps/build/cli-for-apps</td><td>CLI for apps docs.</td><td>Useful for command grammar around guided app workflows.</td></tr>
<tr><td>Shopify</td><td>https://github.com/Shopify/cli</td><td>Official CLI repository.</td><td>Benchmark for large product CLI with app-specific workflows.</td></tr>
<tr><td>Supabase</td><td>https://supabase.com/docs/guides/local-development/cli/getting-started</td><td>Getting started, login, init, start, and local stack flow.</td><td>Best benchmark for local development ergonomics and first-run setup.</td></tr>
<tr><td>Supabase</td><td>https://supabase.com/docs/reference/cli/introduction</td><td>CLI reference, `--output`, `--profile`, login token, local status, migrations, functions, secrets, and type generation.</td><td>Strong benchmark for profiles, machine output, local status, and generated type workflows.</td></tr>
<tr><td>Supabase</td><td>https://supabase.com/docs/guides/cli/config</td><td>CLI config docs.</td><td>Useful for project-local configuration expectations.</td></tr>
<tr><td>Supabase</td><td>https://github.com/supabase/cli</td><td>Official CLI repository.</td><td>Benchmark for local runtime and platform automation in one CLI.</td></tr>
<tr><td>Brex</td><td>https://www.brex.com/journal/brex-mcp-connect-brex-to-ai-tools</td><td>Official MCP product article.</td><td>Useful public MCP pattern for finance data access and agent clients. No useful public CLI surface was found.</td></tr>
<tr><td>Brex</td><td>https://developer.brex.com/</td><td>API developer docs.</td><td>Useful for finance API docs structure, not CLI architecture.</td></tr>
<tr><td>Brex</td><td>https://www.brex.com/product/api</td><td>API product page.</td><td>Useful for finance developer positioning. It does not prove a public CLI.</td></tr>
<tr><td>Finch</td><td>https://www.tryfinch.com/blog/finch-mcp-server</td><td>Official Finch MCP article.</td><td>Useful MCP and consent framing. It is weaker than docs, but it is an official Finch source.</td></tr>
<tr><td>Finch</td><td>https://developer.tryfinch.com/how-finch-works/quickstart</td><td>API quickstart docs.</td><td>Useful for API onboarding and consent model. No useful public CLI surface was found.</td></tr>
<tr><td>Kiro</td><td>https://kiro.dev/docs/cli/mcp/</td><td>CLI and MCP docs.</td><td>Additional cutting-edge benchmark for agent tool integration discovered through Firecrawl search.</td></tr>
<tr><td>LangChain Deep Agents</td><td>https://docs.langchain.com/oss/python/deepagents/cli/mcp-tools</td><td>CLI MCP tools docs.</td><td>Additional cutting-edge benchmark for composing MCP tools into agent workflows.</td></tr>
<tr><td>Straddle</td><td>cli-plans/2026-05-09-straddle-cli-phase-0-1-research.md</td><td>Existing Phase 0 and Phase 1 research.</td><td>Defines Straddle source, scope, Printing Press foundation, token requirements, launch blockers, and non-goals.</td></tr>
<tr><td>Straddle</td><td>cli-plans/2026-05-09-straddle-cli-ecosystem-absorb.md</td><td>Existing Phase 1.5 ecosystem absorb gate.</td><td>Defines local skills, MCP configs, slash commands, generated CLI roots, generated MCP surface, and validation helpers.</td></tr>
</tbody>
</table>

## Feature Catalog

### Install

Ramp leads with a single visible installer command and agent-first positioning. Stripe, GitHub CLI, Wrangler, Vercel, Shopify, and Supabase all give direct install paths and then immediately move users into auth or project setup. Straddle should keep Printing Press generation as the implementation foundation, but its public-facing install experience should be explicit about whether the binary is a preview `straddle-pp-cli` or the eventual `straddle` command.

### Auth

GitHub CLI and Stripe make login a first-class command. Supabase supports browser login and token-based CI use. Vercel and Cloudflare separate login from project operations. Ramp and Brex show finance-sensitive agent access needs clear auth boundaries. Straddle should adopt safe token entry now and avoid argv token paths. `STRADDLE_TOKEN`, config-file auth, login status, logout, and MCP token wiring need one plain explanation.

### Profiles And Environments

Supabase exposes `--profile`, config files, and status output. GitHub supports multiple authenticated accounts and account switching. Vercel and Cloudflare are strong examples for project links and environment-specific config. Straddle needs explicit sandbox and production profile behavior because the current generated CLI already defaults to sandbox and because production write calls are not acceptable as casual smoke tests.

### Output Modes

Ramp shows the strongest split between human output and agent JSON. Supabase and GitHub CLI show mature machine-output flags. Stripe focuses more on interactive developer flows and logs. Straddle should adopt a stable `--agent` output contract now, but only for claims the generated CLI can actually satisfy. Human output can be concise, but agent output needs predictable keys, exit status, warnings, and next actions.

### Agent And MCP

Ramp Developer MCP is the best benchmark for docs-specific tools: search, schema lookup, resolve, read, list, root, and feedback. Brex and Finch are useful finance-sector evidence that MCP is becoming a public integration surface, but neither should be treated as a CLI benchmark. Kiro and LangChain Deep Agents are useful for agent workflow composition. Straddle already has generated MCP from Printing Press and hosted MCP configs in provider manifests. The right move is to document and smoke-test those two surfaces, not invent a second MCP command tree.

### Docs Search

Ramp separates developer docs search from transactional API operations. Straddle currently has product docs skills and generated CLI local `search`, but those are not the same thing. Straddle should create or document a docs-specific search surface later, for example `straddle docs search <query>`, and keep it separate from local data search and API search.

### Command Grammar

GitHub CLI has the clearest noun-first grammar for repo work. Stripe has strong event and webhook verbs. Supabase has platform and local stack commands that are easy to predict. Wrangler and Vercel are strong for operational verbs like dev, deploy, logs, inspect, and rollback. Straddle should keep generated OpenAPI endpoint commands, then add a thin layer for workflow commands only where it reduces real confusion, such as auth, doctor, profile, docs, sandbox guide, and MCP doctor.

### Local Dev And Webhook Tools

Stripe is the fintech benchmark for `listen` and `trigger` style webhook workflows. Supabase and Wrangler are better references for local stack and local runtime flows. Straddle should not copy Stripe webhook triggers blindly. Adopt webhook listener and trigger workflows only after sandbox-only behavior, endpoint safety, and event provenance are clear.

### Generated Versus Hand Authored Surfaces

Printing Press must remain the architecture for Straddle CLI and MCP. Stripe, GitHub CLI, Vercel, Shopify, Supabase, and Wrangler are mostly hand-authored product CLIs or platform CLIs. They are valuable benchmarks for experience, not code shape. Ramp is the closest competitor benchmark for agent and MCP presentation, but it is still benchmark only. Straddle should keep generated endpoint breadth and add hand-authored wrappers only for auth, docs, profile, doctor, sandbox guidance, and product workflows that cannot be expressed clearly by raw endpoint commands.

### Visual Presentation And Word Art

Ramp uses strong terminal-style presentation and memorable product framing. That polish helps a CLI feel first-class, but it should not come before correctness. Straddle should adopt a restrained first-run screen and command-map presentation only after auth, output, docs, and safety behavior are proven. Avoid decorative word art that hides status, warnings, or environment.

## Fintech Specific Requirements

These are not general CLI niceties. They matter because Straddle handles payment infrastructure.

1. Sandbox and production must be visibly separated in commands, profiles, docs, examples, and smoke tests.
2. Token handling must avoid argv exposure and must explain environment variable, profile, config file, and MCP token behavior.
3. Agent JSON must include warnings and safety context, especially for write operations.
4. Webhook tools must be sandbox-first and must not imply production event replay without explicit approval.
5. Status explanation must come from current docs or explicit local references, not stale hardcoded lists.
6. MCP tools need a clear destructive-operation posture and a way to inspect available tools.
7. Docs search must distinguish product docs, API reference, SDK docs, and local generated command help.
8. Smoke tests should default to help, dry-run, local build, MCP launch, and sandbox-safe read-only flows.

## General Developer CLI Expectations

These expectations are broadly visible across Stripe, GitHub CLI, Wrangler, Vercel, Shopify, and Supabase.

1. Install is easy to find and the first successful command is obvious.
2. Login, logout, status, and account switching are first-class commands.
3. Config is inspectable and environment selection is not hidden.
4. JSON output exists for automation and human output stays readable.
5. Help text, examples, and command references match the real command tree.
6. Local development and logs are easy to start, stop, inspect, and debug.
7. Command grammar is predictable, usually noun first with verb subcommands.
8. Repo or project context can be inferred, but users can override it explicitly.
9. Autocomplete and shell-friendly behavior are expected for mature CLIs.
10. Docs and command references are searchable without forcing users into browser-only workflows.

## Absorb Manifest For Straddle CLI

### adopt now

<table>
<thead>
<tr><th>Item</th><th>Reason</th></tr>
</thead>
<tbody>
<tr><td>Keep Printing Press as the CLI and MCP foundation.</td><td>The existing workflow requires generated Go CLI and generated MCP from the Straddle OpenAPI source.</td></tr>
<tr><td>Add or document safe token input.</td><td>Current argv token handling is not acceptable for a fintech CLI.</td></tr>
<tr><td>Make `auth status`, token source, profile, and environment visible.</td><td>Users and agents need to know whether they are pointed at sandbox or production.</td></tr>
<tr><td>Stabilize `--agent` JSON for launch claims.</td><td>Ramp proves the value of agent output, but Straddle must only promise what it can verify.</td></tr>
<tr><td>Keep human and machine output separate.</td><td>Human output should be readable. Agent output should be parseable and boring.</td></tr>
<tr><td>Document generated MCP launch and token config.</td><td>The repo already has generated MCP and hosted provider MCP configs. Users need to understand the difference.</td></tr>
<tr><td>Add first-run doctor coverage to docs.</td><td>GitHub CLI, Supabase, Vercel, and Wrangler all make setup health easy to reason about.</td></tr>
<tr><td>Keep docs search separate from local data search.</td><td>Ramp Developer MCP shows this distinction clearly, and Straddle already has overlapping search surfaces.</td></tr>
</tbody>
</table>

### adopt later

<table>
<thead>
<tr><th>Item</th><th>Reason</th></tr>
</thead>
<tbody>
<tr><td>`straddle docs search <query>`.</td><td>Useful after the docs source contract is explicit and testable.</td></tr>
<tr><td>`straddle mcp doctor`.</td><td>Useful after generated MCP smoke checks are scripted or documented.</td></tr>
<tr><td>`straddle sandbox guide <scenario>`.</td><td>Useful as a help-only command before live sandbox writes exist.</td></tr>
<tr><td>`straddle webhooks listen --forward-to <url> --sandbox`.</td><td>Stripe proves the workflow, but Straddle must add sandbox and provenance guards first.</td></tr>
<tr><td>`straddle commands map --format json`.</td><td>Useful for agents and docs generation once command categories are reviewed.</td></tr>
<tr><td>Autocomplete and shell integration polish.</td><td>Expected for mature CLIs, but lower priority than auth, safety, output, and docs clarity.</td></tr>
<tr><td>Restrained first-run terminal presentation.</td><td>Ramp proves polish matters, but it should follow verified status and safety behavior.</td></tr>
<tr><td>MCP tool filtering and allowlist docs.</td><td>Relevant once generated MCP and hosted MCP surfaces are explained side by side.</td></tr>
</tbody>
</table>

### reject

<table>
<thead>
<tr><th>Item</th><th>Reason</th></tr>
</thead>
<tbody>
<tr><td>Using Ramp as architecture.</td><td>Ramp is benchmark only. Printing Press remains Straddle architecture.</td></tr>
<tr><td>Copying Stripe webhook trigger behavior without sandbox gates.</td><td>Payment events and production behavior need Straddle-specific safety rules.</td></tr>
<tr><td>Hand-building a second endpoint command tree.</td><td>The generated command tree is the source for CLI and MCP breadth.</td></tr>
<tr><td>Hidden environment or profile state.</td><td>Fintech operations need visible sandbox and production context.</td></tr>
<tr><td>One broad `search` command that mixes docs, local data, API resources, and SDK docs.</td><td>Overloaded search makes agent behavior harder to trust.</td></tr>
<tr><td>Decorative terminal word art before status and warnings.</td><td>Presentation should not hide auth state, environment, failures, or next steps.</td></tr>
<tr><td>Treating Brex or Finch as CLI benchmarks.</td><td>No useful public CLI surface was found. They are MCP and API docs references only.</td></tr>
<tr><td>Production write smoke tests.</td><td>Out of scope and unsafe for this workflow.</td></tr>
</tbody>
</table>

## Novel Suggestions For Straddle

1. `straddle doctor --agent`
   Return machine-readable setup health, detected binary path, spec checksum, auth source, profile, base URL, MCP binary status, and warnings.

2. `straddle auth token --stdin`
   Provide a safe token entry path. Keep `STRADDLE_TOKEN` support for CI and MCP.

3. `straddle profile use sandbox` and `straddle profile show`
   Make sandbox selection obvious and inspectable before any live call.

4. `straddle env explain`
   Print the resolved base URL, token source, profile source, and whether the command would call sandbox or production.

5. `straddle docs search <query> --source product|api|sdk`
   Separate docs search from local generated command search.

6. `straddle webhooks listen --forward-to <url> --sandbox`
   Only after sandbox rules are defined. Stripe proves the workflow is valuable, but Straddle needs stricter defaults.

7. `straddle scenario payment-lifecycle --dry-run`
   Explain customer, linked bank account, Paykey, charge, payout, and funding event flow without creating resources.

8. `straddle commands map --format json`
   Export command inventory for agents and docs generation, including generated endpoint commands versus hand-authored workflow commands.

9. `straddle mcp doctor`
   Start or inspect the generated MCP binary, list tool counts, confirm token mapping, and show whether hosted MCP docs are separate.

10. `straddle explain status <entity> <status>`
    Provide status help only when backed by current docs or explicit local references.

11. `straddle first-run`
    A restrained setup command that checks install, auth, sandbox profile, docs search availability, and MCP readiness.

## Candidate Verdicts

Ramp: strongest agent-first benchmark. Adopt presentation discipline, human versus agent output separation, and docs MCP ideas. Do not adopt architecture.

Stripe: strongest fintech CLI benchmark for webhooks, event triggers, logs, samples, and docs ergonomics. Adopt later only after sandbox-specific safeguards.

GitHub CLI: best command grammar and account switching benchmark. Adopt auth status, repo or project context clarity, aliases or extensions only later.

Cloudflare Wrangler: strong for local dev, deploy, logs, configuration, and runtime status. Useful for config and operational grammar.

Vercel CLI: strong for project linking, environments, deployment inspection, logs, rollback, and promote flows. Useful for Straddle profile and environment explanations.

Shopify CLI: useful for app workflow grammar and scaffolding style. Less directly relevant to a payment API CLI.

Supabase CLI: strongest general benchmark for local development stack, profiles, machine output, config, secrets, status, and generated types.

Brex: useful public finance MCP and API-docs reference. No useful public CLI surface found.

Finch: useful public MCP, consent, and API-onboarding reference. No useful public CLI surface found.

Kiro: useful newer CLI plus MCP integration benchmark. Treat as agent-tooling reference only.

LangChain Deep Agents: useful newer MCP tool composition reference. Treat as agent workflow reference only.

## Changes To Existing Phase Guidance

Phase 1 Research Brief should expand competitor scope beyond Ramp. Ramp stays a benchmark, but Stripe, GitHub CLI, Wrangler, Vercel, Shopify, Supabase, Brex, Finch, Kiro, and LangChain Deep Agents provide clearer coverage for webhook tooling, auth, profiles, local dev, docs search, MCP, and agent workflows.

Phase 1.5 Ecosystem Absorb Gate should keep local Straddle sources as the implementation baseline. Existing generated CLI roots, generated MCP, hosted provider MCP configs, canonical skills, slash commands, and validation scripts matter more than external examples when choosing actual work.

Printing Press remains architecture. External CLIs define experience targets, not implementation ownership.

## Concerns

Brex and Finch do not appear to have a useful public CLI surface from the Firecrawl searches and scrapes. They are included only for public MCP, API docs, consent, and finance-developer positioning.

Stripe webhook commands are valuable but risky to copy without Straddle-specific sandbox and event provenance rules.

Ramp polish is tempting, but it should not distract from Straddle launch blockers: safe token entry, environment clarity, agent JSON truthfulness, generated MCP smoke proof, and docs-source separation.
