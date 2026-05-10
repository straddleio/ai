#!/usr/bin/env sh
set -eu

dist_dir="${1:-dist}"
template_dir="npm"
package_dir="$dist_dir/npm/package"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

copy_pair() {
    goos="$1"
    goarch="$2"
    node_platform="$3"
    node_arch="$4"
    exe_suffix="$5"
    vendor_dir="$package_dir/vendor/${node_platform}-${node_arch}"

    cli_source="$(find "$dist_dir" -maxdepth 2 -path "$dist_dir/straddle-pp-cli_${goos}_${goarch}_*/straddle-pp-cli${exe_suffix}" | head -n 1)"
    mcp_source="$(find "$dist_dir" -maxdepth 2 -path "$dist_dir/straddle-pp-mcp_${goos}_${goarch}_*/straddle-pp-mcp${exe_suffix}" | head -n 1)"
    test -n "$cli_source" || fail "missing GoReleaser CLI binary for ${goos}_${goarch}"
    test -n "$mcp_source" || fail "missing GoReleaser MCP binary for ${goos}_${goarch}"

    mkdir -p "$vendor_dir"
    cp "$cli_source" "$vendor_dir/straddle-pp-cli${exe_suffix}"
    cp "$mcp_source" "$vendor_dir/straddle-pp-mcp${exe_suffix}"
    chmod 755 "$vendor_dir/straddle-pp-cli${exe_suffix}" "$vendor_dir/straddle-pp-mcp${exe_suffix}"
}

test -d "$dist_dir" || fail "missing dist directory: $dist_dir"
test -f "$template_dir/package.json" || fail "missing npm package template"
test -f "$template_dir/bin/straddle-pp-cli.js" || fail "missing npm CLI launcher"
test -f "$template_dir/bin/straddle-pp-mcp.js" || fail "missing npm MCP launcher"
test -f "$template_dir/lib/resolve-binary.js" || fail "missing npm binary resolver"

rm -rf "$dist_dir/npm"
mkdir -p "$package_dir"
cp -R "$template_dir/." "$package_dir/"
cp LICENSE manifest.json .printing-press.json "$package_dir/"
chmod 755 "$package_dir/bin/straddle-pp-cli.js" "$package_dir/bin/straddle-pp-mcp.js"

copy_pair darwin amd64 darwin x64 ""
copy_pair darwin arm64 darwin arm64 ""
copy_pair linux amd64 linux x64 ""
copy_pair linux arm64 linux arm64 ""
copy_pair windows amd64 win32 x64 ".exe"
copy_pair windows arm64 win32 arm64 ".exe"

printf 'npm package ready: %s\n' "$package_dir"
