#!/usr/bin/env bash
# Copy obsidian-ai-memory kit into an Obsidian vault. Preserves existing user memory files.
# Usage: bash install-vault.sh /absolute/path/to/vault [--update-rules]
#   --update-rules  replace the vault's CLAUDE.md with the current template (old one kept as CLAUDE.md.bak)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: install-vault.sh /path/to/vault [--update-rules]}")"
UPDATE_RULES="${2:-}"
KIT="$OBSIDIAN_AI_MEMORY_ROOT"
RULES_SRC="$KIT/templates/vault/CLAUDE.md"

info "Installing vault kit into: $VAULT"

if [ "$UPDATE_RULES" = "--update-rules" ] && [ -f "$VAULT/CLAUDE.md" ]; then
  cp "$VAULT/CLAUDE.md" "$VAULT/CLAUDE.md.bak"
  cp "$RULES_SRC" "$VAULT/CLAUDE.md"
  info "  updated: $VAULT/CLAUDE.md (previous version in CLAUDE.md.bak)"
else
  copy_if_missing "$RULES_SRC" "$VAULT/CLAUDE.md"
  # Older kit versions put a startup table and a full copy of the global rules in the vault CLAUDE.md.
  if grep -q '| Startup | Status |' "$VAULT/CLAUDE.md" 2>/dev/null; then
    warn "Vault CLAUDE.md is from an older kit version (startup table, duplicated global rules)."
    warn "  Update it: bash scripts/install-vault.sh \"$VAULT\" --update-rules"
  fi
fi
copy_tree_if_missing "$KIT/.claude/commands" "$VAULT/.claude/commands"   # not settings.local.json
copy_tree_if_missing "$KIT/AI-Memory" "$VAULT/AI-Memory"
copy_if_missing "$KIT/templates/vault/Account Overview template.md" "$VAULT/templates/Account Overview template.md"

info "Vault kit installed."
info "  Next: run onboard once from the vault (see docs/claude-code.md or docs/cursor.md)"
