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
echo '--- Vault Map ---'
cat "$V/AI-Memory/Vault Map.md" 2>/dev/null || echo '(run onboard in the vault first)'
echo
echo "--- Today's daily note ($(date +%Y-%m-%d)) ---"
DN=$(find "$V" -name "*$(date +%Y-%m-%d)*.md" \
  -not -path '*/.*' -not -path '*/AI-Memory/*' -not -path '*/templates/*' 2>/dev/null | head -1)
if [ -n "$DN" ]; then cat "$DN"; else echo '(not created yet)'; fi
echo
echo '--- Vault projects ---'
ls "$V/AI-Memory/Projects/" 2>/dev/null || true
echo '=== END MEMORY — follow global vault rules ==='
