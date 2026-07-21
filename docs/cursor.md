# Cursor setup

## Install

From the obsidian-ai-memory repo:

```bash
bash install.sh --platforms cursor --vault "/path/to/your/vault" --mcp yes
```

Recommended: include `--mcp yes` for better vault search and safer edits. See [obsidian-mcp.md](obsidian-mcp.md).

## What gets installed

| Artifact | Location |
|----------|----------|
| User rule (always on) | `~/.cursor/rules/vault-memory.mdc` |
| SessionStart hook | `~/.cursor/hooks/vault-memory-cursor.sh` in `~/.cursor/hooks.json` |
| Skills | `~/.cursor/skills/vault-onboard`, `vault-organize`, `vault-rewrite`, `vault-wrap-up` |
| Obsidian MCP (optional) | `obsidian` entry in `~/.cursor/mcp.json` |

Restart Cursor after install.

## Onboarding (once)

Open Agent chat (from vault or any repo) and say:

```
onboard my vault
```

Or run from vault root for full context. Same result as Claude Code `/onboard`.

## Day to day (any repo)

Open a code project in Cursor and use Agent chat.

### Memory loading (defense in depth)

Cursor uses three layers because `sessionStart` hook injection can be unreliable:

1. **User rule** — instructs agent to read `AI-Memory/Memory.md`, `Next Session.md`, `Vault Map.md`, and today's daily via Obsidian MCP (or Read tool) if the startup table is empty
2. **sessionStart hook** — best-effort injection of the same content
3. **You say "startup"** — force reload on demand

### Phrases

| Phrase | Effect |
|--------|--------|
| remember this | Append via MCP or shell |
| wrap up | Triggers vault-wrap-up skill |
| startup | Reload memory and print table |
| onboard my vault | vault-onboard skill |
| organize my vault | vault-organize skill |
| rewrite vault notes | vault-rewrite skill |

## Vault advisor mode

Open your vault as a workspace or ask Agent to search the vault for customer/work questions. Global rules apply in every project.

## Obsidian MCP

When MCP is installed, the agent prefers:

- `search_notes` over grep
- `write_note` (append) / `patch_note` over manual file edits
- `read_multiple_notes` for batch reads

Shell/grep fallback always works if MCP is unavailable.

## Uninstall

```bash
bash scripts/uninstall-cursor.sh
```

See [uninstall.md](uninstall.md).
