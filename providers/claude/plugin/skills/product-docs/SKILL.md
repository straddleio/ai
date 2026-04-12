---
name: product-docs
description: >-
  This skill should be used when the user asks to "search product docs",
  "find a guide", "look up sandbox testing", "check compliance rules",
  "find payment lifecycle docs", "search Straddle guides", or needs
  product documentation rather than SDK/API reference. For SDK method
  signatures, parameters, and code examples, use the search_docs MCP
  tool directly instead.
---

## What this searches

Straddle product documentation at docs.straddle.com: payment guides,
sandbox testing, compliance rules, identity verification, webhook
configuration, ACH return handling, and integration patterns.

For SDK and API reference (method signatures, parameters, response
shapes, code examples), use the `search_docs` MCP tool instead. That
tool is registered automatically and does not need this skill.

## How to search

POST to the docs endpoint directly. No MCP registration or auth required.

```bash
curl -s -X POST https://docs.straddle.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"search_straddle_docs","arguments":{"query":"YOUR_QUERY"}},"id":1}'
```

Parse the SSE response: each result in the `content` array has `text` containing `Title`, `Link`, and `Content` fields as HTML-formatted strings.

## When to use this vs search_docs

| Need | Tool |
|------|------|
| Method signatures, parameters, code examples | `search_docs` MCP tool (API reference) |
| Payment guides, compliance, sandbox testing | This skill (product docs) |
| How to call an endpoint | `search_docs` |
| How a feature works conceptually | This skill |
| Request/response shapes | `search_docs` |
| Status lifecycle, ACH returns, risk scores | This skill |

## Documentation index

https://docs.straddle.com/llms.txt -- complete sitemap of all Straddle
documentation pages with descriptions. Use as a fallback when the search
does not return the needed content.
