#!/usr/bin/env bash
# Configure the Obsidian MCP server for Cursor and/or Claude Code.
#   Cursor      -> merged into ~/.cursor/mcp.json (JSON edit).
#   Claude Code -> `claude mcp add -s user` (user scope, available in every repo).
# Usage: bash install-obsidian-mcp.sh /absolute/path/to/vault [cursor|claude-code|both]
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: install-obsidian-mcp.sh /path/to/vault [cursor|claude-code|both]}")"
TARGET="${2:-both}"

NPX="$(command -v npx || true)"
[ -n "$NPX" ] || die "npx not found — install Node.js (brew install node)"

MCP_ARGS=(-y "@bitbonsai/mcpvault@latest" "$VAULT")

# --- Cursor: merge into ~/.cursor/mcp.json ---
install_mcp_cursor() {
  local mcp_path="$HOME/.cursor/mcp.json"
  python3 - "$mcp_path" "$NPX" "$VAULT" <<'PY'
import json, os, re, shutil, sys

mcp_path, npx, vault = sys.argv[1], sys.argv[2], sys.argv[3]
entry = {
    "type": "stdio",
    "command": npx,
    "args": ["-y", "@bitbonsai/mcpvault@latest", vault],
}

def load_jsonc(text):
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.DOTALL)
    text = re.sub(r'//[^\n]*', '', text)
    return json.loads(text)

def format_obsidian_entry(e, indent=4):
    inner = json.dumps(e, indent=2)
    lines = inner.splitlines()
    padded = "\n".join(" " * indent + line for line in lines)
    return f'"obsidian": {padded.strip()}'

if os.path.exists(mcp_path):
    shutil.copy(mcp_path, mcp_path + ".bak")
    with open(mcp_path) as f:
        original = f.read()

    if re.search(r'"obsidian"\s*:', original):
        # Replace only the obsidian block — preserve comments elsewhere
        new_block = format_obsidian_entry(entry, indent=4)
        updated = re.sub(
            r'"obsidian"\s*:\s*\{.*?\n\s*\}',
            new_block,
            original,
            count=1,
            flags=re.DOTALL,
        )
        if updated == original:
            # Fallback: replace vault path in args only
            updated = re.sub(
                r'("@bitbonsai/mcpvault@latest",\s*\n?\s*")[^"]*(")',
                rf'\1{vault}\2',
                original,
                count=1,
            )
        with open(mcp_path, "w") as f:
            f.write(updated)
        print(f"Obsidian MCP updated in {mcp_path} (comments preserved)")
    else:
        # Insert new obsidian entry into mcpServers
        cur = load_jsonc(original)
        cur.setdefault("mcpServers", {})["obsidian"] = entry
        with open(mcp_path, "w") as f:
            json.dump(cur, f, indent=2)
            f.write("\n")
        print(f"Obsidian MCP added to {mcp_path} (file normalized to valid JSON)")
else:
    cur = {"mcpServers": {"obsidian": entry}}
    os.makedirs(os.path.dirname(mcp_path), exist_ok=True)
    with open(mcp_path, "w") as f:
        json.dump(cur, f, indent=2)
        f.write("\n")
    print(f"Created {mcp_path} with Obsidian MCP")
PY
  info "  Cursor: restart Cursor and verify in Settings → MCP."
}

# --- Claude Code: use the supported CLI (user scope, all repos) ---
install_mcp_claude() {
  if ! has_claude_code; then
    warn "  claude CLI not found — skipping Claude Code MCP. Install Claude Code, then re-run with 'claude-code'."
    return 0
  fi
  # Idempotent: drop any existing user-scope entry so the vault path is refreshed.
  claude mcp remove obsidian -s user >/dev/null 2>&1 || true
  claude mcp add -s user obsidian -- "$NPX" "${MCP_ARGS[@]}"
  info "  Claude Code: Obsidian MCP added at user scope. Verify: claude mcp get obsidian"
}

case "$TARGET" in
  cursor)      install_mcp_cursor ;;
  claude-code) install_mcp_claude ;;
  both)
    # Only touch Cursor if it's actually present — don't create a stray ~/.cursor.
    if [ -d "$HOME/.cursor" ] || has_cursor_cli; then
      install_mcp_cursor
    else
      info "  Cursor not detected — skipping ~/.cursor/mcp.json."
    fi
    install_mcp_claude
    ;;
  *)           die "Unknown target: $TARGET (use cursor | claude-code | both)" ;;
esac

echo
info "Obsidian MCP configured. Vault: $VAULT"
