---
name: omo-lsp-setup
description: "Configure a Language Server (LSP) for a specific language so editor/agent tooling — diagnostics, go-to-definition, find-references, rename — works. Use when you need to: configure LSP, lsp setup, set up or install a language server, fix 'no LSP server configured' / 'server not installed', choose between servers (basedpyright vs pyright vs ty vs ruff), or get Kiro's `code` tool working via `/code init`. 언어서버 설정. Routes by file extension to references/<language>/README.md for the exact builtin server, per-OS install commands (macOS/Linux/Windows), initialization options, alternatives, and troubleshooting. Ships scripts: detect-lsp.ts (scan a project for languages + each server's install/config status) and verify-lsp.ts (run a real diagnostics roundtrip). Covers typescript, python, go, rust, c/c++, java, kotlin, c#/razor, swift, ruby, php, dart, elixir, zig, lua, bash, yaml, terraform, haskell, julia."
---

# LSP Setup

Configure the right Language Server for a project so Kiro's `code` tool
(Tree-sitter + LSP: diagnostics, go-to-definition, find-references, symbols,
rename) actually works. This skill is an index: detect what a project needs,
install the server, run `/code init`, then verify with a real roundtrip.

The list of servers we ship as **builtin** is the source of truth in
`packages/lsp-tools-mcp/src/lsp/server-definitions.ts` (`BUILTIN_SERVERS` +
`LSP_INSTALL_HINTS`). The per-language references below mirror it.

---

## PHASE 0 — LANGUAGE GATE (run first)

Identify the language from the file extension, then **read the matching
reference before installing or configuring anything**.

| Extension(s) | Reference |
|---|---|
| `.ts .tsx .js .jsx .mjs .cjs .mts .cts .vue .svelte .astro` | `references/typescript/README.md` |
| `.py .pyi` | `references/python/README.md` |
| `.go` | `references/go/README.md` |
| `.rs` | `references/rust/README.md` |
| `.c .cpp .cc .cxx .h .hpp .hh .hxx` | `references/c-cpp/README.md` |
| `.java` | `references/java/README.md` |
| `.kt .kts` | `references/kotlin/README.md` |
| `.cs .razor .cshtml` | `references/csharp/README.md` |
| `.swift` | `references/swift/README.md` |
| `.rb .rake .gemspec .ru` | `references/ruby/README.md` |
| `.php` | `references/php/README.md` |
| `.dart` | `references/dart/README.md` |
| `.ex .exs` | `references/elixir/README.md` |
| `.zig .zon` | `references/zig/README.md` |
| `.lua` | `references/lua/README.md` |
| `.sh .bash .zsh .ksh` | `references/bash/README.md` |
| `.yaml .yml` | `references/yaml/README.md` |
| `.tf .tfvars` | `references/terraform/README.md` |
| `.hs .lhs` | `references/haskell/README.md` |
| `.jl` | `references/julia/README.md` |

---

## WORKFLOW — detect → install → configure → verify

### 1. Detect

Scan the project to see which languages are present and whether each server is
installed and configured:

```bash
bun scripts/detect-lsp.ts <projectDir>      # human report (default: cwd)
bun scripts/detect-lsp.ts <projectDir> --json
```

For each detected language it prints the builtin server id, the executable it
needs on `PATH`, whether that executable is installed, an install hint, and
whether a project config file already references it.

### 2. Install

Open `references/<language>/README.md` and run the install command for your OS.
Then confirm the executable resolves:

```bash
command -v <server-executable>   # e.g. typescript-language-server, gopls, rust-analyzer
```

### 3. Configure

In Kiro, configuration is a command, not a config file to hand-edit:

```bash
/code init         # detect languages in the workspace and wire up the matching LSP servers
/code init -f       # force re-detection / re-init, e.g. after installing a new server binary
/code status         # check which servers are currently wired up and healthy
```

Run `/code init` after installing a server binary (step 2). If `/code status` reports
no server for the language you need, the server executable is almost certainly
missing from `PATH` — go back to step 2, install it from that language's reference
table, then re-run `/code init -f`.

Each language reference's install table is what you need here — the config-file
JSON shape and dotfile paths from the upstream harnesses (Codex/OpenCode) do not
apply to Kiro and are not part of this flow.

### 4. Verify

Run a real diagnostics roundtrip against a source file. This spawns the server,
opens the file, requests diagnostics, and reports `OK`/`FAIL`:

```bash
bun scripts/verify-lsp.ts <path/to/file.ext>
bun scripts/verify-lsp.ts <file> --timeout=90000
```

`OK` = the server started and answered. `FAIL: language server not installed`
= go back to step 2. Other `FAIL` text carries the server/startup error.
`SKIP` = the engine source could not be located; run from inside the omo
repo/worktree, or use Kiro's `code` tool diagnostics directly once `/code init`
has wired up the server.

---

## Scripts

| Script | Purpose |
|---|---|
| `scripts/detect-lsp.ts` | Scan a directory; per detected language report server id, install status, install hint, config status. `--json` for machine output. |
| `scripts/verify-lsp.ts` | Real LSP diagnostics roundtrip for one file via the `lsp-tools-mcp` engine; `OK`/`FAIL`/`SKIP` + exit code 0/1/3. |
| `scripts/lsp-server-table.ts` | Embedded snapshot of the primary builtin server per language (mirrors `server-definitions.ts`). |

Run with [Bun](https://bun.sh): `curl -fsSL https://bun.sh/install | bash`.
