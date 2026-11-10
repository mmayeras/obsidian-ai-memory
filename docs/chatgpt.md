# ChatGPT setup

ChatGPT does not use the Claude Code startup hook or Cursor rule installed by this repository. Use a ChatGPT Project for the instructions and chats, and connect an Obsidian app or MCP integration when one is available in your ChatGPT workspace.

## Set up a Project

1. Create a private ChatGPT Project for your vault or ongoing work.
2. Open Project settings and paste the contents of [`templates/chatgpt/project-instructions.md`](../templates/chatgpt/project-instructions.md) into the Project instructions.
3. Connect an Obsidian app/tool in ChatGPT if your plan and workspace expose one. Confirm that it can read, search, and write notes before asking it to maintain the vault.
4. Start a chat in that Project and ask it to **"onboard my vault"**. Review the proposed Vault Map and memory notes.

Project instructions persist within that Project, while a connected Obsidian tool provides access to current vault contents. Uploaded copies of `Memory.md`, `Next Session.md`, or `Vault Map.md` can provide fallback context, but they are snapshots and may become stale. Refresh them when you rely on them without live vault access.

## Live Obsidian access

ChatGPT's connected-app and custom MCP options depend on plan, workspace policy, and client support. Current OpenAI guidance says custom MCP servers connect remotely; a local-only MCP server is not directly reachable by ChatGPT. Use a supported Obsidian app integration or a secure, approved remote connection if available. Do not expose a private vault server publicly just to make this setup work.

If no suitable Obsidian tool is available, keep the Project instructions and use uploaded snapshots or paste the relevant notes. ChatGPT cannot read or write the local vault just because its path appears in the instructions. In this mode, ask it to provide proposed note edits for you to apply, and do not let it claim that it changed the vault.

## Limits compared with the IDE integrations

- There is no repository-provided ChatGPT installer or automatic per-chat startup hook. Project instructions ask ChatGPT to load the memory files at the start of each new chat.
- ChatGPT Projects can retain their own instructions, files, and chats, but the Obsidian vault remains the source of truth.
- Availability of Obsidian tools and write actions is controlled by the connected app and the ChatGPT workspace; verify the actual tool access in the target Project.
