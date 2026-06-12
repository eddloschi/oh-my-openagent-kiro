# MCP Usage

OMO-Kiro includes three remote MCP servers that mirror the preferred Oh My OpenAgent research tools:

- `context7`: official library and framework documentation lookup.
- `grep_app`: public GitHub code search for examples and implementation patterns.
- `websearch`: current web search through Exa's MCP endpoint.

Use MCPs only when they improve evidence. Prefer local repository inspection and Kiro Code Intelligence for workspace-specific code.

Security rules:

- Do not send secrets, tokens, private keys, credentials, or full proprietary files to remote MCPs.
- For private code questions, summarize the public API shape or error message instead of uploading large private snippets.
- Prefer narrow queries over broad repository dumps.
- Cite MCP-derived findings clearly and distinguish them from local file evidence.
- If an MCP requires authentication in the user's environment, ask the user to configure credentials through environment variables or local Kiro settings; never hardcode credentials in this repo.

Tool selection:

- Use `@context7` for package APIs, migration behavior, and official docs.
- Use `@grep_app` for public implementation examples across GitHub.
- Use `@websearch` for current information, release notes, issue context, and vendor pages.
