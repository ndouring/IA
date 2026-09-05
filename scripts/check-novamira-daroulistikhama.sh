#!/usr/bin/env bash
# Connectivity + handshake check for the novamira-daroulistikhama MCP connector.
#
#   scripts/check-novamira-daroulistikhama.sh
#
# Optional, for the Application Password path:
#   NOVAMIRA_DI_USER, NOVAMIRA_DI_APP_PASSWORD
#
# Override the target host (e.g. a staging site) with NOVAMIRA_DI_SITE.

set -uo pipefail

SITE="${NOVAMIRA_DI_SITE:-https://daroulistikhama.com}"
OAUTH_URL="$SITE/wp-json/mcp/novamira-oauth"
APP_URL="$SITE/wp-json/mcp/novamira"
ACCEPT="application/json, text/event-stream"
PROTOCOL="2025-06-18"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fail=0
say()  { printf '\n== %s ==\n' "$1"; }
ok()   { printf '  ok    %s\n' "$1"; }
warn() { printf '  warn  %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n' "$1"; fail=1; }
indent() { awk '{print "    " $0}'; }
unesc()  { sed 's|\\/|/|g'; }

status_of() { awk 'toupper($0) ~ /^HTTP\// {c=$2} END {print c}' "$1"; }

# Fetch $1 into $TMP/body; echo the status code.
fetch() { curl -sS -D "$TMP/hdr" -o "$TMP/body" -w '%{http_code}' --max-time 20 "$1" 2>/dev/null; }

# Try each candidate URL in turn, stop at the first 200. Echoes the winning URL.
first_200() {
  for u in "$@"; do
    [ -n "$u" ] || continue
    if [ "$(fetch "$u")" = "200" ]; then printf '%s' "$u"; return 0; fi
  done
  return 1
}

say "OAuth challenge on the MCP endpoint"
curl -sS -D "$TMP/hdr" -o "$TMP/body" --max-time 20 -X POST "$OAUTH_URL" \
  -H "Accept: $ACCEPT" -H 'Content-Type: application/json' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"protocolVersion\":\"$PROTOCOL\",\"capabilities\":{},\"clientInfo\":{\"name\":\"connector-check\",\"version\":\"1.0.0\"}}}" \
  >/dev/null 2>&1
code=$(status_of "$TMP/hdr")
challenge=$(grep -i '^www-authenticate:' "$TMP/hdr" | tr -d '\r')
resource_metadata=""
if [ "$code" = "401" ]; then
  ok "POST $OAUTH_URL -> 401"
  if [ -n "$challenge" ]; then
    printf '%s\n' "$challenge" | indent
    resource_metadata=$(printf '%s' "$challenge" | sed -n 's/.*resource_metadata="\([^"]*\)".*/\1/p')
    [ -n "$resource_metadata" ] \
      && ok "challenge advertises resource_metadata" \
      || bad "WWW-Authenticate has no resource_metadata parameter"
  else
    bad "no WWW-Authenticate header on the 401"
  fi
else
  bad "POST $OAUTH_URL -> ${code:-no response} (expected 401 for an unauthenticated request)"
fi

say "Protected-resource metadata"
# Prefer the URL the endpoint itself advertised; else RFC 9728 path-scoped; else origin root.
rm_url=$(first_200 \
  "$resource_metadata" \
  "$SITE/.well-known/oauth-protected-resource${OAUTH_URL#"$SITE"}" \
  "$SITE/.well-known/oauth-protected-resource")
if [ -n "$rm_url" ]; then
  ok "$rm_url -> 200"
  cat "$TMP/body" | indent
  issuer=$(tr -d '\n' < "$TMP/body" \
    | sed -n 's/.*"authorization_servers"[[:space:]]*:[[:space:]]*\[[[:space:]]*"\([^"]*\)".*/\1/p' \
    | head -1 | unesc)
  resource=$(grep -o '"resource"[[:space:]]*:[[:space:]]*"[^"]*"' "$TMP/body" | head -1 | cut -d'"' -f4 | unesc)
  [ "$resource" = "$OAUTH_URL" ] \
    && ok "declared resource matches the connector URL" \
    || warn "declared resource is '$resource', connector uses '$OAUTH_URL'"
