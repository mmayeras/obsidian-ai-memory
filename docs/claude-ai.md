# claude.ai

claude.ai (web, desktop and mobile chats) does not run hooks and cannot read your Mac directly. It gets the vault through two custom skills plus a linked computer:

- **vault-memory**: at the start of a chat, runs `bash ~/.claude/hooks/vault-memory.sh` on your linked computer and follows the same rules as Claude Code, Cursor and Codex.
- **vault-wrap-up**: the "wrap up" handoff.

Requirements: the Claude Code install on that computer (it provides the hook script), and the computer linked to claude.ai.

## Build and upload (also after every rules change)

claude.ai keeps its own copy of each skill. Changing the repo or your local files does not update it: rebuild and re-upload.

```bash
bash scripts/build-claude-ai-skills.sh "/path/to/your vault"
# -> dist/claude-ai/vault-memory.zip and dist/claude-ai/vault-wrap-up.zip
```

On claude.ai: **Customize > Skills**, open each skill, replace it with its zip (first time: upload the zip as a new skill). Start a new chat.

Both skills are generated from `templates/global-rules.md` and `templates/cursor/skills/vault-wrap-up/SKILL.md`, so claude.ai gets exactly the rules the other tools get. Don't edit the zips by hand.

## The vault's CLAUDE.md

claude.ai does not load `CLAUDE.md` files. The vault-memory skill tells it to read the vault's `CLAUDE.md` when working inside the vault (onboarding, organizing, filing notes).

## Local copies

Claude Code syncs your claude.ai skills into `~/.claude/skills/synced/`. Those are read-only mirrors of the claude.ai version; editing them changes nothing on claude.ai and may be overwritten.
