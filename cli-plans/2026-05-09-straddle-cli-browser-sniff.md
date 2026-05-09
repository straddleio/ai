# Straddle CLI Browser Sniff

## Purpose

This note records Phase 1.7 evidence for final phase-artifact review in the Straddle Printing Press CLI workflow. It records a narrow browser and docs sniff only. No Straddle API calls were made beyond retrieving public docs.

## Target List

1. `https://docs.straddle.com/api-reference/openapi.json`
   - Why it matters: this is the public OpenAPI source used by Printing Press. The CLI plan depends on the docs URL staying reachable and identifying the API as Straddle API.

2. `https://agents.ramp.com/`
   - Why it matters: Ramp is a benchmark for agent-facing CLI ergonomics. It is useful for output modes, docs posture, and MCP positioning, but not for Straddle architecture.

3. `/Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md`
   - Why it matters: this is the local generated README that later CLI work will improve or use as evidence. It should reflect the generated Straddle API baseline without exposing Postman environment details.

## Discovery Provenance

Date and time: `2026-05-09 02:12:38 MDT`

### Straddle OpenAPI Docs

- Tool: `chrome-devtools-axi`
- Command: `chrome-devtools-axi open https://docs.straddle.com/api-reference/openapi.json`
- Target: `https://docs.straddle.com/api-reference/openapi.json`
- Observed result: browser opened the JSON document. The visible DOM begins with `openapi: 3.1.0`, `title: Straddle API`, and `version: v1`.
- Tool: `curl` plus local JSON parse
- Command: `curl -L -sS -o /tmp/straddle-openapi-sniff.json -w '%{http_code} %{content_type} %{size_download} %{url_effective}\n' https://docs.straddle.com/api-reference/openapi.json`
- Observed result: `200 application/octet-stream, application/json 863009 https://docs.straddle.com/api-reference/openapi.json`
- Parsed result: `3.1.0 | Straddle API | v1 | 55`

### Ramp Agents Page

- Tool: `chrome-devtools-axi`
- Command: `chrome-devtools-axi open https://agents.ramp.com/`
- Target: `https://agents.ramp.com/`
- Observed result: page loaded with title `Ramp - Your agent's finance operations` and heading `Ramp for Agents`.
- Visible CLI evidence: page exposes `CLI` and `MCP` tabs, a copy button, a docs link to `https://github.com/ramp-public/ramp-cli`, and an interactive terminal area.
- Visible ergonomics evidence: page contrasts `--agent` structured JSON output with `--human` table output, and highlights built-in task workflows such as approval review, receipt compliance, transaction cleanup, and agentic purchase.
- Network status: `chrome-devtools-axi network` showed `GET https://agents.ramp.com/ [200]` and loaded static assets. No authentication was needed.

### Local Generated README

- Tool: `chrome-devtools-axi`
- Command: `chrome-devtools-axi open file:///Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md`
- Target: `file:///Users/js/clawd/straddle/straddle-ai/packages/cli/straddle-pp-cli/README.md`
- Observed result: browser opened the local README as text. It starts with `# Straddle CLI` and `Postman environment details omitted from generated CLI artifacts.`
- Tool: `rg`
- Command: `rg -n '^# Straddle CLI|Postman environment details omitted|Sandbox|Production|Authentication|Bearer|Idempotency|Straddle-Account-Id' packages/cli/straddle-pp-cli/README.md`
- Observed result: local README includes sandbox and production base URLs, Bearer Token authentication, idempotency guidance, and embedded account header guidance.

## Browser and HAR Status

- Browser status: captured through `chrome-devtools-axi` DOM snapshots for all three targets.
- HAR status: fallback. A full HAR was not captured because the Phase 1.7 timebox called for a narrow sniff and the useful evidence was visible in DOM snapshots, the Ramp network list, and the OpenAPI HTTP status check.
- Blockers: none for page access. The only skipped item was full HAR export.

## What This Means For The CLI Plan

1. The docs source is reachable and still identifies as `Straddle API` `v1` with OpenAPI `3.1.0`. The CLI plan can continue treating `https://docs.straddle.com/api-reference/openapi.json` as the public source for generated CLI and MCP work.

2. Ramp should influence output ergonomics, not architecture. The relevant observed behavior is simple: provide a machine-readable mode and a human-readable mode, make command examples easy to copy, and keep task workflows visible.

3. The generated README is already based on the Straddle public docs and includes the important integration concepts for CLI users: environments, Bearer Token auth, idempotency, response shape, and embedded account headers.

4. The README already says Postman environment details were omitted. Future CLI plan work should preserve that boundary and avoid importing encoded Postman environment data into generated artifacts.

5. Phase 1.7 does not require implementation code changes. It only adds browser-derived evidence and provenance for later reviewers.
