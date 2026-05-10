# @straddle/straddle-pp-cli

Preview npm wrapper for the Printing Press generated Straddle CLI and MCP sibling.

This package is assembled locally by `scripts/build-npm-package.sh` from GoReleaser snapshot binaries. It is not published, it does not download binaries at install time, it does not read secrets, and it does not approve the public npm package name or release channel.

The package exposes:

- `straddle-pp-cli`
- `straddle-pp-mcp`

Both launch the bundled native binary for the current platform from `vendor/<platform>-<arch>/`.
