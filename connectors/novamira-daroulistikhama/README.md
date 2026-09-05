# novamira-daroulistikhama

MCP connector for the Novamira endpoint on **daroulistikhama.com**.

| | |
|---|---|
| Connector name | `novamira-daroulistikhama` |
| MCP endpoint (OAuth) | `https://daroulistikhama.com/wp-json/mcp/novamira-oauth` |
| MCP endpoint (Application Password) | `https://daroulistikhama.com/wp-json/mcp/novamira` |
| Transport | Streamable HTTP (`type: "http"`) |
| Auth | OAuth 2.1 authorization code + PKCE (S256), public client, dynamic client registration |
| Scope | `mcp` |

This is the same Novamira WordPress MCP plugin already connected in this account as
`AfricaMedicalink`; only the host differs. Use the `-oauth` path for interactive
clients (claude.ai, Claude Code) and the plain `/novamira` path for headless clients
that authenticate with a WordPress Application Password.

The endpoint shape below was confirmed against a live Novamira v1.12.1 install
(`africamedicalink.com`), which registers exactly `/mcp/novamira` and
`/mcp/novamira-oauth` (both `GET`/`POST`/`DELETE`) and answers an unauthenticated
POST to the OAuth route with:

```
HTTP/1.1 401
WWW-Authenticate: Bearer resource_metadata="https://<site>/.well-known/oauth-protected-resource", scope="mcp"

{"code":"rest_oauth_required","message":"OAuth authentication required.","data":{"status":401}}
```

### OAuth endpoints

Advertised at `/.well-known/oauth-authorization-server`, with the site itself as issuer:

| Purpose | Endpoint |
|---|---|
| Authorization | `/wp-admin/admin.php?page=novamira-oauth-authorize` |
| Token | `/wp-json/novamira/v1/oauth/token` |
| Registration | `/wp-json/novamira/v1/oauth/register` |
| Revocation | `/wp-json/novamira/v1/oauth/revoke` |
| Introspection | `/wp-json/novamira/v1/oauth/introspect` |
| Device authorization | `/wp-json/novamira/v1/oauth/device` |

Grants: `authorization_code`, `refresh_token`, and `urn:ietf:params:oauth:grant-type:device_code`.
`token_endpoint_auth_methods_supported` is `["none"]` — clients are public and use PKCE,
so there is no client secret to configure anywhere.

Because the authorization endpoint is a wp-admin page, whoever completes the flow must
be able to log in to `daroulistikhama.com/wp-admin` as the WordPress user whose access
the connector should carry.

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

## 3. Headless / CI

Two options, no browser required for the second:

**Device authorization grant** — the server supports
`urn:ietf:params:oauth:grant-type:device_code` at
`/wp-json/novamira/v1/oauth/device`, so a headless client can register itself, poll for
a device code, and have a human approve it once from any browser. Preferred when the
client should act with a real user's OAuth grant that can later be revoked.

**Application Password** — simpler: skip OAuth and call the non-OAuth endpoint with a
WordPress Application Password (Users → Profile → Application Passwords):

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

The script checks both OAuth discovery documents, confirms the OAuth endpoint
challenges unauthenticated requests with `401` plus a `WWW-Authenticate` header
carrying `resource_metadata`, and — when `NOVAMIRA_DI_USER`/`NOVAMIRA_DI_APP_PASSWORD`
are set — performs a real MCP `initialize` + `tools/list` handshake against the
Application Password endpoint.

## Notes

- `daroulistikhama.com` is blocked by the network egress policy of the sandbox this
  connector was authored in, so the endpoint itself has not been reached from here.
  The definition is validated against another install of the same plugin version, not
  against this host: run the check script from a machine with normal outbound access to
  confirm the live behaviour before relying on it.
- Novamira grants an agent full control of the WordPress install (`execute-php`,
  `run-wp-cli`, filesystem read/write). Connect it only with an account whose level of
  access you intend the agent to have.
- If OAuth registration fails, check that the WordPress site is served over HTTPS with
  a valid certificate and that `/.well-known/oauth-authorization-server` is not being
  swallowed by a caching or security plugin.
