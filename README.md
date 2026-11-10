# Obsidian vault memory for AI assistants

Use your **Obsidian vault** as long-term memory for **Claude Code**, **VS Code** (terminal), **Cursor**, **Codex** and **ChatGPT**. One vault, one `AI-Memory/` folder, every assistant.

Set it up once (about 15 minutes). After that, say **remember this** and **wrap up**, and your notes follow you into every project.

## How it works

AI assistants forget everything when a chat ends. This kit gives them a notebook: the `AI-Memory/` folder in your vault.

1. **When a chat starts**, a small script (a "hook") reads the notebook's front page and hands it to the assistant before you type anything:
   - `Memory.md`: who you are, your rules, and where details live
   - `Next Session.md`: where you left off and what to do next
   - today's daily note
2. **During the chat**, the assistant looks things up in the vault only when it needs them (Obsidian MCP, or plain search). Say **remember this** and it writes the fact down right away.
3. **When you finish**, say **wrap up**. It writes a short handoff for next time, updates the project note, and adds a few lines to your daily note.

The next chat, in any repo and any supported tool, picks up from there.

## How it saves time and tokens

**Time:** you stop re-explaining your setup, your customers and your past decisions at the start of every chat. The assistant answers "did I already deal with this?" from your notes, and each session starts from the next action written at the last wrap-up.

**Tokens:** everything loaded at the start of a chat is paid for again in every chat. So the kit loads as little as possible up front and fetches the rest only when a topic comes up.

| Design choice | What it means |
|---|---|
| Small front page | `Memory.md` is an index: about you, your rules, pointers. Details live in project notes and `AI-Memory/Reference/`, read only when needed. |
| Vault Map read on demand | The map of your vault (folders, naming, tags) is read before a search or before filing a note, not at every start. |
| Short handoff | `Next Session.md` stays under about 30 lines. |
| Daily note capped | Only the first 60 lines are loaded (change with `OBSIDIAN_AI_MEMORY_MAX_DAILY_LINES`). |
| Silent start | No status table, no recap: the assistant answers your first message directly and mentions memory only when it matters. |
| Compact rules | Global rules are about 3.5 KB; the vault's own `CLAUDE.md` adds only vault-specific rules instead of repeating them. |

Example from a real vault (November 2026): the context loaded at each chat start went from about 50 KB (about 12,000 tokens) to about 8 KB (about 2,000 tokens), with no notes lost. Details were moved into project and reference notes, not deleted.

## Quick start

```bash
git clone <this-repo-url> obsidian-ai-memory
cd obsidian-ai-memory
bash install.sh
```

The installer asks for:

1. **Vault path**: where your Obsidian notes live (for example `~/Documents/Obsidian/My Vault`)
2. **Platforms**: Claude Code, Cursor, Codex, or several (it pre-selects the ones it finds). ChatGPT setup is manual.
3. **Obsidian MCP** (recommended): faster, targeted vault search and safer note edits

Then onboard once from your vault. Onboarding scans the vault and writes the Vault Map:

| Platform | Onboarding |
|----------|------------|
| Claude Code | `cd <vault>` → `claude` → `/onboard` |
| Cursor | Open the vault or any repo → say **"onboard my vault"** |
| Codex | Restart Codex, approve the vault hook when asked → say **"onboard my vault"** |
| ChatGPT | Create a Project, add `templates/chatgpt/project-instructions.md` as its instructions, connect an Obsidian tool if available, then ask it to **"onboard my vault"** |

## Prerequisites

| Tool | Required for |
|------|----------------|
| **git** | Clone the kit, `/rewrite` safety snapshots |
| **Python 3** | Installers (safe JSON and text edits) |
| **Claude Code CLI** (`npm i -g @anthropic-ai/claude-code`) | Claude Code / VS Code terminal |
| **Cursor** | Cursor integration |
| **Codex** (CLI or desktop app) | Codex integration |
| **Node.js** (`npx`) | Obsidian MCP (optional) |

No database, no cloud service. Obsidian MCP is optional but recommended.

## Day to day

| You say | Effect |
|---------|--------|
| **remember this** | Written to the right vault note immediately |
| **wrap up** | Handoff rewritten, project note updated, daily log appended |
| **startup** | Only if memory seems missing: reload it and reply with a 3-line status |
| **onboard a customer** | Interview for contacts, virtual account team and key links; fills `Customers/<Name>/Info/Account Overview.md` |

**Sharing rule:** the **why** (decisions, context, blockers) goes in the vault project note; the **what** (code) stays in the repo.

## Non-interactive install

```bash
bash install.sh \
  --vault "/Users/you/Documents/Obsidian/Obsidian Vault" \
  --platforms claude-code,cursor,codex \
  --mcp yes
```

Flags: `--vault PATH`, `--platforms claude-code,cursor,codex`, `--mcp yes|no|skip`

Quote vault paths that contain spaces. The path is stored in `~/.config/obsidian-ai-memory/vault`, so hooks handle spaces safely. Re-running the installer is safe: it merges into existing config and keeps `.bak` copies.

**Upgrading:** re-running never overwrites your vault's `CLAUDE.md`. If the installer warns that it is from an older version, refresh it with `bash scripts/install-vault.sh "/path/to/vault" --update-rules` (the old file is kept as `CLAUDE.md.bak`). claude.ai skills are uploaded by hand: see [claude.ai](docs/claude-ai.md).

## Documentation

- [Platform comparison](docs/platforms.md)
- [Claude Code](docs/claude-code.md)
- [VS Code](docs/vscode.md)
- [Cursor](docs/cursor.md)
- [Codex](docs/codex.md)
- [claude.ai](docs/claude-ai.md)
- [ChatGPT setup](docs/chatgpt.md)
- [Obsidian MCP](docs/obsidian-mcp.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Uninstall](docs/uninstall.md)

## What's in the vault

After install, your vault gains (existing notes untouched):

```
your-vault/
  CLAUDE.md              # vault-specific assistant rules
  .claude/commands/      # /onboard, /organize, /rewrite, /customer-onboard (Claude Code)
  AI-Memory/
    Memory.md            # small index: about you, rules, pointers (loaded every chat)
    Next Session.md      # short handoff for the next chat (loaded every chat)
    Vault Map.md         # your vault index, written by onboard (read on demand)
    Projects/            # one note per project: status, decisions, next steps
    Reference/           # tech facts and other details (read on demand)
    Sessions/            # optional longer session summaries
```
