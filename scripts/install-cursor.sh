#!/usr/bin/env bash
# Install global vault memory for Cursor (rules, hooks, skills).
# Safe to re-run: MERGES into existing ~/.cursor config.
# Usage: bash install-cursor.sh "/absolute/path/to/your vault"
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: install-cursor.sh \"/path/to/vault\"}")"
[ -d "$VAULT/AI-Memory" ] || die "No AI-Memory/ folder in $VAULT — run install-vault.sh first."

write_vault_config "$VAULT"
mkdir -p ~/.cursor/rules ~/.cursor/hooks ~/.cursor/skills

# 1. User rule (alwaysApply)
{
  cat "$OBSIDIAN_AI_MEMORY_ROOT/templates/cursor/vault-memory.mdc"
  render_template "$OBSIDIAN_AI_MEMORY_ROOT/templates/global-rules.md" "$VAULT"
} > ~/.cursor/rules/vault-memory.mdc
info "Wrote ~/.cursor/rules/vault-memory.mdc"

# 2. Hook scripts
install_vault_memory_hook "$HOME/.cursor/hooks" >/dev/null
cp "$OBSIDIAN_AI_MEMORY_ROOT/templates/cursor/vault-memory-cursor.sh" \
  "$HOME/.cursor/hooks/vault-memory-cursor.sh"
chmod +x "$HOME/.cursor/hooks/vault-memory-cursor.sh"
info "Installed ~/.cursor/hooks/vault-memory.sh and vault-memory-cursor.sh"

# 3. Merge sessionStart into hooks.json
python3 - "$HOME/.cursor/hooks.json" <<'PY'
import json, os, shutil, sys
settings_path = sys.argv[1]
new_hook = {"command": "./hooks/vault-memory-cursor.sh"}
cur = {"version": 1, "hooks": {}}
if os.path.exists(settings_path):
    shutil.copy(settings_path, settings_path + ".bak")
    with open(settings_path) as f:
        cur = json.load(f)
cur.setdefault("version", 1)
hooks = cur.setdefault("hooks", {})
session = hooks.setdefault("sessionStart", [])
session[:] = [h for h in session if "vault-memory" not in json.dumps(h)]
session.append(new_hook)
with open(settings_path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"sessionStart vault hook merged into {settings_path}")
PY

# 4. Skills
for skill_dir in "$OBSIDIAN_AI_MEMORY_ROOT/templates/cursor/skills/"*/; do
  name=$(basename "$skill_dir")
  dest="$HOME/.cursor/skills/$name"
  mkdir -p "$dest"
  cp "$skill_dir/SKILL.md" "$dest/SKILL.md"
  info "  skill: $name"
done

info "Cursor global memory installed. Vault: $VAULT"
info "  Restart Cursor if it is open. Say 'startup' if memory seems missing."