else
  bad "no protected-resource metadata found (tried the challenge URL, the path-scoped URI, and the origin root)"
  issuer=""
fi

say "Authorization-server metadata"
if [ -n "${issuer:-}" ]; then
  ok "advertised issuer: $issuer"
  # RFC 8414 inserts the well-known segment between host and issuer path.
  origin=$(printf '%s' "$issuer" | sed -E 's|^(https?://[^/]+).*|\1|')
  ipath=${issuer#"$origin"}
  as_url=$(first_200 \
    "$origin/.well-known/oauth-authorization-server$ipath" \
    "$issuer/.well-known/oauth-authorization-server" \
    "$origin/.well-known/openid-configuration$ipath")
  if [ -n "$as_url" ]; then
    ok "$as_url -> 200"
    cat "$TMP/body" | indent
    for field in registration_endpoint token_endpoint authorization_endpoint; do
      grep -q "\"$field\"" "$TMP/body" && ok "advertises $field" || warn "no $field advertised"
    done
  else
    bad "no authorization-server metadata under issuer $issuer"
  fi
else
  warn "skipped: no issuer to follow"
fi

if [ -n "${NOVAMIRA_DI_USER:-}" ] && [ -n "${NOVAMIRA_DI_APP_PASSWORD:-}" ]; then
  say "Application Password handshake"
  curl -sS -D "$TMP/hdr" -o "$TMP/body" --max-time 30 -X POST "$APP_URL" \
    -u "$NOVAMIRA_DI_USER:$NOVAMIRA_DI_APP_PASSWORD" \
    -H "Accept: $ACCEPT" -H 'Content-Type: application/json' \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"protocolVersion\":\"$PROTOCOL\",\"capabilities\":{},\"clientInfo\":{\"name\":\"connector-check\",\"version\":\"1.0.0\"}}}" \
    >/dev/null 2>&1
  if grep -q '"serverInfo"' "$TMP/body"; then
    ok "initialize"
    cat "$TMP/body" | indent

    # Streamable HTTP is session-aware: carry the session id and the negotiated
    # protocol version into every later request, and send the initialized
    # notification before calling any method.
    session=$(grep -i '^mcp-session-id:' "$TMP/hdr" | head -1 | cut -d: -f2- | tr -d ' \r')
    negotiated=$(grep -o '"protocolVersion":"[^"]*"' "$TMP/body" | head -1 | cut -d'"' -f4)
    [ -n "$negotiated" ] || negotiated="$PROTOCOL"
    hdrs=(-H "Accept: $ACCEPT" -H 'Content-Type: application/json' -H "MCP-Protocol-Version: $negotiated")
    if [ -n "$session" ]; then
      hdrs+=(-H "Mcp-Session-Id: $session")
      ok "session established (Mcp-Session-Id: $session, protocol $negotiated)"
    else
      ok "server is stateless (no Mcp-Session-Id; protocol $negotiated)"
    fi

    ncode=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 30 -X POST "$APP_URL" \
      -u "$NOVAMIRA_DI_USER:$NOVAMIRA_DI_APP_PASSWORD" "${hdrs[@]}" \
      -d '{"jsonrpc":"2.0","method":"notifications/initialized"}')
    case "$ncode" in
      200|202|204) ok "notifications/initialized -> $ncode" ;;
      *)           bad "notifications/initialized -> $ncode" ;;
    esac

    tools=$(curl -sS --max-time 30 -X POST "$APP_URL" \
      -u "$NOVAMIRA_DI_USER:$NOVAMIRA_DI_APP_PASSWORD" "${hdrs[@]}" \
      -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}')
    if printf '%s' "$tools" | grep -q '"tools"'; then
      ok "tools/list"
      printf '%s' "$tools" | grep -o '"name":"[^"]*"' | indent
    else
      bad "tools/list: $tools"
    fi
  else
    bad "initialize: $(cat "$TMP/body")"
  fi
else
  printf '\n(skipping Application Password handshake: set NOVAMIRA_DI_USER and NOVAMIRA_DI_APP_PASSWORD)\n'
fi

printf '\n'
[ "$fail" -eq 0 ] && echo "connector check passed" || echo "connector check reported failures"
exit "$fail"
