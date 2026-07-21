#!/usr/bin/env bash
# Remove Claude Code global vault memory integration.
set -euo pipefail

info() { printf '→ %s\n' "$*"; }

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SETTINGS="$HOME/.claude/settings.json"

if [ -f "$CLAUDE_MD" ]; then
  if grep -q '@CLAUDE-vault.md' "$CLAUDE_MD" 2>/dev/null; then
    cp "$CLAUDE_MD" "${CLAUDE_MD}.bak"
    grep -v '@CLAUDE-vault.md' "$CLAUDE_MD" > "${CLAUDE_MD}.tmp" && mv "${CLAUDE_MD}.tmp" "$CLAUDE_MD"
    info "Removed @CLAUDE-vault.md from ~/.claude/CLAUDE.md"
  fi
fi

[ -f "$HOME/.claude/CLAUDE-vault.md" ] && rm -f "$HOME/.claude/CLAUDE-vault.md" && info "Removed CLAUDE-vault.md"

if [ -f "$SETTINGS" ]; then
  python3 - "$SETTINGS" <<'PY'
import json, sys, os, shutil
path = sys.argv[1]
shutil.copy(path, path + ".bak")
with open(path) as f:
    cur = json.load(f)
hooks = cur.get("hooks", {}).get("SessionStart", [])
hooks[:] = [h for h in hooks
            if "VAULT MEMORY" not in json.dumps(h)
            and "vault-memory" not in json.dumps(h)]
cur.setdefault("hooks", {})["SessionStart"] = hooks
with open(path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"Removed vault hook from {path}")
PY
fi

[ -f "$HOME/.claude/hooks/vault-memory.sh" ] && rm -f "$HOME/.claude/hooks/vault-memory.sh" && info "Removed vault-memory.sh hook"

# Obsidian MCP (user scope) — remove if present.
if command -v claude >/dev/null 2>&1 && claude mcp get obsidian >/dev/null 2>&1; then
  claude mcp remove obsidian -s user >/dev/null 2>&1 && info "Removed obsidian MCP (user scope)"
fi

info "Claude Code uninstall done. Vault AI-Memory/ folder was NOT touched."
