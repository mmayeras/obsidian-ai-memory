---
name: vault-wrap-up
description: End-of-session handoff — rewrite Next Session, update project notes, log to daily. Use when the user says wrap up or the session is clearly ending.
---

## Vault access

If Obsidian MCP is available, use `read_note`, `write_note`, and `patch_note` (mode append where appropriate). Otherwise use shell file tools.

When I say **"wrap up"** (or the session is clearly ending):

1. Rewrite `AI-Memory/Next Session.md` from scratch: summary, open loops, exact next actions. Write it for a future you with zero memory. Mention the current repo path if we worked in one.
2. Update the project note(s) we touched (status, decisions, next steps).
3. Append durable facts/decisions to `AI-Memory/Memory.md`.
4. Append a 2-3 line session log to TODAY'S daily note under `## AI` (create today's note from the usual template if missing). Never edit my own daily entries.
5. If substantial, copy the summary to `AI-Memory/Sessions/YYYY-MM-DD.md`.
6. Confirm in 2 lines what you saved and where.

Decisions format: `- YYYY-MM-DD — decision — because reasoning — rejected: alternatives`
