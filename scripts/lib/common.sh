#!/usr/bin/env bash
# Shared helpers for obsidian-ai-memory installers.
set -euo pipefail

OBSIDIAN_AI_MEMORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VAULT_CONFIG_DIR="${OBSIDIAN_AI_MEMORY_VAULT_CONFIG_DIR:-$HOME/.config/obsidian-ai-memory}"
VAULT_CONFIG_FILE="${OBSIDIAN_AI_MEMORY_VAULT_CONFIG:-$VAULT_CONFIG_DIR/vault}"

info()  { printf '→ %s\n' "$*"; }
warn()  { printf '⚠ %s\n' "$*" >&2; }
die()   { printf '✖ %s\n' "$*" >&2; exit 1; }

# Resolve and validate vault path to an absolute path (handles spaces).
resolve_vault() {
  local vault="${1:?vault path required}"
  [ -d "$vault" ] || die "Directory does not exist: $vault"
  vault="$(cd "$vault" && pwd)"
  printf '%s' "$vault"
}

# Persist vault path for hook scripts (avoids baking paths into shell via sed).
write_vault_config() {
  local vault="$1"
  mkdir -p "$VAULT_CONFIG_DIR"
  printf '%s\n' "$vault" > "$VAULT_CONFIG_FILE"
  info "Vault path saved to $VAULT_CONFIG_FILE"
}

# Substitute __VAULT__ and optional __HOOK_SCRIPT__ using Python (safe for spaces/special chars).
render_template() {
  local template="$1" vault="$2" hook_script="${3:-}"
  python3 - "$template" "$vault" "$hook_script" <<'PY'
import sys
from pathlib import Path

template, vault, hook_script = sys.argv[1], sys.argv[2], sys.argv[3]
text = Path(template).read_text()
text = text.replace("__VAULT__", vault)
if hook_script:
    text = text.replace("__HOOK_SCRIPT__", hook_script)
sys.stdout.write(text)
PY
}

# Backup a file if it exists; prints backup path or empty.
backup_file() {
  local f="$1"
  if [ -f "$f" ]; then
    cp "$f" "${f}.bak"
    printf '%s' "${f}.bak"
  fi
}

# Detect if claude CLI is on PATH.
has_claude_code() {
  command -v claude >/dev/null 2>&1
}

# Detect if cursor CLI is on PATH (optional; Cursor IDE works without it).
has_cursor_cli() {
  command -v cursor >/dev/null 2>&1
}

# Suggest vault paths under common Obsidian locations.
suggest_vault_paths() {
  local d base
  for base in "$HOME/Documents/Obsidian" "$HOME/Documents" "$HOME/Obsidian"; do
    [ -d "$base" ] || continue
    for d in "$base"/*; do
      [ -d "$d" ] && printf '%s\n' "$d"
    done
  done
}

# Prompt for vault path interactively.
prompt_vault_path() {
  local vault="" suggestions
  suggestions=$(suggest_vault_paths 2>/dev/null | head -5 || true)
  if [ -n "$suggestions" ]; then
    info "Suggested vault locations:"
    printf '%s\n' "$suggestions" | nl -w2 -s'. '
    echo
  fi
  read -r -p 'Vault path (quote paths with spaces, e.g. "/path/My Vault"): ' vault
  # Strip surrounding quotes if user included them
  vault="${vault%\"}"
  vault="${vault#\"}"
  vault="${vault%\'}"
  vault="${vault#\'}"
  vault="${vault/#\~/$HOME}"
  [ -n "$vault" ] || die "Vault path cannot be empty"
  resolve_vault "$vault"
}

# Prompt yes/no; default y or n.
prompt_yn() {
  local question="$1" default="${2:-y}" reply
  if [ "$default" = "y" ]; then
    read -r -p "$question [Y/n]: " reply
    reply="${reply:-y}"
    [[ "$reply" =~ ^[Yy] ]]
  else
    read -r -p "$question [y/N]: " reply
    reply="${reply:-n}"
    [[ "$reply" =~ ^[Yy] ]]
  fi
}

# Install vault-memory.sh hook (reads vault path from config file).
install_vault_memory_hook() {
  local dest_dir="$1"
  mkdir -p "$dest_dir"
  cp "$OBSIDIAN_AI_MEMORY_ROOT/templates/vault-memory.sh" "$dest_dir/vault-memory.sh"
  chmod +x "$dest_dir/vault-memory.sh"
  printf '%s/vault-memory.sh' "$dest_dir"
}

# Copy file only if destination missing (preserve user edits).
copy_if_missing() {
  local src="$1" dest="$2"
  if [ -e "$dest" ]; then
    info "  skip (exists): $dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    info "  added: $dest"
  fi
}

# Copy tree, skipping files that already exist at leaf level.
copy_tree_if_missing() {
  local src_dir="$1" dest_dir="$2"
  mkdir -p "$dest_dir"
  local f rel
  while IFS= read -r -d '' f; do
    rel="${f#"$src_dir"/}"
    copy_if_missing "$f" "$dest_dir/$rel"
  done < <(find "$src_dir" -type f -print0)
}

# Remove persisted vault config.
remove_vault_config() {
  [ -f "$VAULT_CONFIG_FILE" ] && rm -f "$VAULT_CONFIG_FILE" && info "Removed $VAULT_CONFIG_FILE"
}
