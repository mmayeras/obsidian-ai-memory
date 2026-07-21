#!/usr/bin/env bash
# Copy obsidian-ai-memory kit into an Obsidian vault. Preserves existing user memory files.
# Usage: bash install-vault.sh /absolute/path/to/vault
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: install-vault.sh /path/to/vault}")"
KIT="$OBSIDIAN_AI_MEMORY_ROOT"

info "Installing vault kit into: $VAULT"

copy_if_missing "$KIT/CLAUDE.md" "$VAULT/CLAUDE.md"
copy_tree_if_missing "$KIT/.claude" "$VAULT/.claude"
copy_tree_if_missing "$KIT/Claude" "$VAULT/AI-Memory"

info "Vault kit installed."
info "  Next: run onboard once from the vault (see docs/claude-code.md or docs/cursor.md)"
