# Obsidian vault memory for AI assistants

Use your **Obsidian vault** as long-term memory across **Claude Code**, **VS Code** (terminal), and **Cursor**. One vault, one `AI-Memory/` memory folder, multiple IDE integrations.

Setup once (~15 minutes). After that: **remember this**, **wrap up**, and your notes follow you into every project.

## Quick start

```bash
git clone <this-repo-url> obsidian-ai-memory
cd obsidian-ai-memory
bash install.sh
```

The installer will ask for:

1. **Vault path** — where your Obsidian notes live (e.g. `~/Documents/Obsidian/My Vault`)
2. **Platforms** — Claude Code, Cursor, or both
3. **Obsidian MCP** (Claude Code + Cursor, recommended) — better search and safer note edits

Then onboard once from your vault:

| Platform | Onboarding |
|----------|------------|
| Claude Code | `cd <vault>` → `claude` → `/onboard` |
| Cursor | Open vault or any repo → say **"onboard my vault"** |

## Prerequisites

| Tool | Required for |
|------|----------------|
| **git** | Clone kit, `/rewrite` safety snapshots |
| **Claude Code CLI** (`npm i -g @anthropic-ai/claude-code`) | Claude Code / VS Code terminal |
| **Node.js** (`npx`) | Obsidian MCP (optional, Claude Code + Cursor) |
| **Cursor** | Cursor integration only |

No database, no connector required. Obsidian MCP is optional but recommended for both Claude Code and Cursor.

## Day to day

| You say | Effect |
|---------|--------|
| **remember this** | Appended to the right vault note immediately |
| **wrap up** | Handoff rewritten, project note updated, daily log appended |
| **startup** | Reload memory and print the status table |

**Sharing rule:** the **why** (decisions, context, blockers) goes in the vault project note; the **what** (code) stays in the repo.

## Non-interactive install

```bash
bash install.sh \
  --vault "/Users/you/Documents/Obsidian/Obsidian Vault" \
  --platforms claude-code,cursor \
  --mcp yes
```

Flags: `--vault PATH`, `--platforms claude-code,cursor`, `--mcp yes|no|skip`

Quote vault paths that contain spaces. The path is stored in `~/.config/obsidian-ai-memory/vault` so hooks handle spaces safely.

## Documentation

- [Platform comparison](docs/platforms.md)
- [Claude Code](docs/claude-code.md)
- [VS Code](docs/vscode.md)
- [Cursor](docs/cursor.md)
- [Obsidian MCP](docs/obsidian-mcp.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Uninstall](docs/uninstall.md)

## What's in the vault

After install, your vault gains (existing notes untouched):

```
your-vault/
  CLAUDE.md              # vault advisor rules
  .claude/commands/      # /onboard, /organize, /rewrite (Claude Code)
  AI-Memory/
    Memory.md            # durable facts and decisions
    Next Session.md      # handoff for next session
    Vault Map.md         # your vault index (created by onboard)
    Projects/            # one note per active project
```
