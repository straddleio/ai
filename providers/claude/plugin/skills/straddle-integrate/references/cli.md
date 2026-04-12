# CLI Reference

## When to use

The Straddle CLI covers the full API surface from the terminal. Use it to:
- Verify setup and authentication
- Test operations before writing SDK code
- Inspect live resources and their current state
- Debug API issues with full request/response visibility

Every resource available through the SDKs is available through the CLI.

## Install

```bash
brew install straddleio/tools/straddle
```

Or with Go:

```bash
go install 'github.com/straddleio/straddle-cli/cmd/straddle@latest'
```

## Command structure

```
straddle [resource] <command> [flags...]
```

Resources: `bridge`, `charges`, `customers`, `funding-events`, `organizations`, `accounts`, `linked-bank-accounts`, `representatives`, `paykeys`, `payments`, `payouts`, `reports`

Use `--help` on any resource or command to see available subcommands and parameters:

```bash
straddle --help
straddle charges --help
straddle charges create --help
```

## Output formats

| Flag | Output | Use case |
|------|--------|----------|
| `--format json` | Structured JSON | Parsing, piping, agent consumption |
| `--format yaml` | YAML | Human-readable structured output |
| `--format pretty` | Colored terminal | Interactive use |
| `--format explore` | Interactive explorer | Navigating large responses |
| `--format raw` | Unprocessed API response | Debugging |

Default is `auto`: `pretty` for TTY, `json` for pipes.

## Data extraction

`--transform` uses GJSON syntax to extract fields from responses:

```bash
straddle customers list --format json --transform 'data.#.{id,name,status}'
straddle charges get ch_123 --transform 'data.status'
```

GJSON syntax: https://github.com/tidwall/gjson/blob/master/SYNTAX.md

## Debug

`--debug` shows the full HTTP request and response: headers, timing, and body. Use when troubleshooting authentication, environment targeting, or unexpected API behavior.

```bash
straddle charges get ch_123 --debug
```

## Authentication

Set `STRADDLE_API_KEY` as an environment variable or pass `--api-key` per command. Same keys as the SDKs -- sandbox keys hit sandbox, production keys hit production.

## Full reference

CLI docs: https://sdk.straddle.com/api/cli

Use `--help` on any command for parameter details.
