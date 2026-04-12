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
straddle [global flags] [resource] <command> [command flags...]
```

Use `--help` on any resource or command to see available subcommands and parameters:

```bash
straddle --help
straddle charges --help
straddle charges create --help
```

## Global flags

| Flag | Description |
|------|-------------|
| `--api-key` | API key for authorization. Also reads `$STRADDLE_API_KEY`. |
| `--environment` | Target environment: `sandbox` or `production`. |
| `--format` | Output format: `auto`, `explore`, `json`, `jsonl`, `pretty`, `raw`, `yaml`. Default `auto`. |
| `--format-error` | Output format for errors. Same options as `--format`. Default `auto`. |
| `--transform` | GJSON expression to extract/reshape response data. |
| `--transform-error` | GJSON expression for error responses. |
| `--debug` | Show full HTTP request/response (headers, timing, body). |
| `--base-url` | Override the API base URL. |

## Resources and subcommands

**Core payments:**
- `charges` -- create, update, cancel, get, hold, release, unmask
- `payouts` -- create, update, cancel, get, hold, release, unmask
- `payments` -- list (searches across both charges and payouts)
- `funding-events` -- get, list

**Customers and paykeys:**
- `customers` -- create, update, delete, get, list, unmasked
- `customers:review` -- decision, get, refresh-review
- `paykeys` -- cancel, get, list, reveal, unmasked, update-balance
- `paykeys:review` -- decision, get, refresh-review

**Bridge (bank account linking):**
- `bridge` -- initialize (generate a session token for the Bridge widget)
- `bridge:link` -- bank-account, create-paykey, create-tan, plaid

**Embed (platform/multi-account):**
- `embed:accounts` -- create, update, list, get, onboard, simulate
- `embed:accounts:capability-requests` -- create, list
- `embed:linked-bank-accounts` -- create, update, list, cancel, get, unmask
- `embed:organizations` -- create, get, list
- `embed:representatives` -- create, update, list, get, unmask

**Reporting:**
- `reports` -- create-total-customers-by-status

## Output formats

| Flag | Output | Use case |
|------|--------|----------|
| `--format json` | Structured JSON | Parsing, piping, agent consumption |
| `--format jsonl` | JSON Lines | Streaming, line-by-line processing |
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

## Common workflows

```bash
# Explore available subcommands for a resource
straddle charges --help

# Create a charge
straddle charges create --amount 10000 --currency USD --paykey pk_xxx ...

# Verify a resource by ID
straddle charges get <id> --format json

# Debug a failing request (full HTTP trace)
straddle charges get <id> --debug

# Extract specific fields from a list
straddle customers list --transform 'data.#.{id,name,status}'

# Switch to sandbox environment
straddle --environment sandbox customers list

# Reveal a masked paykey token
straddle paykeys reveal <id>

# Check a customer review status
straddle customers:review get <customer_id>
```

## Full reference

CLI docs: https://sdk.straddle.com/api/cli

Use `--help` on any command for parameter details.
