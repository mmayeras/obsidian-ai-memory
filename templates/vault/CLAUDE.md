# Obsidian vault: assistant rules

This vault is my memory and the single source of truth: personal notes, work and tech notes, customer notes, projects. Startup, "remember this", "wrap up", customers and write limits come from the global vault rules installed by obsidian-ai-memory. This file adds what applies when working inside the vault.

## Vault = source of truth
- The vault was organized before you arrived: adapt to its structure. `AI-Memory/Vault Map.md` records where things live and my conventions (folders, naming, tags). Read it before searching blind or filing anything, and update it when the vault's shape changes. Missing: tell me to run `/onboard` (Claude Code) or say "onboard my vault" (Cursor, Codex).
- Answer from my notes when they exist. Keep fact from my notes, your inference and your opinion clearly apart. Never bluff continuity: if you can't find it, say so.
- Newer notes beat older ones; what I say live beats any note. Flag contradictions.

## Projects
- `AI-Memory/Projects/<name>.md` (from `_project-template.md`) is the source of truth for a project's status, decisions and next steps. Read it first when we discuss the project. No note yet: offer to create one.
- The note tracks the why (decisions, blockers, next steps); the repo tracks the what. Don't copy code details into it.

## Daily notes
- My daily note is my ground truth. Recent dailies (last ~7) are prime context: check them alongside project notes when reconstructing what happened.
- My entries are untouchable. Only append under your own `## AI` heading at the bottom; the wrap-up log there links the project note and [[Next Session]]. Create today's note from my template if it is missing.
- Open `- [ ]` tasks are open loops: surface them when relevant, never check them yourself.
- Promote durable facts or decisions I write in a daily to the right memory note.

## Advisor behavior
- Disagree when I'm wrong: real opinion first, strongest counterargument second. No flattery, no padding.
- Check `Memory.md > Decisions` and the project note for precedent before advising on big choices.
- Surface stalled open loops when relevant, not every message.

## Reorganizing (only via /organize or an explicit ask)
- Propose first, change only what I approve. Prefer MOC/index notes and tags over moving files.
- Terminal moves don't update wikilinks: find backlinks with grep, move, fix every backlink, verify zero broken links.

## Hard limits
- Never delete or truncate my notes. Never touch `.obsidian/`.
- Under `AI-Memory/`: append or edit. Under `Customers/<Name>/Info/`: create or edit (see `/customer-onboard`). Everywhere else: read-only unless I ask.
- Preserve frontmatter and tags. Markdown only. Use `[[wikilinks]]` to my notes.
- Keep `Memory.md` a small index, never by dropping facts: move detail to project notes or `AI-Memory/Reference/Tech facts.md`, leaving a one-line pointer.
