#!/usr/bin/env bash
# Outputs vault memory block to stdout. Reads vault path from obsidian-ai-memory config.
set -euo pipefail

CONFIG="${OBSIDIAN_AI_MEMORY_VAULT_CONFIG:-$HOME/.config/obsidian-ai-memory/vault}"

if [ ! -f "$CONFIG" ]; then
  echo "=== VAULT MEMORY — config missing: $CONFIG ===" >&2
  echo "Re-run: bash install.sh --vault \"/path/to/your vault\"" >&2
  exit 0
fi

V="$(<"$CONFIG")"
[ -n "$V" ] || { echo "=== VAULT MEMORY — empty config: $CONFIG ===" >&2; exit 0; }
[ -d "$V" ] || { echo "=== VAULT MEMORY — vault not found: $V ===" >&2; exit 0; }

echo '=== VAULT MEMORY (global, auto-injected) ==='
cat "$V/AI-Memory/Memory.md" 2>/dev/null || true
echo
echo '--- Next Session handoff ---'
cat "$V/AI-Memory/Next Session.md" 2>/dev/null || true
echo
# Vault Map is not injected (token cost): agents read it on demand before searching or filing.
if [ -f "$V/AI-Memory/Vault Map.md" ]; then
  echo "--- Vault Map: $V/AI-Memory/Vault Map.md (read before searching the vault or filing a note) ---"
else
  echo '--- Vault Map: MISSING (run onboard in the vault first) ---'
fi
echo
echo "--- Today's daily note ($(date +%Y-%m-%d)) ---"
DN=$(find "$V" -name "*$(date +%Y-%m-%d)*.md" \
  -not -path '*/.*' -not -path '*/AI-Memory/*' -not -path '*/templates/*' 2>/dev/null | head -1)
# Cap the daily note: long meeting notes would otherwise be injected in full every session.
MAX_DAILY_LINES="${OBSIDIAN_AI_MEMORY_MAX_DAILY_LINES:-60}"
if [ -n "$DN" ]; then
  head -n "$MAX_DAILY_LINES" "$DN"
  TOTAL=$(wc -l < "$DN" | tr -d ' ')
  [ "$TOTAL" -le "$MAX_DAILY_LINES" ] || echo "(... $((TOTAL - MAX_DAILY_LINES)) more lines: read $DN)"
else
  echo '(not created yet)'
fi
echo
echo '--- Vault projects ---'
ls "$V/AI-Memory/Projects/" 2>/dev/null || true
echo '=== END MEMORY — follow global vault rules ==='
