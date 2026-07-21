---
name: vault-organize
description: Propose a numbered vault reorganization plan; apply only approved items; fix backlinks on moves. Use when the user says organize my vault or run organize.
---

## Vault access

If Obsidian MCP is available, use `search_notes`, `read_note`, `move_note`, and `patch_note` for backlink updates. Otherwise use shell `grep`, `mv`, and file edits.

1. Compare the vault against the conventions in `AI-Memory/Vault Map.md`; find misfiled or orphan notes.
2. Present a numbered plan, one action per line (move / rename / tag / index note). Make NO changes yet.
3. Apply ONLY the numbers I approve.
4. For every approved move or rename: find all `[[backlinks]]` to the old name and path, move the file, update every backlink, then verify zero broken links remain.
5. Prefer MOC/index notes and tags over moving files. Never delete a note. Never touch `.obsidian/` or daily notes.
6. Update `AI-Memory/Vault Map.md` to reflect what was applied.
