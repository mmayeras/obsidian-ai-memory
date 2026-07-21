# Troubleshooting

## General

| Symptom | Fix |
|---------|-----|
| No startup table | Normal occasionally — model behavior. Say **startup** to force it. Hook injection is separate and may still have loaded memory. |
| "run onboard" in table | Run onboard once: `/onboard` (Claude Code) or "onboard my vault" (Cursor) |
| Wrong vault path | Re-run `bash install.sh --vault "/correct/path with spaces"` |
| Re-install safe | All installers are idempotent; backups written as `*.bak` |

## AI Code

| Symptom | Fix |
|---------|-----|
| Hook loads nothing | Check `~/.claude/hooks/vault-memory.sh` exists and `~/.claude/settings.json` has SessionStart entry |
| `/doctor` reports `hooks.SessionStart.0.hooks.0.type`: Invalid input | Extra nesting in settings.json from an old install. Re-run `bash scripts/install-claude-code.sh` to fix, or manually remove the inner `hooks` wrapper so each entry has `type`/`command` directly. |
| Permission to read vault | Accept on first access outside repo — normal |
| Custom hooks overwritten | They should be merged, not replaced. Check `~/.claude/settings.json.bak` |
| Uninstall | `bash scripts/uninstall-claude-code.sh` |

## Cursor

| Symptom | Fix |
|---------|-----|
| Agent unaware of memory despite hook | Known issue: `sessionStart` `additional_context` may not reach the agent. Say **startup**; ensure Obsidian MCP is installed so the rule can read vault files |
| Hook runs but no context | Check **Hooks** output channel; verify `~/.cursor/hooks/vault-memory-cursor.sh` is executable |
| Rules not applied | Confirm `~/.cursor/rules/vault-memory.mdc` exists with `alwaysApply: true` |
| MCP tools missing | Restart Cursor; check `~/.cursor/mcp.json`; see [obsidian-mcp.md](obsidian-mcp.md) |
| Skills not triggering | Skills live in `~/.cursor/skills/vault-*`; re-run `bash scripts/install-cursor.sh` |

## Vault

| Symptom | Fix |
|---------|-----|
| No `AI-Memory/` folder | Run `bash scripts/install-vault.sh "/path/to/vault"` |
| Memory files empty | Run onboard |
| Daily note not found | Check `AI-Memory/Vault Map.md` for daily note path/format; create today's note in Obsidian |

## Backups

Installers create backups before modifying config:

- `~/.claude/CLAUDE.md.bak`
- `~/.claude/settings.json.bak`
- `~/.cursor/hooks.json.bak`
- `~/.cursor/mcp.json.bak`

Restore from `.bak` if something goes wrong.
