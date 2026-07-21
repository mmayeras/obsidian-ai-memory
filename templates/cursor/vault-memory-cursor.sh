#!/usr/bin/env bash
# Cursor sessionStart hook: wrap vault-memory.sh output as additional_context JSON.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTENT=$("$SCRIPT_DIR/vault-memory.sh" 2>/dev/null || true)
# Escape for JSON string: backslash, double-quote, newline
ESCAPED=$(printf '%s' "$CONTENT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
printf '{"additional_context":%s}\n' "$ESCAPED"
