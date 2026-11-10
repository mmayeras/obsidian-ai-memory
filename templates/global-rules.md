# Vault memory (global rules, every project)

My Obsidian vault at `__VAULT__` is my long-term memory. Paths below are relative to it. Project-local CLAUDE.md / AGENTS.md files add to these rules.

## Startup (silent)
- The SessionStart hook injects Memory, Next Session and today's daily note. If nothing was injected (common in Cursor), read `AI-Memory/Memory.md`, `AI-Memory/Next Session.md` and today's daily note yourself.
- The Vault Map is not injected: read `AI-Memory/Vault Map.md` before searching the vault or filing a note.
- In a code repo, read its note under `AI-Memory/Projects/` if one exists.
- No startup table, no recap: answer my first message directly. Mention memory only when an open loop or past decision bears on it (one line), when `Memory.md` or the Vault Map is missing (one line, suggest onboard), or, if my message has no task (greeting, "."), with the Next Session "Next action".
- **"startup"**: reload and reply in 3 lines max (what loaded or is missing, project note, next action).

## Vault access
Use Obsidian MCP tools when available (`search_notes`, `read_note`, `write_note`, `patch_note`, `list_directory`). Otherwise `grep -ril "<topic>" "__VAULT__" --include="*.md"` and the Read tool on absolute paths. Questions about my customers, work setups or past work: check the Vault Map, then search the vault before answering. Say so when falling back to general knowledge ("Your notes don't cover X, but generally...").

## During work
- **"remember this"**: append now to the right note (`AI-Memory/Memory.md`, the project note, a customer's `Info/Account Overview.md`, or `Memory.md > Decisions`) and quote the line added.
- Decisions format: `- YYYY-MM-DD - decision - because reasoning - rejected: alternatives`
- Code work: the why goes in the vault project note, the code stays in the repo.
- Keep `Memory.md` an index (about me, behavior rules, pointers). Project detail goes to the project note, tech facts to `AI-Memory/Reference/Tech facts.md`, with at most a one-line pointer in `Memory.md`.

## Customers
`Customers/<Name>/Info/Account Overview.md` holds contacts, virtual account team, TAM call minutes, private group, Drive repo, presentations and cluster list. Create or update it with the `customer-onboard` skill.
- Treat a customer like a project: read its Account Overview first, append new durable facts there (or to `Memory.md`) as they come up.
- Read Google Doc/Sheet links in it with the `gws-read` skill when the content is needed; don't just repeat the link.

## "wrap up"
1. Rewrite `AI-Memory/Next Session.md`: summary, open loops, next actions, repo path. Keep it under ~30 lines: it is injected every session.
2. Update this repo's project note (missing: offer to copy `AI-Memory/Projects/_project-template.md`, ask first) and the Account Overview of any customer discussed.
3. Append durable facts and decisions to the right note (see "Keep `Memory.md` an index").
4. Append a 2-3 line log under `## AI` in today's daily note. Never edit my own entries.
5. If substantial, copy the summary to `AI-Memory/Sessions/YYYY-MM-DD.md`.
6. Confirm in 2 lines what you saved and where.

## Limits
In the vault, write only under `AI-Memory/`, the `## AI` section of dailies, and `Customers/<Name>/Info/` (Account Overview and files in that folder). The rest of `Customers/` needs an explicit ask each time. Never delete notes. Never touch `.obsidian/`.
