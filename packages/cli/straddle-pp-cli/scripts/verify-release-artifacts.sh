#!/usr/bin/env sh
set -eu

dist_dir="${1:-dist}"
project_name="straddle-pp-cli"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

require_file() {
    test -f "$1" || fail "missing required release artifact: $1"
}

require_listed() {
    list_file="$1"
    entry="$2"
    grep -Fx "$entry" "$list_file" >/dev/null || fail "$list_file missing $entry"
}

require_file "$dist_dir/checksums.txt"
require_file "$dist_dir/artifacts.json"
require_file "$dist_dir/metadata.json"
require_file "$dist_dir/homebrew/Casks/straddle-pp-cli.rb"

if command -v shasum >/dev/null 2>&1; then
    (cd "$dist_dir" && shasum -a 256 -c checksums.txt >/dev/null)
elif command -v sha256sum >/dev/null 2>&1; then
    (cd "$dist_dir" && sha256sum -c checksums.txt >/dev/null)
else
    fail "missing shasum or sha256sum for checksum verification"
fi

archive_count="$(find "$dist_dir" -maxdepth 1 \( -name "${project_name}_*.tar.gz" -o -name "${project_name}_*.zip" \) | wc -l | tr -d ' ')"
test "$archive_count" = "6" || fail "expected 6 release archives, found $archive_count"

for archive in "$dist_dir"/${project_name}_*.tar.gz; do
    list_file="$(mktemp)"
    tar -tzf "$archive" >"$list_file"
    require_listed "$list_file" "LICENSE"
    require_listed "$list_file" "README.md"
    require_listed "$list_file" ".printing-press.json"
    require_listed "$list_file" "manifest.json"
    require_listed "$list_file" "straddle-pp-cli"
    require_listed "$list_file" "straddle-pp-mcp"
    grep -F "$(basename "$archive")" "$dist_dir/checksums.txt" >/dev/null || fail "checksums.txt missing $(basename "$archive")"
    rm -f "$list_file"
done

for archive in "$dist_dir"/${project_name}_*.zip; do
    list_file="$(mktemp)"
    unzip -Z1 "$archive" >"$list_file"
    require_listed "$list_file" "LICENSE"
    require_listed "$list_file" "README.md"
    require_listed "$list_file" ".printing-press.json"
    require_listed "$list_file" "manifest.json"
    require_listed "$list_file" "straddle-pp-cli.exe"
    require_listed "$list_file" "straddle-pp-mcp.exe"
    grep -F "$(basename "$archive")" "$dist_dir/checksums.txt" >/dev/null || fail "checksums.txt missing $(basename "$archive")"
    rm -f "$list_file"
done

grep -F 'binary "straddle-pp-cli"' "$dist_dir/homebrew/Casks/straddle-pp-cli.rb" >/dev/null || fail "Homebrew cask missing straddle-pp-cli binary"
grep -F 'binary "straddle-pp-mcp"' "$dist_dir/homebrew/Casks/straddle-pp-cli.rb" >/dev/null || fail "Homebrew cask missing straddle-pp-mcp binary"

goos="$(go env GOOS)"
goarch="$(go env GOARCH)"
case "$goos" in
    darwin|linux)
        platform_archive="$(find "$dist_dir" -maxdepth 1 -name "${project_name}_*_${goos}_${goarch}.tar.gz" | head -n 1)"
        test -n "$platform_archive" || fail "missing current-platform archive for ${goos}_${goarch}"
        extract_dir="$(mktemp -d)"
        tar -xzf "$platform_archive" -C "$extract_dir"
        chmod +x "$extract_dir/straddle-pp-cli" "$extract_dir/straddle-pp-mcp"
        "$extract_dir/straddle-pp-cli" shipcheck local --mcp-binary "$extract_dir/straddle-pp-mcp" --json >/dev/null
        "$extract_dir/straddle-pp-cli" mcp bundle --mcp-binary "$extract_dir/straddle-pp-mcp" --output "$extract_dir/mcp-bundle" --json >/dev/null
        rm -rf "$extract_dir"
        ;;
    *)
        printf 'skipping executable archive smoke for %s_%s\n' "$goos" "$goarch"
        ;;
esac

printf 'release artifacts ready: %s\n' "$dist_dir"
