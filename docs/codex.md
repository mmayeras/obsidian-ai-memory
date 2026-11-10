# Codex

Works with the Codex CLI and the Codex desktop app (both read `~/.codex`).

## Install

```bash
bash install.sh --platforms codex
# or only the Codex part:
bash scripts/install-codex.sh "/path/to/your vault"
bash scripts/install-obsidian-mcp.sh "/path/to/your vault" codex   # optional
```

Then restart Codex. **Codex asks you to trust the new vault hook once: approve it**, or the memory is not loaded. It asks again whenever the hook entry changes (for example after a re-install that changes it).

## What the installer changes

| File | Change |
|------|--------|
| `~/.codex/hooks/vault-memory.sh` | Hook script: prints Memory, Next Session, today's daily note (capped) and the project list |
| `~/.codex/hooks.json` | `SessionStart` entry with the **absolute** path to that script. Other hooks are kept. |
| `~/.codex/AGENTS.md` | Vault rules inside a `BEGIN/END OBSIDIAN AI MEMORY` block. Your own text in the file is kept; re-runs replace only the block. Codex does not expand `@includes`, so the rules are inlined. |
| `~/.agents/skills/` | Skills: `vault-onboard`, `vault-organize`, `vault-rewrite`, `vault-wrap-up`, `customer-onboard` |
| `~/.codex/config.toml` | Only with the MCP step: `[mcp_servers.obsidian]` (via `codex mcp add` when the CLI is on PATH) |

Each edited file gets a `.bak` copy first.

## Phrases

| Phrase | Effect |
|--------|--------|
| remember this | Append to the right vault note |
| wrap up | vault-wrap-up skill |
| startup | Reload memory, 3-line status |
| onboard my vault | vault-onboard skill |

## Check it works

Start a new Codex chat and ask "what's my next action?". It should answer from `Next Session.md`. If not, see [Troubleshooting](troubleshooting.md).

## Uninstall

```bash
bash scripts/uninstall-codex.sh
```
