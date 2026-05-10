#!/usr/bin/env sh
set -eu

# PATCH: completion-audit verifies the objective-to-artifact proof against packaged CLI and MCP artifacts.
# This is local-only. It does not publish, push, upload, sign, notarize, call
# Straddle APIs, call docs endpoints, read secrets, or execute credential-bearing
# MCP tools.

dist_dir="${1:-dist}"
project_name="straddle-pp-cli"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

json_check() {
    node - "$@"
}

if test -n "$(git status --porcelain --untracked-files=no)"; then
    fail "completion audit requires a clean tracked worktree so approval validation can trust the built commit"
fi

goos="$(go env GOOS)"
goarch="$(go env GOARCH)"
exe_suffix=""
if test "$goos" = "windows"; then
    exe_suffix=".exe"
fi

cli_path="$(find "$dist_dir" -maxdepth 2 -path "$dist_dir/${project_name}_${goos}_${goarch}_*/straddle-pp-cli${exe_suffix}" | head -n 1)"
mcp_path="$(find "$dist_dir" -maxdepth 2 -path "$dist_dir/straddle-pp-mcp_${goos}_${goarch}_*/straddle-pp-mcp${exe_suffix}" | head -n 1)"
test -n "$cli_path" || fail "missing current-platform CLI in $dist_dir for ${goos}_${goarch}"
test -n "$mcp_path" || fail "missing current-platform MCP in $dist_dir for ${goos}_${goarch}"
test -x "$cli_path" || fail "CLI is not executable: $cli_path"
test -x "$mcp_path" || fail "MCP is not executable: $mcp_path"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

shipcheck_local="$tmp_dir/shipcheck-local.json"
benchmark_ramp="$tmp_dir/benchmark-ramp.json"
docs_search="$tmp_dir/docs-search-monitoring.json"
workflow_plan="$tmp_dir/workflow-plan-all.json"
approval_template="$tmp_dir/public-approval-template.json"
smoke_approval="$tmp_dir/smoke-mcp-approval.json"
smoke_transcript="$tmp_dir/smoke-mcp-transcript.json"
smoke_output="$tmp_dir/smoke-mcp-output.json"
public_shipcheck="$tmp_dir/shipcheck-public.json"

"$cli_path" shipcheck local --mcp-binary "$mcp_path" --json >"$shipcheck_local"
json_check "$shipcheck_local" <<'NODE'
const fs = require('node:fs');
const path = process.argv[2];
const payload = JSON.parse(fs.readFileSync(path, 'utf8'));
if (payload.passed !== true) {
  throw new Error('shipcheck local must pass');
}
const checks = new Map((payload.checks || []).map((check) => [check.name, check]));
for (const name of ['command_tree', 'objective_surfaces', 'workflow_plans', 'docs_command_search', 'provenance', 'safety', 'mcp_tools']) {
  const check = checks.get(name);
  if (!check || check.passed !== true) {
    throw new Error(`shipcheck local missing passing check ${name}`);
  }
}
const objectiveEvidence = (checks.get('objective_surfaces').evidence || []).join('\n');
for (const required of [
  'setup',
  'customers',
  'payments',
  'reconciliation',
  'fraud',
  'collections',
  'reporting',
  'monitoring',
  'sandbox',
  'docs search',
  'MCP',
  'Ramp benchmark',
  'presentation'
]) {
  if (!objectiveEvidence.toLowerCase().includes(required.toLowerCase())) {
    throw new Error(`objective surface evidence missing ${required}`);
  }
}
const provenanceEvidence = (checks.get('provenance').evidence || []).join('\n');
for (const required of [
  'generator repository: https://github.com/mvanhorn/cli-printing-press',
  'library repository: https://github.com/mvanhorn/printing-press-library'
]) {
  if (!provenanceEvidence.toLowerCase().includes(required.toLowerCase())) {
    throw new Error(`provenance evidence missing ${required}`);
  }
}
if (JSON.stringify(payload).match(/Bearer |STRADDLE_TOKEN=|sk_live|sk_test/i)) {
  throw new Error('shipcheck local leaked token-shaped text');
}
NODE

"$cli_path" benchmark ramp --json >"$benchmark_ramp"
json_check "$benchmark_ramp" <<'NODE'
const fs = require('node:fs');
const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const names = (payload.dimensions || []).map((dimension) => dimension.name);
for (const required of ['OpenAPI-generated command coverage', 'Agent-friendly output', 'MCP readiness', 'Documentation and discovery', 'Presentation polish', 'Operational workflows', 'Distribution readiness']) {
  if (!names.includes(required)) {
    throw new Error(`benchmark ramp missing dimension ${required}`);
  }
}
if (!payload.safety || payload.safety.uses_ramp_as_reference_only !== true || payload.safety.local_only !== true) {
  throw new Error('benchmark ramp must be local reference-only guidance');
}
if (JSON.stringify(payload).match(/Bearer |STRADDLE_TOKEN=|sk_live|sk_test/i)) {
  throw new Error('benchmark ramp leaked token-shaped text');
}
NODE

"$cli_path" docs search monitoring --source commands --json >"$docs_search"
json_check "$docs_search" <<'NODE'
const fs = require('node:fs');
const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (payload.source !== 'commands' || payload.makes_api_calls !== false || payload.requires_auth !== false) {
  throw new Error('docs search command-source audit must be local and unauthenticated');
}
const commands = (payload.results || []).map((result) => result.entry && result.entry.command).filter(Boolean);
for (const required of ['ops guide', 'workflow plan', 'tail']) {
  if (!commands.includes(required)) {
    throw new Error(`docs command search missing ${required}`);
  }
}
NODE

