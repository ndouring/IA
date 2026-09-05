#!/usr/bin/env bash
# Connectivity + handshake check for the novamira-daroulistikhama MCP connector.
#
#   scripts/check-novamira-daroulistikhama.sh
#
# Optional, for the Application Password path:
#   NOVAMIRA_DI_USER, NOVAMIRA_DI_APP_PASSWORD

set -uo pipefail

SITE="https://daroulistikhama.com"
OAUTH_URL="$SITE/wp-json/mcp/novamira-oauth"
APP_URL="$SITE/wp-json/mcp/novamira"
ACCEPT="application/json, text/event-stream"

fail=0
say() { printf '\n== %s ==\n' "$1"; }
ok()  { printf '  ok    %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; fail=1; }

say "OAuth discovery"
for path in /.well-known/oauth-protected-resource /.well-known/oauth-authorization-server; do
  code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "$SITE$path")
  case "$code" in
    200) ok "$path -> 200" ;;
    404) printf '  warn  %s -> 404 (client may fall back to the resource metadata header)\n' "$path" ;;
    *)   bad "$path -> $code" ;;
  esac
done

say "OAuth endpoint challenges unauthenticated requests"
hdrs=$(curl -sS -D - -o /dev/null --max-time 20 -X POST "$OAUTH_URL" \
  -H "Accept: $ACCEPT" -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"connector-check","version":"1.0.0"}}}')
code=$(printf '%s' "$hdrs" | awk 'toupper($0) ~ /^HTTP\// {c=$2} END {print c}')
if [ "$code" = "401" ]; then
  ok "POST $OAUTH_URL -> 401"
  printf '%s' "$hdrs" | grep -i '^www-authenticate:' || bad "no WWW-Authenticate header on the 401"
else
  bad "POST $OAUTH_URL -> $code (expected 401 for an unauthenticated request)"
fi

if [ -n "${NOVAMIRA_DI_USER:-}" ] && [ -n "${NOVAMIRA_DI_APP_PASSWORD:-}" ]; then
  say "Application Password handshake"
  init=$(curl -sS --max-time 30 -X POST "$APP_URL" \
    -u "$NOVAMIRA_DI_USER:$NOVAMIRA_DI_APP_PASSWORD" \
    -H "Accept: $ACCEPT" -H 'Content-Type: application/json' \
    -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"connector-check","version":"1.0.0"}}}')
  if printf '%s' "$init" | grep -q '"serverInfo"'; then
    ok "initialize"
    printf '%s\n' "$init" | sed 's/^/    /'
    tools=$(curl -sS --max-time 30 -X POST "$APP_URL" \
      -u "$NOVAMIRA_DI_USER:$NOVAMIRA_DI_APP_PASSWORD" \
      -H "Accept: $ACCEPT" -H 'Content-Type: application/json' \
      -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}')
    if printf '%s' "$tools" | grep -q '"tools"'; then
      ok "tools/list"
      printf '%s' "$tools" | grep -o '"name":"[^"]*"' | sed 's/^/    /'
    else
      bad "tools/list: $tools"
    fi
  else
    bad "initialize: $init"
  fi
else
  printf '\n(skipping Application Password handshake: set NOVAMIRA_DI_USER and NOVAMIRA_DI_APP_PASSWORD)\n'
fi

printf '\n'
[ "$fail" -eq 0 ] && echo "connector check passed" || echo "connector check reported failures"
exit "$fail"
