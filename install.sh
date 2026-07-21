#!/usr/bin/env bash
# Interactive installer for obsidian-ai-memory — vault kit + Claude Code + Cursor + optional MCP.
# Usage:
#   bash install.sh
#   bash install.sh --vault "/path/to/vault" --platforms claude-code,cursor --mcp yes
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
  --platforms LIST      Comma-separated: claude-code, cursor (default: both if detected)
  --mcp yes|no|skip     Install Obsidian MCP for the selected platforms (default: yes)
  -h, --help            Show this help

Examples:
  bash install.sh
  bash install.sh --vault "/Users/you/Documents/Obsidian/Obsidian Vault" --platforms claude-code,cursor --mcp yes

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
  if has_claude_code && { has_cursor_cli || [ -d "$HOME/.cursor" ]; }; then
    PLATFORMS="claude-code,cursor"
    info "Detected Claude Code and Cursor — installing both."
  elif has_claude_code; then
    PLATFORMS="claude-code"
    info "Detected Claude Code only."
  elif [ -d "$HOME/.cursor" ] || has_cursor_cli; then
    PLATFORMS="cursor"
    info "Detected Cursor — installing Cursor integration."
  else
    warn "Neither 'claude' CLI nor ~/.cursor found."
    echo "  1) claude-code  2) cursor  3) both"
    read -r -p "Platforms to install [1/2/3]: " choice
    case "${choice:-3}" in
      1) PLATFORMS="claude-code" ;;
      2) PLATFORMS="cursor" ;;
      *) PLATFORMS="claude-code,cursor" ;;
    esac
  fi
fi

want_claude_code=false
want_cursor=false
[[ "$PLATFORMS" == *"claude-code"* ]] && want_claude_code=true
[[ "$PLATFORMS" == *"cursor"* ]] && want_cursor=true

# --- MCP ---
if [ -z "$MCP" ]; then
  if $want_cursor || $want_claude_code; then
    if prompt_yn "Install Obsidian MCP? (recommended — frontmatter-aware search/append)" y; then
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
if [ "$MCP" = "yes" ]; then
  mcp_target="both"
  if $want_cursor && ! $want_claude_code; then
    mcp_target="cursor"
  elif $want_claude_code && ! $want_cursor; then
    mcp_target="claude-code"
  fi
  bash "$HERE/scripts/install-obsidian-mcp.sh" "$VAULT" "$mcp_target"
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
info "  Day-to-day: 'remember this', 'wrap up', 'startup'"
info "  Docs: $HERE/docs/"
