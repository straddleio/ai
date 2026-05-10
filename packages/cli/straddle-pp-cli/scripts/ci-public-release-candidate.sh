#!/usr/bin/env sh
set -eu

# PATCH: public-release-candidate-workflow keeps public launch review executable without publishing.
# Non-publishing CI helper: writes the supplied approval JSON locally, validates
# it with the built CLI, and records review metadata. It never publishes,
# signs, notarizes, calls Straddle APIs, or reads secrets.

candidate_label="${CANDIDATE_LABEL:-}"
approval_json="${APPROVAL_JSON:-}"
approval_json_base64="${APPROVAL_JSON_BASE64:-}"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

test -n "$candidate_label" || fail "CANDIDATE_LABEL is required"

case "$candidate_label" in
    *[!A-Za-z0-9._-]*)
        fail "CANDIDATE_LABEL may only contain letters, numbers, dots, underscores, and hyphens"
        ;;
esac

case "$candidate_label" in
    ""|.*|-*|_*)
        fail "CANDIDATE_LABEL must start with a letter or number"
        ;;
esac

label_length="$(printf '%s' "$candidate_label" | wc -c | tr -d ' ')"
test "$label_length" -le 80 || fail "CANDIDATE_LABEL must be 80 characters or fewer"

if test -n "$approval_json" && test -n "$approval_json_base64"; then
    fail "provide only one of APPROVAL_JSON or APPROVAL_JSON_BASE64"
fi

if test -z "$approval_json" && test -z "$approval_json_base64"; then
    fail "APPROVAL_JSON or APPROVAL_JSON_BASE64 is required"
fi

goos="$(go env GOOS)"
goarch="$(go env GOARCH)"
exe_suffix=""
if test "$goos" = "windows"; then
    exe_suffix=".exe"
fi

cli_path="$(find dist -maxdepth 2 -path "dist/straddle-pp-cli_${goos}_${goarch}_*/straddle-pp-cli${exe_suffix}" | head -n 1)"
test -n "$cli_path" || fail "missing built CLI in dist for ${goos}_${goarch}"
test -x "$cli_path" || fail "built CLI is not executable: $cli_path"

review_dir="dist/review/$candidate_label"
approval_file="$review_dir/public-approval.json"
shipcheck_file="$review_dir/shipcheck-public.json"
metadata_file="$review_dir/release-candidate.json"
mkdir -p "$review_dir"

APPROVAL_JSON="$approval_json" APPROVAL_JSON_BASE64="$approval_json_base64" node - "$approval_file" <<'NODE'
const fs = require('node:fs');

const outputPath = process.argv[2];
const raw = process.env.APPROVAL_JSON || Buffer.from(process.env.APPROVAL_JSON_BASE64 || '', 'base64').toString('utf8');

let parsed;
try {
  parsed = JSON.parse(raw);
} catch (error) {
  console.error(`approval input must be valid JSON: ${error.message}`);
  process.exit(1);
}

if (!parsed || Array.isArray(parsed) || typeof parsed !== 'object') {
  console.error('approval input must be one JSON object');
  process.exit(1);
}

fs.writeFileSync(outputPath, `${JSON.stringify(parsed, null, 2)}\n`, { mode: 0o600 });
NODE

"$cli_path" shipcheck public --approval-file "$approval_file" --json >"$shipcheck_file"

node - "$shipcheck_file" <<'NODE'
const fs = require('node:fs');

const shipcheckPath = process.argv[2];
const result = JSON.parse(fs.readFileSync(shipcheckPath, 'utf8'));

if (result.ready !== true || result.local_preview_passed !== true) {
  console.error('shipcheck public approval did not mark the candidate ready');
  process.exit(1);
}
NODE

node - "$metadata_file" "$candidate_label" "$cli_path" "$approval_file" "$shipcheck_file" <<'NODE'
const fs = require('node:fs');

const [metadataPath, candidateLabel, cliPath, approvalFile, shipcheckFile] = process.argv.slice(2);
const payload = {
  candidate_label: candidateLabel,
  cli_path: cliPath,
  approval_file: approvalFile,
  shipcheck_public_json: shipcheckFile,
  non_publishing: true,
  blocked_actions: [
    'github_release',
    'npm_publish',
    'homebrew_publish',
    'sign',
    'notarize',
    'straddle_api_calls',
    'secret_access'
  ]
};

fs.writeFileSync(metadataPath, `${JSON.stringify(payload, null, 2)}\n`);
NODE

printf 'public release candidate reviewed locally: %s\n' "$review_dir"
