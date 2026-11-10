#!/usr/bin/env bash
# Install global vault memory for Codex (CLI and desktop app).
# Safe to re-run: merges into ~/.codex/hooks.json and replaces only the marked
# block in ~/.codex/AGENTS.md (the rest of that file is left alone).
# Usage: bash install-codex.sh "/absolute/path/to/your vault"
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: install-codex.sh \"/path/to/vault\"}")"
[ -d "$VAULT/AI-Memory" ] || die "No AI-Memory/ folder in $VAULT — run install-vault.sh first."

CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$HOME/.agents/skills"   # user-level skills folder Codex reads

write_vault_config "$VAULT"
mkdir -p "$CODEX_DIR" "$SKILLS_DIR"

# 1. Global rules: rendered into a marked block of ~/.codex/AGENTS.md
#    (Codex does not expand @includes, so the rules are inlined).
RULES_TMP="$(mktemp)"
trap 'rm -f "$RULES_TMP"' EXIT
render_template "$OBSIDIAN_AI_MEMORY_ROOT/templates/global-rules.md" "$VAULT" > "$RULES_TMP"
python3 - "$CODEX_DIR/AGENTS.md" "$RULES_TMP" <<'PY'
import os, re, shutil, sys
path, rules_file = sys.argv[1], sys.argv[2]
rules = open(rules_file).read().rstrip("\n")
block = ("<!-- BEGIN OBSIDIAN AI MEMORY (rendered from obsidian-ai-memory templates/global-rules.md) -->\n"
         + rules + "\n<!-- END OBSIDIAN AI MEMORY -->")
cur = ""
if os.path.exists(path):
    shutil.copy(path, path + ".bak")
    cur = open(path).read()
pattern = re.compile(r"<!-- BEGIN OBSIDIAN AI MEMORY.*?-->.*?<!-- END OBSIDIAN AI MEMORY -->", re.S)
if pattern.search(cur):
    new = pattern.sub(lambda m: block, cur, count=1)
    action = "updated"
else:
    new = (cur.rstrip("\n") + "\n\n" if cur.strip() else "") + block + "\n"
    action = "added"
with open(path, "w") as f:
    f.write(new)
print(f"Vault rules block {action} in {path}")
PY

# 2. SessionStart hook: absolute path to the plain-text script (Codex adds stdout to context).
HOOK_SCRIPT="$(install_vault_memory_hook "$CODEX_DIR/hooks")"
# Older manual setups pointed Codex at the Cursor JSON wrapper via a relative path, which never ran.
rm -f "$CODEX_DIR/hooks/vault-memory-cursor.sh"
python3 - "$CODEX_DIR/hooks.json" "$HOOK_SCRIPT" <<'PY'
import json, os, shutil, sys
path, hook_script = sys.argv[1], sys.argv[2]
new = {"hooks": [{
    "type": "command",
    "command": hook_script,
    "timeout": 10,
    "statusMessage": "Loading vault memory",
}]}
cur = {}
if os.path.exists(path):
    shutil.copy(path, path + ".bak")
    with open(path) as f:
        cur = json.load(f)
session = cur.setdefault("hooks", {}).setdefault("SessionStart", [])
session[:] = [h for h in session if "vault-memory" not in json.dumps(h)]
session.append(new)
with open(path, "w") as f:
    json.dump(cur, f, indent=2)
    f.write("\n")
print(f"SessionStart vault hook merged into {path}")
PY

# 3. Skills (onboard, organize, rewrite, wrap-up, customer-onboard)
for skill_dir in "$OBSIDIAN_AI_MEMORY_ROOT/templates/cursor/skills/"*/; do
  name=$(basename "$skill_dir")
  mkdir -p "$SKILLS_DIR/$name"
  cp "$skill_dir/SKILL.md" "$SKILLS_DIR/$name/SKILL.md"
  info "  skill: $name"
done

info "Codex global memory installed. Vault: $VAULT"
info "  Restart Codex. It asks you to trust the new or changed vault hook once: approve it,"
info "  otherwise the memory is not loaded."
