#!/usr/bin/env bash
# Build upload-ready claude.ai skills (vault-memory, vault-wrap-up) from the repo templates.
# claude.ai skills are uploaded by hand: Customize > Skills > the skill > replace with the zip.
# Usage: bash build-claude-ai-skills.sh "/absolute/path/to/your vault" [out_dir]
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

VAULT="$(resolve_vault "${1:?Usage: build-claude-ai-skills.sh \"/path/to/vault\" [out_dir]}")"
OUT="${2:-$OBSIDIAN_AI_MEMORY_ROOT/dist/claude-ai}"
T="$OBSIDIAN_AI_MEMORY_ROOT/templates"
command -v zip >/dev/null 2>&1 || die "zip not found"

rm -rf "$OUT"
mkdir -p "$OUT/vault-memory" "$OUT/vault-wrap-up"

# vault-memory = claude.ai header + the same global rules Claude Code, Cursor and Codex get (minus its H1).
{
  render_template "$T/claude-ai/vault-memory-header.md" "$VAULT"
  render_template "$T/global-rules.md" "$VAULT" | sed '1{/^# /d;}'
} > "$OUT/vault-memory/SKILL.md"

# vault-wrap-up = the shared wrap-up skill + a note on reaching the vault from the cloud.
python3 - "$T/cursor/skills/vault-wrap-up/SKILL.md" "$T/claude-ai/vault-wrap-up-cloud.md" "$OUT/vault-wrap-up/SKILL.md" <<'PY'
import sys
skill, cloud, out = sys.argv[1:]
text, note = open(skill).read(), open(cloud).read()
anchor = "When I say **\"wrap up\"**"
assert text.count(anchor) == 1, "wrap-up template changed: update build-claude-ai-skills.sh"
open(out, "w").write(text.replace(anchor, note + anchor))
PY

(cd "$OUT" && zip -qr vault-memory.zip vault-memory && zip -qr vault-wrap-up.zip vault-wrap-up)
info "Built claude.ai skills in $OUT:"
info "  vault-memory.zip, vault-wrap-up.zip"
info "Upload each on claude.ai (Customize > Skills > open the skill > replace), then start a new chat."
