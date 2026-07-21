# Obsidian MCP (optional, recommended)

Obsidian MCP is **not required**. Shell and grep always work. MCP is **recommended** for both Cursor and Claude Code because it provides safer, frontmatter-aware vault operations.

## Why use it

| Task | MCP | Shell fallback |
|------|-----|----------------|
| Search vault | `search_notes` — content + frontmatter | `grep -ril` |
| Read notes | `read_note`, `read_multiple_notes` | `cat` / Read tool |
| Append ("remember this") | `write_note` mode `append` | shell redirect |
| Surgical edit | `patch_note` | manual file edit |
| List folders | `list_directory` | `ls` |

## Install via obsidian-ai-memory

Included when you run:

```bash
bash install.sh --mcp yes
```

Or separately, targeting one or both platforms (`cursor` | `claude-code` | `both`, default `both`):

```bash
bash scripts/install-obsidian-mcp.sh "/path/to/your/vault"              # both
bash scripts/install-obsidian-mcp.sh "/path/to/your/vault" claude-code  # Claude Code only
bash scripts/install-obsidian-mcp.sh "/path/to/your/vault" cursor       # Cursor only
```

The two platforms store MCP config differently, so the script uses the right mechanism for each:

- **Cursor** — merges an `obsidian` entry into `~/.cursor/mcp.json` (comments preserved):

  ```json
  "obsidian": {
    "type": "stdio",
    "command": "/path/to/npx",
    "args": ["-y", "@bitbonsai/mcpvault@latest", "/path/to/your/vault"]
  }
  ```

- **Claude Code** — runs `claude mcp add -s user obsidian -- npx -y @bitbonsai/mcpvault@latest "<vault>"`. **User scope** means it's available in every repo you open, matching the global vault-memory design. Config lives in `~/.claude.json` — managed by the CLI, not hand-edited.

## Manual install

**Cursor:**
1. Install Node.js (`brew install node`)
2. Edit `~/.cursor/mcp.json` with the block above (use your vault's absolute path)
3. Restart Cursor
4. Open **Settings → MCP** and confirm `obsidian` shows as connected

**Claude Code:**
1. Install Node.js (`brew install node`)
2. Run: `claude mcp add -s user obsidian -- "$(command -v npx)" -y @bitbonsai/mcpvault@latest "/path/to/your/vault"`
3. Verify: `claude mcp get obsidian` → `Status: ✔ Connected`

## Verify

- **Claude Code:** `claude mcp get obsidian` shows `✔ Connected`. In a session, the `read_note` / `search_notes` / `write_note` / `patch_note` tools are available.
- **Cursor:** in Agent chat, ask the agent to run `get_vault_stats` via Obsidian MCP. You should see note counts and recent files.

## Package

- **npm:** `@bitbonsai/mcpvault`
- **Transport:** stdio via `npx`

## Grep fallback

MCP is optional. Without it, both platforms fall back to shell/grep on vault paths (see the table above) — same results, less ergonomic. Skip MCP with `--mcp no` if you want zero Node dependency.

## Uninstall MCP only

- **Cursor:** `bash scripts/uninstall-cursor.sh` — choose yes when prompted to remove the `obsidian` entry, or delete the `obsidian` key from `~/.cursor/mcp.json`.
- **Claude Code:** `claude mcp remove obsidian -s user` (also removed by `bash scripts/uninstall-claude-code.sh`).

## Troubleshooting

| Issue | Fix |
|-------|-----|
| MCP not listed (Cursor) | Restart Cursor; check `mcp.json` syntax |
| MCP not connected (Claude Code) | `claude mcp get obsidian`; if missing, re-run the installer |
| Tools absent in current Claude session | MCP is picked up at session start — restart `claude` (VSCode extension: reload the window / start a new session; long-running or resumed sessions keep the tool set they started with) |
| `claude mcp list` shows ✔ Connected but session has no vault tools | Same cause — the session predates the server or was resumed/compacted; the agent should fall back to shell/grep for this session and note it |
| `npx` not found | Install Node.js |
| Wrong vault path | Re-run `bash scripts/install-obsidian-mcp.sh "/correct/path" <target>` |
| Auth errors | This MCP uses local vault files — no cloud auth required |
