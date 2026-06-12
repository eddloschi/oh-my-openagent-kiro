# Kiro Tool Use

Use Kiro tools according to their schema and purpose.

- For directory inventory, use shell commands such as `rg --files`, `find`, or `ls`.
- For codebase structure and symbol discovery, prefer the `code` tool when available.
- Do not call the read tool on a directory path.
- Use the read tool for concrete files after paths are known.
- For broad code discovery, search first, then read the most relevant files.
- When batching reads, use the Kiro CLI batch-read shape the tool expects instead of inventing ad hoc fields.
- If a tool schema error occurs, do not retry the same shape. Switch to a simpler file or shell-based discovery step.
