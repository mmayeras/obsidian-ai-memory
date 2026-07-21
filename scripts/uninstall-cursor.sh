#!/usr/bin/env bash
# Remove Cursor global vault memory integration.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

[ -f "$HOME/.cursor/rules/vault-memory.mdc" ] && rm -f "$HOME/.cursor/rules/vault-memory.mdc" && info "Removed vault-memory.mdc"

for f in vault-memory.sh vault-memory-cursor.sh; do
  [ -f "$HOME/.cursor/hooks/$f" ] && rm -f "$HOME/.cursor/hooks/$f" && info "Removed hooks/$f"
done

if [ -f "$HOME/.cursor/hooks.json" ]; then
  python3 - "$HOME/.cursor/hooks.json" <<'PY'
import json, sys, os, shutil
path = sys.argv[1]
shutil.copy(path, path + ".bak")
with open(path) as f:
    cur = json.load(f)
session = cur.get("hooks", {}).get("sessionStart", [])
session[:] = [h for h in session if "vault-memory" not in json.dumps(h)]
cur.setdefault("hooks", {})["sessionStart"] = session
with open(path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"Removed vault sessionStart hook from {path}")
PY
fi

for skill in vault-onboard vault-organize vault-rewrite vault-wrap-up; do
  [ -d "$HOME/.cursor/skills/$skill" ] && rm -rf "$HOME/.cursor/skills/$skill" && info "Removed skill: $skill"
done

if prompt_yn "Also remove Obsidian MCP entry from ~/.cursor/mcp.json?" n; then
  MCP_PATH="$HOME/.cursor/mcp.json"
  if [ -f "$MCP_PATH" ]; then
    python3 - "$MCP_PATH" <<'PY'
import json, sys, os, shutil
path = sys.argv[1]
shutil.copy(path, path + ".bak")
with open(path) as f:
    cur = json.load(f)
servers = cur.get("mcpServers", {})
servers.pop("obsidian", None)
cur["mcpServers"] = servers
with open(path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"Removed obsidian MCP from {path}")
PY
  fi
fi

info "Cursor uninstall done. Vault AI-Memory/ folder was NOT touched."
