# VS Code

VS Code uses the **same setup as Claude Code**. There is no separate VS Code installer.

## Setup

1. Install Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
2. Run `bash install.sh` and select **claude-code** (or both platforms)
3. Onboard once from your vault (see [claude-code.md](claude-code.md))

## Usage

1. Open any project in VS Code as usual
2. Open the integrated terminal
3. Run `claude`

Memory loads via the global Claude Code SessionStart hook — same behavior as running `claude` in any terminal.

## Phrases

- **remember this** — save to vault
- **wrap up** — end-of-session handoff
- **startup** — reload memory table

## Notes

- VS Code does not use Cursor rules, hooks, or Obsidian MCP
- Vault I/O uses shell/grep (zero extra dependencies)
- Project-local `CLAUDE.md` in repos still applies and adds to global vault rules
