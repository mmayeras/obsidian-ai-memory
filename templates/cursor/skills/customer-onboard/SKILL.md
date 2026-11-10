---
name: customer-onboard
description: Onboard a new customer account or update an existing one — asks for contacts, virtual account team, TAM call minutes, private group link, Drive repo, presentations, and cluster list, then fills Customers/<Name>/Info/Account Overview.md automatically. Use when the user says onboard a new customer, add a customer, set up <customer> account, or update customer info/account overview.
---

## Vault access

If Obsidian MCP is available, use `list_directory`, `read_note`, `write_note`, and `patch_note`. Otherwise use shell file tools.

## 1. Read the template first — it's the single source of truth

Before asking me anything, `read_note` (or Read tool) `templates/Account Overview template.md` at
the vault root. Its section headings, in order, are the structure to fill in — don't hardcode a
copy of that structure here in this skill file. If I've added, renamed, or reordered a section in
that template since you last ran this, follow the new version.

If the file doesn't exist yet, create it from the **Bootstrap template** at the bottom of this
skill, then use that as the structure for this run.

## 2. New account or existing?

1. Check whether `Customers/<Name>/` exists.
2. **New account**: create `Cases/`, `Meetings/`, `misc/`, `Info/` subfolders (per the Vault Map convention), and `AccountMappings/<Name>.md` (slug + account number) if it doesn't exist yet.
3. **Existing account**: read the current `Customers/<Name>/Info/Account Overview.md` first (if present). Only ask about fields that are missing, empty, or that I say I want to change — don't re-ask for data already filled in. Show me the current value before overwriting a non-empty field.

## 3. Ask for the information each template section calls for

Walk the sections in the template file in order and ask me for each one (skip any I already have
on file, per step 2.3). As of this writing that's:

- **Customer Contacts** — a list: name, role, email, phone.
- **Virtual Account Team** — one person per role: Account Manager, Solutions Architect, TAM, Backup TAM, Project Manager, TSM, Consultants Engaged (this one can be a list, not just one name).
- **TAM Call Minutes** — a single link (typically a Google Doc).
- **Customer Private Group** — a single link (Slack channel, Teams, etc.).
- **Google Drive Repo** — a single link to the account's shared Drive folder.
- **Presentations** — a list of links (title + link each), typically Google Slides/Docs.
- **Cluster List** — a single link (typically a Google Sheet).

This list exists only to describe what each section currently means — if the template file
disagrees with it (sections added/renamed), the template file wins. Don't block on a field if I
don't have the answer yet — leave it blank in the note rather than inventing a placeholder.

## 4. Write the note

Write/merge into `Customers/<Name>/Info/Account Overview.md`: same section headings and order as
`templates/Account Overview template.md`, each filled in with what I gave you (blank if I didn't
have an answer). Keep a trailing `## Files in this folder` section even if the template doesn't
list one explicitly — see step 5.

Frontmatter: `tags: [<customer-slug>]`, `type: reference` — same convention as every other note
under `Customers/`.

## 5. Files

Any account-level file (contract, deck, org chart, roster screenshot) that isn't itself a Google
Drive link goes straight into the same `Customers/<Name>/Info/` folder, listed under "Files in
this folder." No separate attachments subfolder.

## 6. Afterwards

- Confirm in 2 lines what was written and where.
- From now on, treat this account the same way a project is treated: when it's discussed later,
  read this note first; parse any Google Doc/Sheet link it holds (via the `gws-read` skill) when
  its content is actually needed, don't just cite the raw link; and update the note as new
  contacts/decisions/links come up, not only at wrap-up. See the global rule's "Customers" section.

---

## Bootstrap template (only used if `templates/Account Overview template.md` doesn't exist yet)

```
---
tags: [template]
type: reference
---

# Account Overview template

Reusable reference for a customer account. Lives at `Customers/<Name>/Info/Account Overview.md`.
Files for the account live alongside it in the same `Info/` folder. Filled in by the
`customer-onboard` skill — don't hand-edit the per-customer notes' structure, edit this file
instead and the skill will follow it next time.

---

# [Customer Name] — Account Overview

## Customer Contacts

| Name | Role | Email | Phone |
|---|---|---|---|
| | | | |

## Virtual Account Team

| Role | Name | Email |
|---|---|---|
| Account Manager | | |
| Solutions Architect | | |
| TAM | | |
| Backup TAM | | |
| Project Manager | | |
| TSM | | |
| Consultants Engaged | | |

## TAM Call Minutes

- [link]

## Customer Private Group

- [link]

## Google Drive Repo

- [link]

## Presentations

- [title](link)

## Cluster List

- [link]

## Files in this folder

- [filename] — [one-line description of what it is and when added]
```
