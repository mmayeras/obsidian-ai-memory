#!/usr/bin/env bash
# Remove Codex global vault memory integration. The vault itself is not touched.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"

if [ -f "$CODEX_DIR/AGENTS.md" ]; then
  python3 - "$CODEX_DIR/AGENTS.md" <<'PY'
import re, shutil, sys
path = sys.argv[1]
cur = open(path).read()
new = re.sub(r"\n*<!-- BEGIN OBSIDIAN AI MEMORY.*?-->.*?<!-- END OBSIDIAN AI MEMORY -->\n?", "\n", cur, flags=re.S)
if new != cur:
    shutil.copy(path, path + ".bak")
    open(path, "w").write(new.rstrip("\n") + "\n")
    print(f"Removed vault rules block from {path}")
PY
fi

if [ -f "$CODEX_DIR/hooks.json" ]; then
  python3 - "$CODEX_DIR/hooks.json" <<'PY'
import json, shutil, sys
path = sys.argv[1]
shutil.copy(path, path + ".bak")
with open(path) as f:
    cur = json.load(f)
session = cur.get("hooks", {}).get("SessionStart", [])
session[:] = [h for h in session if "vault-memory" not in json.dumps(h)]
cur.setdefault("hooks", {})["SessionStart"] = session
with open(path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"Removed vault SessionStart hook from {path}")
PY
fi

for f in vault-memory.sh vault-memory-cursor.sh; do
  [ -f "$CODEX_DIR/hooks/$f" ] && rm -f "$CODEX_DIR/hooks/$f" && info "Removed hooks/$f"
done

for skill in vault-onboard vault-organize vault-rewrite vault-wrap-up; do
  [ -d "$HOME/.agents/skills/$skill" ] && rm -rf "$HOME/.agents/skills/$skill" && info "Removed skill: $skill"
done

if command -v codex >/dev/null 2>&1 && prompt_yn "Also remove the obsidian MCP server from Codex?" n; then
  codex mcp remove obsidian && info "Removed obsidian MCP from Codex"
elif grep -q '^\[mcp_servers\.obsidian\]' "$CODEX_DIR/config.toml" 2>/dev/null; then
  info "Obsidian MCP still in $CODEX_DIR/config.toml ([mcp_servers.obsidian]): remove it by hand if you want."
fi

info "Codex uninstall done. Vault AI-Memory/ folder was NOT touched."
