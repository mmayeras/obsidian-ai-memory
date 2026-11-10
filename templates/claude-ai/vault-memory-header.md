---
name: vault-memory
description: "Load the user's Obsidian vault memory at the START of every session before the first answer, and on \"startup\", \"remember this\", or questions about customers or past work."
---

# Vault memory (claude.ai)

Generated from obsidian-ai-memory `templates/global-rules.md` by `scripts/build-claude-ai-skills.sh`. Change the template, rebuild, re-upload: don't edit this copy.

## Reaching the vault from claude.ai
- The vault is on my computer, never in a cloud container. Use the linked computer: its shell, or Obsidian MCP tools if present. If it isn't linked or reachable, say so in one line and carry on without memory.
- Startup: run `bash ~/.claude/hooks/vault-memory.sh` on that computer. Its output is what the "SessionStart hook" injects in the rules below (Memory, Next Session, today's daily note, project list).
- Working inside the vault (onboarding, organizing, filing notes): also read `__VAULT__/CLAUDE.md` for the vault-only rules.
- "wrap up": use the vault-wrap-up skill.

