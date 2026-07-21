#!/usr/bin/env bash
# Install global vault memory for Claude Code (and VS Code terminal).
# Safe to re-run: MERGES into existing ~/.claude config.
# Usage: bash install-claude-code.sh "/absolute/path/to/your vault"
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: install-claude-code.sh \"/path/to/vault\"}")"
[ -d "$VAULT/AI-Memory" ] || die "No AI-Memory/ folder in $VAULT — run install-vault.sh first."

write_vault_config "$VAULT"
mkdir -p ~/.claude/commands ~/.claude/hooks

# 1. Global rules
render_template "$OBSIDIAN_AI_MEMORY_ROOT/templates/global-rules.md" "$VAULT" > ~/.claude/CLAUDE-vault.md
touch ~/.claude/CLAUDE.md
if ! grep -q '@CLAUDE-vault.md' ~/.claude/CLAUDE.md 2>/dev/null; then
  backup_file ~/.claude/CLAUDE.md >/dev/null || true
  printf '\n@CLAUDE-vault.md\n' >> ~/.claude/CLAUDE.md
  info "Added @CLAUDE-vault.md to ~/.claude/CLAUDE.md"
else
  info "CLAUDE-vault.md already included in ~/.claude/CLAUDE.md"
fi

# 2. SessionStart hook script
HOOK_SCRIPT="$(install_vault_memory_hook "$HOME/.claude/hooks")"

# 3. Merge hook into settings.json (JSON-safe command path)
python3 - "$HOME/.claude/settings.json" "$HOOK_SCRIPT" <<'PY'
import json, os, shutil, sys
settings_path, hook_script = sys.argv[1], sys.argv[2]
new = {
    "hooks": [{
        "type": "command",
        "command": hook_script,
    }]
}
cur = {}
if os.path.exists(settings_path):
    shutil.copy(settings_path, settings_path + ".bak")
    with open(settings_path) as f:
        cur = json.load(f)
hooks = cur.setdefault("hooks", {}).setdefault("SessionStart", [])
hooks[:] = [h for h in hooks if "vault-memory" not in json.dumps(h)]
hooks.append(new)
with open(settings_path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"SessionStart vault hook merged into {settings_path}")
PY

# 4. Maintenance commands
cp "$OBSIDIAN_AI_MEMORY_ROOT/.claude/commands/"*.md ~/.claude/commands/
info "Copied /onboard, /organize, /rewrite to ~/.claude/commands/"

info "Claude Code global memory installed. Vault: $VAULT"
info "  Open any repo, run 'claude' — memory loads everywhere."
