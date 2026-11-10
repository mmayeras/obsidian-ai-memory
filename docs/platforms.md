# Platform comparison

One Obsidian vault (`AI-Memory/` folder) is shared across all platforms.

| Capability | Claude Code | VS Code | Cursor | Codex | ChatGPT |
|------------|-------------|---------|--------|-------|----------|
| **How you use it** | `claude` in terminal | `claude` in integrated terminal | Cursor Agent chat | Codex CLI or desktop app | ChatGPT Project |
| **Memory loading** | SessionStart hook | Same as Claude Code | Hook + user rule + MCP read (hook best-effort) | SessionStart hook (approve it once) | Project instructions ask it to read the vault at the start of each new chat; no automatic startup hook |
| **Rules** | `~/.claude/CLAUDE-vault.md` | Same | `~/.cursor/rules/vault-memory.mdc` | Block in `~/.codex/AGENTS.md` | Paste `templates/chatgpt/project-instructions.md` into Project settings |
| **Maintenance workflows** | `/onboard`, `/organize`, `/rewrite` | Same | Skills: "onboard my vault", etc. | Skills in `~/.agents/skills` | Ask in Project chat; review proposed changes |
| **Vault search and writes** | shell / grep | shell / grep | Obsidian MCP preferred, shell fallback | Obsidian MCP preferred, shell fallback | Connected Obsidian app/tool when available; otherwise uploaded snapshots and user-applied edits |
| **Obsidian MCP** | Optional (manual) | N/A | Recommended via installer | Recommended via installer | Depends on ChatGPT client, plan, and workspace; local-only MCP is not directly reachable |
| **Install script** | `install.sh` or `scripts/install-claude-code.sh` | No extra step | `install.sh` or `scripts/install-cursor.sh` | `install.sh` or `scripts/install-codex.sh` | Manual Project setup; no installer |

## Which platform should I use?

- **Coding in terminal** → Claude Code (any editor) + optional Obsidian MCP
- **Already in VS Code** → same Claude Code setup; no separate VS Code install
- **Cursor Agent UI** → Cursor install + optional Obsidian MCP
- **Codex** → Codex install + optional Obsidian MCP ([Codex](codex.md))
- **Vault advisor mode** (customer research, no repo) → run from vault root with either tool
- **ChatGPT** → use a Project with [ChatGPT setup](chatgpt.md) and verify live Obsidian access before relying on or editing the vault

## Shared phrases

All platforms understand:

- **remember this** — append to Memory or project note
- **wrap up** — end-of-session handoff
- **startup** — reload memory if it seems missing (3-line status; there is no startup table)

## Vault location

The vault path is set once during `bash install.sh` (quote paths with spaces). It is stored in `~/.config/obsidian-ai-memory/vault` and referenced by:

- `~/.config/obsidian-ai-memory/vault` — canonical path (hooks read this)
- `~/.claude/hooks/vault-memory.sh` (Claude Code)
- `~/.claude/CLAUDE-vault.md` (rules)
- `~/.cursor/rules/vault-memory.mdc` (rules)
- `~/.cursor/hooks/vault-memory.sh` (Cursor)
- `~/.codex/hooks/vault-memory.sh`, `~/.codex/AGENTS.md` (Codex)
- `~/.codex/config.toml` → `[mcp_servers.obsidian]` (Codex, if MCP installed)
- `~/.cursor/mcp.json` → `obsidian` server args (Cursor, if MCP installed)
- `~/.claude.json` → `obsidian` user-scope server args (Claude Code, if MCP installed; managed via `claude mcp`)

Re-run `bash install.sh` after moving your vault to update paths.
