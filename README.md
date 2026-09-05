# IA

## MCP servers

`.mcp.json` declares the project-scoped MCP servers for this repository. Claude
Code picks it up automatically when a session starts in this directory, and
prompts once for approval before connecting.

### daroulistikhama

Streamable HTTP endpoint served by the Novamira MCP plugin on the
daroulistikhama.com WordPress site:

| | |
| --- | --- |
| Transport | `http` |
| URL | `https://daroulistikhama.com/wp-json/mcp/novamira-oauth` |
| Auth | OAuth (browser flow on first connect) |

The `-oauth` endpoint is the one to use from Claude Code: authentication runs
through the browser and no secret is stored in the repository. Clients that
authenticate with a WordPress Application Password instead should point at
`https://daroulistikhama.com/wp-json/mcp/novamira` and send the credentials in
an `Authorization` header — never commit those to this file.

Useful commands:

```sh
claude mcp list                 # show configured servers and connection state
/mcp                            # in-session: check status, authenticate, re-auth
```
