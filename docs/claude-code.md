# Claude Code setup

## Install

From the obsidian-ai-memory repo:

```bash
bash install.sh --platforms claude-code --vault "/path/to/your/vault"
```

Or vault kit + Claude Code only:

```bash
bash scripts/install-vault.sh "/path/to/your/vault"
bash scripts/install-claude-code.sh "/path/to/your/vault"
```

## What gets installed

| Artifact | Location |
|----------|----------|
| Global rules | `~/.claude/CLAUDE-vault.md` (included from `~/.claude/CLAUDE.md`) |
| SessionStart hook | `~/.claude/hooks/vault-memory.sh` merged into `~/.claude/settings.json` |
| Commands | `~/.claude/commands/onboard.md`, `organize.md`, `rewrite.md` |
| Vault kit | `CLAUDE.md`, `.claude/`, `AI-Memory/` in your vault |
| Obsidian MCP (optional) | `claude mcp add -s user obsidian …` — user scope, all repos ([details](obsidian-mcp.md)) |

## Obsidian MCP (optional, recommended)

`install.sh` offers Obsidian MCP; accept it for frontmatter-aware `read_note` / `search_notes` / `write_note` / `patch_note` tools instead of grep. Added at **user scope** so it's live in every repo. Add later with:

```bash
bash scripts/install-obsidian-mcp.sh "/path/to/your/vault" claude-code
```

Verify: `claude mcp get obsidian` → `✔ Connected`. Without MCP, the assistant falls back to shell/grep — same results. See [obsidian-mcp.md](obsidian-mcp.md).

## Onboarding (once)

```bash
cd "/path/to/your/vault"
claude
```

Answer trust prompts, then:

```
/onboard
```

The assistant maps your vault, writes `AI-Memory/Vault Map.md`, seeds `AI-Memory/Memory.md`, and creates project notes. Confirm any `(?)` deductions.

## Day to day (any repo)

```bash
cd ~/your-code-project
claude
```

On session start:

1. Hook injects Memory, Next Session, Vault Map, today's daily, project list
2. Agent prints startup table, then answers

| Phrase | Effect |
|--------|--------|
| remember this | Append to vault note |
| wrap up | Full handoff workflow |
| startup | Reload table on demand |

## Vault advisor mode

Run `claude` from the vault root for customer/work questions not tied to a repo. Same rules; searches all notes before answering.

## Maintenance

| Command | When |
|---------|------|
| `/onboard` | After a big vault restructure |
| `/organize` | Propose cleanup; you approve each step |
| `/rewrite` | Batch-format notes (git snapshot required) |

## Uninstall

```bash
bash scripts/uninstall-claude-code.sh
```

See [uninstall.md](uninstall.md).
