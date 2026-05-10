#!/usr/bin/env sh
set -eu

cli="${1:?usage: verify-public-shipcheck.sh <straddle-pp-cli>}"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

test -x "$cli" || fail "missing executable CLI: $cli"

stdout_file="$(mktemp)"
stderr_file="$(mktemp)"
trap 'rm -f "$stdout_file" "$stderr_file"' EXIT

set +e
"$cli" shipcheck public --json >"$stdout_file" 2>"$stderr_file"
status="$?"
set -e

test "$status" != "0" || fail "shipcheck public should fail until public launch approvals are recorded"
grep -F "owner_approval" "$stderr_file" >/dev/null || fail "shipcheck public stderr should name owner_approval"

node - "$stdout_file" <<'NODE'
const fs = require('fs');

const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (payload.command !== 'shipcheck public') {
  throw new Error(`unexpected command: ${payload.command}`);
}
if (payload.ready !== false) {
  throw new Error('shipcheck public should keep ready=false until approvals are recorded');
}
if (payload.local_preview_passed !== true || !payload.local_preview || payload.local_preview.passed !== true) {
  throw new Error('shipcheck public should prove the local preview passed');
}

const checks = new Map((payload.checks || []).map((check) => [check.name, check]));
for (const name of ['owner_approval', 'public_distribution', 'docs_support', 'desktop_mcp', 'live_smoke', 'signing_notarization']) {
  const check = checks.get(name);
  if (!check) {
    throw new Error(`missing public blocker: ${name}`);
  }
  if (check.passed !== false) {
    throw new Error(`public blocker ${name} should fail until approval exists`);
  }
}
NODE

printf 'public shipcheck blocker verified: %s\n' "$cli"
