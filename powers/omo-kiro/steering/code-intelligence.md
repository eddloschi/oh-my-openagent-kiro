# Code Intelligence

Use Kiro CLI Code Intelligence for codebase understanding.

- Prefer the `code` tool for codebase overview, symbol search, document symbols, exact symbol lookup, AST pattern search, diagnostics, definitions, and references.
- Tree-sitter code intelligence works out of the box for supported languages and does not require LSP setup.
- LSP-backed features such as references, definition lookup, hover docs, rename, diagnostics, and completions require workspace initialization with `/code init`.
- If LSP features are unavailable, fall back to built-in Tree-sitter operations and shell searches such as `rg`.
- For read-only agents, use `code` for search, overview, symbols, diagnostics, and dry-run analysis only. Do not run code rewrite or rename operations.
- For rewrite workflows, search first, run dry-run preview, review matches, then apply only from executor agents and only when in scope.

Useful slash commands:

```text
/code overview
/code overview ./path
/code init
/code init -f
/code status
/code logs
```
