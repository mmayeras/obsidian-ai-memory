---
name: vault-rewrite
description: Standardize existing vault notes in batches of 5 with before/after preview. Use when the user says rewrite vault notes or run rewrite.
---

## Vault access

If Obsidian MCP is available, use `read_note` and `write_note` for edits. Otherwise use shell file tools.

1. Require a git snapshot first: `git add -A && git commit -m "pre-rewrite snapshot"`. If the vault is not a git repo, stop and say so — proceed only if I explicitly waive the snapshot.
2. Pick the next batch of 5 notes that don't match the conventions in `AI-Memory/Vault Map.md`. NEVER touch daily notes, `AI-Memory/`, `.obsidian/`, or templates.
3. For each note show a before/after preview (frontmatter, headings, tags). Content is preserved word for word — only formatting and structure change.
4. Apply only after I approve the batch, then offer the next batch.
