---
description: Map the vault (structure, tags, conventions, daily notes) and seed AI memory. Read-only scan; writes only under AI-Memory/.
---
Run from the vault root. Scan the whole vault read-only; write ONLY under `AI-Memory/`.

**Vault access:** If Obsidian MCP is available, use `list_directory`, `read_note`, `search_notes`. Otherwise use shell (`ls`, `cat`, `grep`).

1. Map the structure: list top-level folders, sample a few notes in each, record naming conventions and frontmatter tags actually in use.
2. Detect daily notes from `.obsidian/daily-notes.json` (folder, filename format, template). Read the 5 most recent dailies.
3. Identify customer notes, work/tech notes, active projects, and templates.
4. Write `AI-Memory/Vault Map.md`: purpose of each folder, naming and tag conventions, daily note location and exact filename format, and where each type of new note belongs. Mark every deduction with `(?)` for me to confirm.
5. Seed `AI-Memory/Memory.md` from real notes (role, focus areas, recurring context), marking deductions `(?)`. Never overwrite lines I already confirmed.
6. Create one note per active project in `AI-Memory/Projects/`, copied from `_project-template.md`.
7. Finish by listing everything written and every `(?)` awaiting my confirmation.
