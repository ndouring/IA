# novamira-daroulistikhama

MCP connector for the Novamira endpoint on **daroulistikhama.com**.

| | |
|---|---|
| Connector name | `novamira-daroulistikhama` |
| MCP endpoint (OAuth) | `https://daroulistikhama.com/wp-json/mcp/novamira-oauth` |
| MCP endpoint (Application Password) | `https://daroulistikhama.com/wp-json/mcp/novamira` |
| Transport | Streamable HTTP (`type: "http"`) |
| Auth | OAuth 2.1 authorization code + PKCE, with dynamic client registration |

This is the same Novamira WordPress MCP plugin already connected in this account as
`AfricaMedicalink`; only the host differs. Use the `-oauth` path for interactive
clients (claude.ai, Claude Code) and the plain `/novamira` path for headless clients
that authenticate with a WordPress Application Password.

## 1. Claude Code (this repository)

`.mcp.json` at the repo root already declares the server, so any Claude Code session
started in this repo picks it up:

```json
{
  "mcpServers": {
    "novamira-daroulistikhama": {
      "type": "http",
      "url": "https://daroulistikhama.com/wp-json/mcp/novamira-oauth"
    }
  }
}
```

Approve the server when Claude Code prompts, then run `/mcp` and choose
**Authenticate** for `novamira-daroulistikhama` to complete the OAuth flow in a browser.

To add it outside this repo instead:

```bash
claude mcp add --transport http novamira-daroulistikhama \
  https://daroulistikhama.com/wp-json/mcp/novamira-oauth
```

Add `--scope user` to make it available in every project.

## 2. claude.ai / Claude Desktop (custom connector)

The web and desktop apps register connectors server-side, so this has to be done in
the UI once:

1. Settings → **Connectors** → **Add custom connector**.
2. Name: `novamira-daroulistikhama`
3. URL: `https://daroulistikhama.com/wp-json/mcp/novamira-oauth`
4. Leave client ID / secret blank — the server supports dynamic client registration.
5. Save, then **Connect** and sign in with the WordPress account that owns the data.

After connecting, enable it for a chat from the connector toggle in that chat.

## 3. Headless / Application Password

For scripts and CI, skip OAuth and call the non-OAuth endpoint with a WordPress
Application Password (Users → Profile → Application Passwords):

```bash
export NOVAMIRA_DI_USER='wp-username'
export NOVAMIRA_DI_APP_PASSWORD='xxxx xxxx xxxx xxxx xxxx xxxx'
scripts/check-novamira-daroulistikhama.sh
```

Never commit the password; it is a full-privilege credential for that WordPress user.

## Verifying

```bash
scripts/check-novamira-daroulistikhama.sh
```

The script checks OAuth discovery, confirms the OAuth endpoint challenges
unauthenticated requests with `401 + WWW-Authenticate`, and — when
`NOVAMIRA_DI_USER`/`NOVAMIRA_DI_APP_PASSWORD` are set — performs a real MCP
`initialize` + `tools/list` handshake against the Application Password endpoint.

## Notes

- `daroulistikhama.com` is blocked by the network egress policy of the sandbox this
  connector was authored in, so the endpoint has not been reached from here. Run the
  check script from a machine with normal outbound access to confirm the live
  behaviour before relying on it.
- If OAuth registration fails, check that the WordPress site is served over HTTPS with
  a valid certificate and that `/.well-known/oauth-authorization-server` is not being
  swallowed by a caching or security plugin.
