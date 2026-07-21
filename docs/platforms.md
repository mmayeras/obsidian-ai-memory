# Platform comparison

One Obsidian vault (`AI-Memory/` folder) is shared across all platforms.

| Capability | Claude Code | VS Code | Cursor |
|------------|-------------|---------|--------|
| **How you use it** | `claude` in terminal | `claude` in integrated terminal | Cursor Agent chat |
| **Memory injection** | SessionStart hook (reliable) | Same as Claude Code | Hook + user rule + MCP read (hook best-effort) |
| **Global rules** | `~/.claude/CLAUDE-vault.md` | Same | `~/.cursor/rules/vault-memory.mdc` |
| **Maintenance workflows** | `/onboard`, `/organize`, `/rewrite` | Same | Skills: "onboard my vault", etc. |
| **Vault search** | `grep` / shell | `grep` / shell | Obsidian MCP preferred, shell fallback |
| **Vault writes** | shell append / edit | shell append / edit | MCP `write_note` / `patch_note` preferred |
| **Obsidian MCP** | Optional (manual) | N/A | Recommended via installer |
| **Install script** | `install.sh` or `scripts/install-claude-code.sh` | No extra step | `install.sh` or `scripts/install-cursor.sh` |

## Which platform should I use?

- **Coding in terminal** → Claude Code (any editor) + optional Obsidian MCP
- **Already in VS Code** → same Claude Code setup; no separate VS Code install
- **Cursor Agent UI** → Cursor install + optional Obsidian MCP
- **Vault advisor mode** (customer research, no repo) → run from vault root with either tool

## Shared phrases

All platforms understand:

- **remember this** — append to Memory or project note
- **wrap up** — end-of-session handoff
- **startup** — force memory reload and status table

## Vault location

The vault path is set once during `bash install.sh` (quote paths with spaces). It is stored in `~/.config/obsidian-ai-memory/vault` and referenced by:

- `~/.config/obsidian-ai-memory/vault` — canonical path (hooks read this)
- `~/.claude/hooks/vault-memory.sh` (Claude Code)
- `~/.claude/CLAUDE-vault.md` (rules)
- `~/.cursor/rules/vault-memory.mdc` (rules)
- `~/.cursor/hooks/vault-memory.sh` (Cursor)
- `~/.cursor/mcp.json` → `obsidian` server args (Cursor, if MCP installed)
- `~/.claude.json` → `obsidian` user-scope server args (Claude Code, if MCP installed; managed via `claude mcp`)

Re-run `bash install.sh` after moving your vault to update paths.
