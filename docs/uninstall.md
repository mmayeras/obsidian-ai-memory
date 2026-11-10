# Uninstall

Uninstall removes IDE integration only. Your vault `AI-Memory/` folder and notes are **never deleted**.

## Claude Code

```bash
bash scripts/uninstall-claude-code.sh
```

Removes:

- `@CLAUDE-vault.md` include from `~/.claude/CLAUDE.md`
- `~/.claude/CLAUDE-vault.md`
- SessionStart vault hook from `~/.claude/settings.json`
- `~/.claude/hooks/vault-memory.sh`

Does **not** remove `~/.claude/commands/` (onboard, organize, rewrite) — delete manually if desired.

## Cursor

```bash
bash scripts/uninstall-cursor.sh
```

Removes:

- `~/.cursor/rules/vault-memory.mdc`
- `~/.cursor/hooks/vault-memory.sh` and `vault-memory-cursor.sh`
- sessionStart vault hook from `~/.cursor/hooks.json`
- Skills: `vault-onboard`, `vault-organize`, `vault-rewrite`, `vault-wrap-up`

Prompts whether to also remove the `obsidian` MCP entry from `~/.cursor/mcp.json`.

## Codex

```bash
bash scripts/uninstall-codex.sh
```

Removes:

- the `BEGIN/END OBSIDIAN AI MEMORY` block from `~/.codex/AGENTS.md` (the rest of the file is kept)
- the vault SessionStart entry from `~/.codex/hooks.json` and `~/.codex/hooks/vault-memory.sh`
- Skills in `~/.agents/skills`: `vault-onboard`, `vault-organize`, `vault-rewrite`, `vault-wrap-up`

Offers to remove the `obsidian` MCP server (with the `codex` CLI); otherwise tells you where it is in `~/.codex/config.toml`.

## Vault kit

To remove obsidian-ai-memory files from the vault itself (optional):

```bash
# Only if you want to remove the kit — your memory notes will be deleted!
rm -f "/path/to/vault/CLAUDE.md"
rm -rf "/path/to/vault/.claude"
# Keep AI-Memory/ if you want to preserve Memory.md, project notes, etc.
```

Most users keep `AI-Memory/` — it is your memory archive.

## Full reinstall

```bash
bash install.sh --vault "/path/to/vault" --platforms claude-code,cursor,codex --mcp yes
```

Safe to re-run anytime.
