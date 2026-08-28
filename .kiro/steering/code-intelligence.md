# Code Intelligence

Use Kiro CLI Code Intelligence for codebase understanding, in this order.

1. **`code` tool first** — overview, symbol search, document symbols, exact symbol lookup, AST
   pattern search, diagnostics, definitions, and references. This is the port's replacement for
   upstream's CodeGraph and `lsp_*` tools: use it for "how/where/what/flow" questions before wider
   reads.
2. **`rg` / shell** when the `code` tool is unavailable, uninitialized, or the query is about string
   contents, comments, or filenames rather than syntax shape.
3. **`sg` (ast-grep) via the `/omo-ast-grep` skill** when the target is a syntax *shape* — every call
   or class or import matching a pattern, or a deterministic codemod — and Tree-sitter search cannot
   express it precisely.

Notes:

- Tree-sitter code intelligence works out of the box for supported languages; no setup needed.
- LSP-backed features (references, definitions, hover, rename, diagnostics, completions) require
  `/code init`. If a language has no server, see the `/omo-lsp-setup` skill.
- Read-only agents use `code` for search, overview, symbols, diagnostics, and dry-run analysis only.
  Never run code rewrite or rename operations from a read-only agent.
- For rewrite workflows: search first, dry-run preview, review matches, then apply — from an executor
  agent, and only when in scope.

Useful slash commands:

```text
/code overview
/code overview ./path
/code init
/code init -f
/code status
/code logs
```
