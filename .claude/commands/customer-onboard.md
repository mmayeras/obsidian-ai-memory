---
description: Onboard a new customer account or update an existing one — contacts, virtual account team, TAM call minutes, private group, Drive repo, presentations, cluster list — into Customers/<Name>/Info/Account Overview.md.
---
Run from the vault root.

1. Read `templates/Account Overview template.md` at the vault root first — its section headings, in order, are the structure to use. If missing, create it from the bootstrap copy in `templates/cursor/skills/customer-onboard/SKILL.md` and use that.
2. Check whether `Customers/<Name>/` exists. New account → create `Cases/`, `Meetings/`, `misc/`, `Info/` subfolders and `AccountMappings/<Name>.md` (slug + account number) if missing. Existing account → read the current `Info/Account Overview.md` first and only ask about fields that are missing, empty, or that I say I want to change.
3. Ask for whatever each template section currently calls for (as of this writing: Customer Contacts, Virtual Account Team — Account Manager, Solutions Architect, TAM, Backup TAM, Project Manager, TSM, Consultants Engaged —, TAM Call Minutes link, Customer Private Group link, Google Drive Repo link, Presentations list of links, Cluster List link). Leave a field blank rather than inventing data.
4. Write/merge into `Customers/<Name>/Info/Account Overview.md` using the same section order as the template file. Never put example/placeholder data into the shared template file itself, only into the real per-customer note.
5. Confirm in 2 lines what was written and where.
