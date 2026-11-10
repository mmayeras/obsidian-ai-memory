#!/usr/bin/env bash
# Interactive installer for obsidian-ai-memory — vault kit + Claude Code + Cursor + Codex + optional MCP.
# Usage:
#   bash install.sh
#   bash install.sh --vault "/path/to/vault" --platforms claude-code,cursor,codex --mcp yes
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$HERE/scripts/lib/common.sh"

VAULT=""
PLATFORMS=""
MCP=""

usage() {
  cat <<'EOF'
Usage: bash install.sh [options]

Options:
  --vault PATH          Absolute path to your Obsidian vault
  --platforms LIST      Comma-separated: claude-code, cursor, codex (default: every one detected)
  --mcp yes|no|skip     Install Obsidian MCP for the selected platforms (default: yes)
  -h, --help            Show this help

Examples:
  bash install.sh
  bash install.sh --vault "/Users/you/Documents/Obsidian/Obsidian Vault" --platforms claude-code,cursor,codex --mcp yes

Note: quote vault paths that contain spaces.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --vault)     VAULT="$2"; shift 2 ;;
    --platforms) PLATFORMS="$2"; shift 2 ;;
    --mcp)       MCP="$2"; shift 2 ;;
    -h|--help)   usage; exit 0 ;;
    *) die "Unknown option: $1 (try --help)" ;;
  esac
done

# --- Vault path ---
if [ -z "$VAULT" ]; then
  VAULT="$(prompt_vault_path)"
else
  VAULT="${VAULT%\"}"
  VAULT="${VAULT#\"}"
  VAULT="${VAULT%\'}"
  VAULT="${VAULT#\'}"
  VAULT="${VAULT/#\~/$HOME}"
  VAULT="$(resolve_vault "$VAULT")"
fi

write_vault_config "$VAULT"

# --- Platforms ---
if [ -z "$PLATFORMS" ]; then
  detected=()
  has_claude_code && detected+=("claude-code")
  { [ -d "$HOME/.cursor" ] || has_cursor_cli; } && detected+=("cursor")
  { [ -d "${CODEX_HOME:-$HOME/.codex}" ] || command -v codex >/dev/null 2>&1; } && detected+=("codex")
  if [ ${#detected[@]} -gt 0 ]; then
    PLATFORMS="$(IFS=,; echo "${detected[*]}")"
    info "Detected: $PLATFORMS"
  else
    warn "No Claude Code, Cursor or Codex found."
    echo "  1) claude-code  2) cursor  3) codex  4) all"
    read -r -p "Platforms to install [1/2/3/4]: " choice
    case "${choice:-4}" in
      1) PLATFORMS="claude-code" ;;
      2) PLATFORMS="cursor" ;;
      3) PLATFORMS="codex" ;;
      *) PLATFORMS="claude-code,cursor,codex" ;;
    esac
  fi
fi

want_claude_code=false
want_cursor=false
want_codex=false
[[ "$PLATFORMS" == *"claude-code"* ]] && want_claude_code=true
[[ "$PLATFORMS" == *"cursor"* ]] && want_cursor=true
[[ "$PLATFORMS" == *"codex"* ]] && want_codex=true

# --- MCP ---
if [ -z "$MCP" ]; then
  if $want_cursor || $want_claude_code || $want_codex; then
    if prompt_yn "Install Obsidian MCP? (recommended: faster, targeted vault search and safer note edits)" y; then
      MCP="yes"
    else
      MCP="no"
    fi
  else
    MCP="skip"
  fi
fi

# --- Confirm ---
echo
info "Install summary:"
info "  Vault:      $VAULT"
info "  Platforms:  $PLATFORMS"
info "  Obsidian MCP: $MCP"
echo
if [ -z "${OBSIDIAN_AI_MEMORY_YES:-}" ]; then
  prompt_yn "Proceed?" y || die "Aborted."
fi

# --- Step 1: vault kit ---
bash "$HERE/scripts/install-vault.sh" "$VAULT"

# --- Step 2: platforms ---
if $want_claude_code; then
  bash "$HERE/scripts/install-claude-code.sh" "$VAULT"
fi
if $want_cursor; then
  bash "$HERE/scripts/install-cursor.sh" "$VAULT"
fi
if $want_codex; then
  bash "$HERE/scripts/install-codex.sh" "$VAULT"
fi
if [ "$MCP" = "yes" ]; then
  if $want_claude_code; then bash "$HERE/scripts/install-obsidian-mcp.sh" "$VAULT" claude-code; fi
  if $want_cursor; then bash "$HERE/scripts/install-obsidian-mcp.sh" "$VAULT" cursor; fi
  if $want_codex; then bash "$HERE/scripts/install-obsidian-mcp.sh" "$VAULT" codex; fi
fi

echo
info "Installation complete."
info "  Vault: $VAULT"
if $want_claude_code; then
  info "  Claude Code: run 'claude' from any repo; then /onboard once from the vault."
fi
if $want_cursor; then
  info "  Cursor: restart IDE, open Agent chat; say 'onboard my vault' once from the vault."
fi
if $want_codex; then
  info "  Codex: restart it, approve the vault hook when asked; say 'onboard my vault' once from the vault."
fi
info "  Day-to-day: 'remember this', 'wrap up' ('startup' only if memory seems missing)"
info "  Docs: $HERE/docs/"
