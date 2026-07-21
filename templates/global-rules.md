# Global rules — vault memory follows me into every project

My Obsidian vault at `__VAULT__` is my long-term memory. These rules apply in EVERY project (code repos included). Project-local CLAUDE.md / AGENTS.md files add to this; they don't replace it.

## Startup (before my first answer)

The SessionStart hook injects Memory, Next Session, Vault Map and today's daily note from the vault. Read them. If injected context is missing (common in Cursor), load those files yourself before answering — see Vault access below.

If the current directory is a code repo, also check the vault for its project note and read the matching one under `AI-Memory/Projects/`. Then print the startup table (Memory / Next Session / Vault Map / Daily / Project note / Open loops) before anything else. If I say **"startup"**, reload memory and print the table again.

| Startup | Status |
|---|---|
| Memory.md | DONE / MISSING |
| Next Session.md | DONE / MISSING |
| Vault Map.md | DONE / run onboard |
| Today's daily note | DONE / not created yet |
| Project note | (name, or "n/a") |
| Open loops | (incl. open tasks from recent dailies, or "none") |

## Vault access (MCP-first, shell fallback)

If Obsidian MCP tools are available (`read_note`, `write_note`, `search_notes`, `patch_note`, `list_directory`), **use them**. Otherwise use shell/grep or the Read tool on absolute paths under `__VAULT__`. Never skip vault search for customer/work questions.

| Action | Preferred (Obsidian MCP) | Fallback (no MCP) |
|---|---|---|
| Search vault | `search_notes` with query | `grep -ril "<topic>" "__VAULT__" --include="*.md"` |
| Read note | `read_note` / `read_multiple_notes` | `cat` or Read tool on `__VAULT__/...` |
| Append ("remember this") | `write_note` mode `append` or `patch_note` | append to file via shell |
| List projects | `list_directory` on `AI-Memory/Projects/` | `ls "__VAULT__/AI-Memory/Projects/"` |

Say explicitly when you fall back to general knowledge: "Your notes don't cover X, but generally…"

## During work

- **"remember this"** → append immediately to the right vault note (`__VAULT__/AI-Memory/Memory.md`, project note, or `Memory.md > Decisions`) and confirm the exact line added.
- Decisions format: `- YYYY-MM-DD — decision — because reasoning — rejected: alternatives`
- Questions about my customers, work setups, or past work → search the vault first (MCP or grep). Check `AI-Memory/Vault Map.md` before searching blind.
- Decisions about the code we're writing: record the WHY in the vault project note; the code itself stays in the repo.

## "wrap up"

1. Rewrite `__VAULT__/AI-Memory/Next Session.md` (summary, open loops, next actions — mention the repo path).
2. Update the vault project note for this repo (if missing, copy `__VAULT__/AI-Memory/Projects/_project-template.md` to `__VAULT__/AI-Memory/Projects/<repo-name>.md` — ask first).
3. Append durable facts/decisions to `__VAULT__/AI-Memory/Memory.md`.
4. Append a 2-3 line session log under `## AI` in today's daily note in the vault. Never edit my own daily entries.
5. If substantial, copy the summary to `__VAULT__/AI-Memory/Sessions/YYYY-MM-DD.md`.
6. Confirm in 2 lines what you saved and where.

## Limits

In the vault, write ONLY under `__VAULT__/AI-Memory/` and the `## AI` section of dailies. Never delete notes. Never touch `.obsidian/`. In the repo: normal coding rules apply.
