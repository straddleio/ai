# Security Policy

## Reporting a Vulnerability

Email **security@straddle.com** with a description of the issue, steps to reproduce, and any relevant logs or screenshots.

- **48 hours** -- acknowledgment of your report
- **5 business days** -- status update with next steps

We offer credit in release notes and changelogs unless you prefer to remain anonymous.

## In Scope

- Plugin code (skills, commands, sync scripts)
- MCP server configuration (`.mcp.json`, `mcp.json`)
- Credential exposure risks (API keys, tokens in committed files)
- Skill content that could cause unsafe API operations

## Out of Scope

- **Straddle API vulnerabilities** -- report these separately at [docs.straddle.com](https://docs.straddle.com)
- **Third-party dependency vulnerabilities** -- this repo has no runtime dependencies, but report upstream issues to the relevant maintainer

## API Key Safety

This repo never stores API keys or secrets. If you find a key or credential committed anywhere in this repository, report it immediately to security@straddle.com.
