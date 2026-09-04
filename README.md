# IA

## MCP servers

`.mcp.json` registers the project-scope MCP servers for this repo. Claude Code picks
these up automatically when the repo is opened, and prompts once for approval before
connecting to a server it has not seen before.

### daroulistikhama

HTTP transport against the Novamira WordPress MCP endpoint:

    https://daroulistikhama.com/wp-json/mcp/novamira-oauth

The `-oauth` endpoint is for OAuth clients. Application Password clients use
`/wp-json/mcp/novamira` instead.

Authentication is a one-time interactive step per machine — the server reports
`Needs authentication` until it is done:

1. Run `/mcp` in an interactive Claude Code session.
2. Select `daroulistikhama`.
3. Choose Authenticate and complete the browser flow.

Check status at any time with:

    claude mcp list