"$cli_path" workflow plan all --json >"$workflow_plan"
json_check "$workflow_plan" <<'NODE'
const fs = require('node:fs');
const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const workflows = (payload.workflow_plans || []).map((workflow) => workflow.name);
for (const required of ['reconciliation', 'fraud-monitoring', 'collections', 'reporting', 'monitoring']) {
  if (!workflows.includes(required)) {
    throw new Error(`workflow plan missing ${required}`);
  }
}
if (!payload.safety || payload.safety.local_only !== true || payload.safety.no_api_calls !== true || payload.safety.no_writes !== true) {
  throw new Error('workflow plan all must be local, read-first guidance');
}
NODE

cat >"$smoke_approval" <<JSON
{
  "approver": "Completion Audit",
  "environment": "local-test",
  "base_url": "http://127.0.0.1:9",
  "credential_source": "none",
  "allowed_scope": "mcp",
  "read_only": true,
  "transcript_path": "$smoke_transcript",
  "stop_criteria_acknowledged": true
}
JSON
"$cli_path" smoke run mcp --approval-file "$smoke_approval" --mcp-binary "$mcp_path" --json >"$smoke_output"
json_check "$smoke_output" "$smoke_transcript" <<'NODE'
const fs = require('node:fs');
const [outputPath, transcriptPath] = process.argv.slice(2);
const output = JSON.parse(fs.readFileSync(outputPath, 'utf8'));
const transcript = JSON.parse(fs.readFileSync(transcriptPath, 'utf8'));
for (const payload of [output, transcript]) {
  if (payload.scope !== 'mcp' || payload.approved !== true || payload.read_only !== true) {
    throw new Error('MCP smoke must be approved read-only mcp scope');
  }
  const tools = (payload.checks || []).find((check) => check.name === 'mcp_tools_list');
  if (!tools || tools.passed !== true || tools.method !== 'tools/list' || tools.tool_count < 10) {
    throw new Error('MCP smoke must prove tools/list returned tools');
  }
  if (JSON.stringify(payload).match(/Bearer |STRADDLE_TOKEN=|sk_live|sk_test/i)) {
    throw new Error('MCP smoke leaked token-shaped text');
  }
}
NODE

"$cli_path" shipcheck public --approval-template >"$approval_template"
json_check "$approval_template" <<'NODE'
const fs = require('node:fs');
const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (!/^[a-f0-9]{40}$/i.test(payload.local_preview_commit || '')) {
  throw new Error('approval template must include full current commit');
}
for (const required of ['owner_approval', 'public_distribution', 'docs_support', 'desktop_mcp', 'live_smoke', 'signing_notarization']) {
  if (payload[required] !== false) {
    throw new Error(`approval template must leave ${required} false`);
  }
  if (!payload.evidence || payload.evidence[required] !== '') {
    throw new Error(`approval template must include blank evidence.${required}`);
  }
}
if (JSON.stringify(payload).match(/Bearer |STRADDLE_TOKEN=|sk_live|sk_test/i)) {
  throw new Error('approval template leaked token-shaped text');
}
NODE

set +e
"$cli_path" shipcheck public --json >"$public_shipcheck" 2>"$tmp_dir/shipcheck-public.stderr"
public_status="$?"
set -e
test "$public_status" != "0" || fail "shipcheck public should fail until public approvals exist"
json_check "$public_shipcheck" <<'NODE'
const fs = require('node:fs');
const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (payload.ready !== false || payload.local_preview_passed !== true) {
  throw new Error('shipcheck public should block public launch while proving local preview passed');
}
const failed = (payload.checks || []).filter((check) => check.passed === false).map((check) => check.name);
for (const required of ['owner_approval', 'public_distribution', 'docs_support', 'desktop_mcp', 'live_smoke', 'signing_notarization']) {
  if (!failed.includes(required)) {
    throw new Error(`shipcheck public missing blocker ${required}`);
  }
}
NODE

approval_json="$(node - "$approval_template" <<'NODE'
const fs = require('node:fs');
const template = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
template.approver = 'Completion Audit';
template.approved_at = new Date(0).toISOString();
for (const name of ['owner_approval', 'public_distribution', 'docs_support', 'desktop_mcp', 'live_smoke', 'signing_notarization']) {
  template[name] = true;
  template.evidence[name] = `${name} completion audit evidence for ${template.local_preview_commit}`;
}
process.stdout.write(JSON.stringify(template));
NODE
)"
candidate_label="completion-audit-$(git rev-parse --short HEAD)"
APPROVAL_JSON="$approval_json" CANDIDATE_LABEL="$candidate_label" sh scripts/ci-public-release-candidate.sh >/dev/null
json_check "$dist_dir/review/$candidate_label/release-candidate.json" "$dist_dir/review/$candidate_label/shipcheck-public-redacted.json" <<'NODE'
const fs = require('node:fs');
const [metadataPath, redactedPath] = process.argv.slice(2);
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));
const redacted = JSON.parse(fs.readFileSync(redactedPath, 'utf8'));
if (metadata.raw_approval_file_uploaded !== false || metadata.raw_shipcheck_file_uploaded !== false) {
  throw new Error('release candidate metadata must prove raw approval data was not uploaded');
}
if (redacted.ready !== true || redacted.local_preview_passed !== true) {
  throw new Error('redacted release-candidate shipcheck must be ready');
}
if (JSON.stringify(redacted).match(/Completion Audit|completion audit evidence|Bearer |STRADDLE_TOKEN=|sk_live|sk_test/i)) {
  throw new Error('redacted release-candidate artifact leaked approval or token text');
}
NODE

printf 'completion audit ready: %s with %s and %s\n' "$dist_dir" "$cli_path" "$mcp_path"
