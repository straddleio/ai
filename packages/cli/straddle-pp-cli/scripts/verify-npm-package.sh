#!/usr/bin/env sh
set -eu

package_dir="${1:-dist/npm/package}"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

require_file() {
    test -f "$1" || fail "missing file: $1"
}

require_executable() {
    test -x "$1" || fail "missing executable: $1"
}

require_pair() {
    platform_arch="$1"
    suffix="$2"
    require_executable "$package_dir/vendor/$platform_arch/straddle-pp-cli$suffix"
    require_executable "$package_dir/vendor/$platform_arch/straddle-pp-mcp$suffix"
}

test -d "$package_dir" || fail "missing npm package directory: $package_dir"
require_file "$package_dir/package.json"
require_file "$package_dir/README.md"
require_file "$package_dir/LICENSE"
require_file "$package_dir/manifest.json"
require_file "$package_dir/.printing-press.json"
require_executable "$package_dir/bin/straddle-pp-cli.js"
require_executable "$package_dir/bin/straddle-pp-mcp.js"
require_file "$package_dir/lib/resolve-binary.js"

node -e 'const fs=require("fs"); const pkg=JSON.parse(fs.readFileSync(process.argv[1], "utf8")); if (pkg.private !== true) { process.exit(1); }' "$package_dir/package.json" || fail "npm package must be private"

require_pair darwin-x64 ""
require_pair darwin-arm64 ""
require_pair linux-x64 ""
require_pair linux-arm64 ""
require_pair win32-x64 ".exe"
require_pair win32-arm64 ".exe"

current_vendor="$(node -e 'const a={x64:"x64",arm64:"arm64"}[process.arch]; if(!a) process.exit(1); console.log(`${process.platform}-${a}`);')" || fail "unsupported current platform for npm smoke"
current_mcp="$package_dir/vendor/$current_vendor/straddle-pp-mcp"
case "$(uname -s)" in
    MINGW*_NT*|MSYS*_NT*|CYGWIN*_NT*)
        current_mcp="$current_mcp.exe"
        ;;
esac
require_executable "$current_mcp"

node "$package_dir/bin/straddle-pp-cli.js" --version >/dev/null
node "$package_dir/bin/straddle-pp-cli.js" shipcheck local --mcp-binary "$current_mcp" --json >/dev/null
sh scripts/verify-public-shipcheck.sh "$package_dir/bin/straddle-pp-cli.js"
node - "$package_dir/bin/straddle-pp-mcp.js" <<'NODE'
const { spawn } = require('child_process');

const command = process.argv[2];
const child = spawn(process.execPath, [command], { stdio: ['pipe', 'pipe', 'pipe'] });
let stdout = '';
let stderr = '';
let sawInitialize = false;
let sawTools = false;
let done = false;

const timer = setTimeout(() => finish(new Error('timed out waiting for MCP tools/list')), 5000);

function send(message) {
  child.stdin.write(`${JSON.stringify(message)}\n`);
}

function finish(error) {
  if (done) {
    return;
  }
  done = true;
  clearTimeout(timer);
  child.kill();
  if (error) {
    console.error(error.message);
    if (stderr.trim()) {
      console.error(stderr.trim());
    }
    process.exit(1);
  }
  process.exit(0);
}

child.stderr.on('data', (chunk) => {
  stderr += chunk;
});

child.stdout.on('data', (chunk) => {
  stdout += chunk;
  for (;;) {
    const index = stdout.indexOf('\n');
    if (index < 0) {
      break;
    }
    const line = stdout.slice(0, index).trim();
    stdout = stdout.slice(index + 1);
    if (!line) {
      continue;
    }
    let message;
    try {
      message = JSON.parse(line);
    } catch (error) {
      finish(new Error(`invalid MCP JSON: ${line}`));
      return;
    }
    if (message.id === 1) {
      sawInitialize = true;
      send({ jsonrpc: '2.0', method: 'notifications/initialized', params: {} });
      send({ jsonrpc: '2.0', id: 2, method: 'tools/list', params: {} });
    }
    if (message.id === 2) {
      sawTools = Array.isArray(message.result && message.result.tools);
      finish(sawInitialize && sawTools ? null : new Error('MCP tools/list did not return tools'));
      return;
    }
  }
});

child.on('error', finish);
child.on('exit', (code) => {
  if (!done) {
    finish(new Error(`MCP wrapper exited before tools/list with code ${code}`));
  }
});

send({
  jsonrpc: '2.0',
  id: 1,
  method: 'initialize',
  params: {
    protocolVersion: '2024-11-05',
    capabilities: {},
    clientInfo: { name: 'straddle-npm-package-smoke', version: '0' }
  }
});
NODE

if grep -R -I -E 'sk_(live|test)_[[:alnum:]_]*|NPM_TOKEN|npm login|npm publish' "$package_dir" >/dev/null; then
    fail "npm package contains token-shaped strings or publishing commands"
fi

pack_dir="$(mktemp -d)"
trap 'rm -rf "$pack_dir"' EXIT
npm_home="$pack_dir/home"
npm_cache="$pack_dir/cache"
npm_userconfig="$pack_dir/user.npmrc"
npm_globalconfig="$pack_dir/global.npmrc"
mkdir -p "$npm_home" "$npm_cache"
: >"$npm_userconfig"
: >"$npm_globalconfig"

npm_isolated() {
    HOME="$npm_home" \
    NPM_CONFIG_USERCONFIG="$npm_userconfig" \
    NPM_CONFIG_GLOBALCONFIG="$npm_globalconfig" \
    NPM_CONFIG_CACHE="$npm_cache" \
    NPM_CONFIG_OFFLINE=true \
    NPM_CONFIG_UPDATE_NOTIFIER=false \
    NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false \
    npm "$@"
}

(cd "$package_dir" && npm_isolated pack --dry-run >/dev/null)
tgz="$(cd "$package_dir" && npm_isolated pack --pack-destination "$pack_dir" --json | node -e 'let s=""; process.stdin.on("data", d=>s+=d); process.stdin.on("end",()=>{const p=JSON.parse(s)[0]; console.log(p.filename);});')"
npm_isolated exec --offline --package "$pack_dir/$tgz" -- straddle-pp-cli --version >/dev/null

printf 'npm package verified: %s\n' "$package_dir"
