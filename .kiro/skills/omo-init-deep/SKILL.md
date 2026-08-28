---
name: omo-init-deep
description: "Build a hierarchical AGENTS.md knowledge base for a repository: map the real structure with Kiro Code Intelligence, score directories to decide where an AGENTS.md earns its place, then generate the root file and per-directory files. Use when the user asks to init deep, initialize AGENTS.md, document the codebase for agents, onboard an agent to this repo, or refresh a stale AGENTS.md."
---
# /omo-init-deep

Generate hierarchical AGENTS.md files. Root + complexity-scored subdirectories.

## Usage

```
/omo-init-deep                      # Update mode: modify existing + create new where warranted
/omo-init-deep --create-new         # Read existing → remove all → regenerate from scratch
/omo-init-deep --max-depth=2        # Limit directory depth (default: 3)
```

---

## Workflow (High-Level)

1. **Discovery + Analysis** (sequential — Kiro subagents are sequential and blocking, there is no background/parallel dispatch)
   - Build the symbol/reference map with the `code` tool FIRST
   - Then run one `explore` subagent pass per major area, one at a time
   - Main session: bash structure + read existing AGENTS.md
2. **Score & Decide** - Determine AGENTS.md locations from merged findings
3. **Generate** - Root first, then subdirs one at a time
4. **Review** - Deduplicate, trim, validate

<critical>
**Post a numbered checklist covering all phases below in your response, and update it in real-time (Kiro has no todo tool — this checklist IS the tracking mechanism).**
```
1. Discovery — build the code-tool symbol/reference map, then one explore pass per major area, then read existing AGENTS.md
2. Scoring — score directories, determine locations
3. Generate — AGENTS.md files (root, then subdirs one at a time)
4. Review — deduplicate, validate, trim
```
</critical>

---

## Phase 1: Discovery + Analysis (Sequential)

**Mark step 1 as in progress in the checklist.**

### Build the code-tool symbol/reference map FIRST

Before spawning any subagent, run `/code init` if it hasn't been run for this workspace yet (see `omo-lsp-setup`), then use Kiro's `code` tool (Tree-sitter + LSP) to build the structural picture any task touching structure, entry points, dependencies, or hotspots needs — ground claims in this data instead of guessing from conventions:

- Document/workspace symbols on each entry point → file outline and symbol inventory.
- Find-references on top exports → reference centrality (feeds the scoring matrix below).
- Go-to-definition / find-references walks from entry points → dependency and call-graph shape.

Only if the `code` tool has no server wired up for this project's language(s): fall back to `explore` subagent passes plus the `sg` (ast-grep) skill, and mark centrality unmeasured in the CODE MAP.

### Then run one `explore` subagent pass per major area, sequentially

Kiro subagents are sequential and blocking — there is no background dispatch and no dynamic parallel scaling. Instead of firing N agents at once and scaling N with project size, run a **fixed sequence of passes**, one after another, folding each result into your working notes before starting the next. Use the `code`-tool map above to decide which of these passes are actually worth running for this project (skip a pass if the code map already answered it):

```
Pass 1: spawn `explore` — "Project structure: map real layout → REPORT deviations from standard patterns"
Pass 2: spawn `explore` — "Entry points: FIND main files, trace reach → REPORT non-standard organization"
Pass 3: spawn `explore` — "Conventions: FIND config files (.eslintrc, pyproject.toml, .editorconfig) → REPORT project-specific rules"
Pass 4: spawn `explore` — "Anti-patterns: FIND 'DO NOT', 'NEVER', 'ALWAYS', 'DEPRECATED' comments → LIST forbidden patterns"
Pass 5: spawn `explore` — "Build/CI: FIND .github/workflows, Makefile → REPORT non-standard patterns"
Pass 6: spawn `explore` — "Test patterns: FIND test configs/structure, what the code-tool reference map shows is covered → REPORT unique conventions"
```

For a large or deep project, extend the sequence with additional passes covering what the scale actually warrants — large-file complexity hotspots, deep-module conventions at depth 4+, cross-cutting shared utilities, one pass per package in a monorepo, one pass per language when the project is polyglot. Use judgment on how many extra passes are worth the wall-clock cost (each pass is sequential and blocks the next), rather than a fixed formula scaling agent count with file/line counts. A quick gauge:

```bash
# Measure project scale first, to judge how many extra passes are worth it
total_files=$(find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' | wc -l)
total_lines=$(find . -type f \( -name "*.ts" -o -name "*.py" -o -name "*.go" \) -not -path '*/node_modules/*' -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
large_files=$(find . -type f \( -name "*.ts" -o -name "*.py" \) -not -path '*/node_modules/*' -exec wc -l {} + 2>/dev/null | awk '$1 > 500 {count++} END {print count+0}')
max_depth=$(find . -type d -not -path '*/node_modules/*' -not -path '*/.git/*' | awk -F/ '{print NF}' | sort -rn | head -1)
```

Example extra passes for a large project (500 files, 50k lines, depth 6, 15 large files) — still run one after another, not concurrently:

```
Pass 7: spawn `explore` — "Large file analysis: FIND files >500 lines, REPORT complexity hotspots"
Pass 8: spawn `explore` — "Deep modules at depth 4+: FIND hidden patterns, internal conventions"
Pass 9: spawn `explore` — "Cross-cutting concerns: FIND shared utilities across directories"
// ... more, one pass per area that genuinely needs its own look
```

### Main Session: Analysis Alongside the Passes

Between subagent passes, the main session does:

#### 1. Bash Structural Analysis
```bash
# Directory depth + file counts
find . -type d -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/venv/*' -not -path '*/dist/*' -not -path '*/build/*' | awk -F/ '{print NF-1}' | sort -n | uniq -c

# Files per directory (top 30)
find . -type f -not -path '*/\.*' -not -path '*/node_modules/*' | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn | head -30

# Code concentration by extension
find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.go" -o -name "*.rs" \) -not -path '*/node_modules/*' | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn | head -20

# Existing AGENTS.md / CLAUDE.md
find . -type f \( -name "AGENTS.md" -o -name "CLAUDE.md" \) -not -path '*/node_modules/*' 2>/dev/null
```

#### 2. Read Existing AGENTS.md
```
For each existing file found:
  Read(filePath=file)
  Extract: key insights, conventions, anti-patterns
  Store in EXISTING_AGENTS map
```

If `--create-new`: Read all existing first (preserve context) → then delete all → regenerate.

#### 3. Code Map — the `code` tool is the highest-signal source

This is the same map built at the top of Phase 1 — reuse it here for the CODE MAP section and the Symbol/Export/Reference scoring rows below. Run it alongside (interleaved with) the sequential explore passes, not as an afterthought.

### Consolidate Results

Fold the sequential pass outputs, the bash structural analysis, the existing-AGENTS.md extraction, and the `code`-tool map into one merged picture before scoring.

**Mark step 1 as done in the checklist.**

---

## Phase 2: Scoring & Location Decision

**Mark step 2 as in progress in the checklist.**

### Scoring Matrix

| Factor | Weight | High Threshold | Source |
|--------|--------|----------------|--------|
| File count | 3x | >20 | bash |
| Subdir count | 2x | >5 | bash |
| Code ratio | 2x | >70% | bash |
| Unique patterns | 1x | Has own config | explore |
| Module boundary | 2x | Has index.ts/__init__.py | bash |
| Symbol density | 2x | >30 symbols | `code` tool |
| Export count | 2x | >10 exports | `code` tool |
| Reference centrality | 3x | >20 refs | `code` tool |

### Decision Rules

| Score | Action |
|-------|--------|
| **Root (.)** | ALWAYS create |
| **>15** | Create AGENTS.md |
| **8-15** | Create if distinct domain |
| **<8** | Skip (parent covers) |

### Output
```
AGENTS_LOCATIONS = [
  { path: ".", type: "root" },
  { path: "src/hooks", score: 18, reason: "high complexity" },
  { path: "src/api", score: 12, reason: "distinct domain" }
]
```

**Mark step 2 as done in the checklist.**

---

## Phase 3: Generate AGENTS.md

**Mark step 3 as in progress in the checklist.**

<critical>
**File Writing Rule**: If AGENTS.md already exists at the target path → use `Edit` tool. If it does NOT exist → use `Write` tool.
NEVER use Write to overwrite an existing file. ALWAYS check existence first via `Read` or discovery results.
</critical>

### Root AGENTS.md (Full Treatment)

```markdown
# PROJECT KNOWLEDGE BASE

**Generated:** {TIMESTAMP}
**Commit:** {SHORT_SHA}
**Branch:** {BRANCH}

## OVERVIEW
{1-2 sentences: what + core stack}

## STRUCTURE
```
{root}/
├── {dir}/    # {non-obvious purpose only}
└── {entry}
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|

## CODE MAP
{From the `code` tool - skip only if no server is wired up or project <10 files}

| Symbol | Type | Location | Refs | Role |
|--------|------|----------|------|------|

## CONVENTIONS
{ONLY deviations from standard}

## ANTI-PATTERNS (THIS PROJECT)
{Explicitly forbidden here}

## UNIQUE STYLES
{Project-specific}

## COMMANDS
```bash
{dev/test/build}
```

## NOTES
{Gotchas}
```

**Quality gates**: 50-150 lines, no generic advice, no obvious info.

### Subdirectory AGENTS.md (Sequential)

Kiro subagents are sequential and blocking, so generate subdirectory files one at a time rather than fanning them out — either write each one directly, or spawn `explore` (or an appropriate writing-capable subagent) as a Kiro subagent per location, waiting for each to finish before starting the next:

```
for loc in AGENTS_LOCATIONS (except root), one at a time:
  Generate AGENTS.md for: {loc.path}
    - Reason: {loc.reason}
    - 30-80 lines max
    - NEVER repeat parent content
    - Sections: OVERVIEW (1 line), STRUCTURE (if >5 subdirs), WHERE TO LOOK, CONVENTIONS (if different), ANTI-PATTERNS
```

**Once every location is done, mark step 3 as done in the checklist.**

---

## Phase 4: Review & Deduplicate

**Mark step 4 as in progress in the checklist.**

For each generated file:
- Remove generic advice
- Remove parent duplicates
- Trim to size limits
- Verify telegraphic style

**Mark step 4 as done in the checklist.**

---

## Final Report

```
=== omo-init-deep Complete ===

Mode: {update | create-new}

Files:
  [OK] ./AGENTS.md (root, {N} lines)
  [OK] ./src/hooks/AGENTS.md ({N} lines)

Dirs Analyzed: {N}
AGENTS.md Created: {N}
AGENTS.md Updated: {N}

Hierarchy:
  ./AGENTS.md
  └── src/hooks/AGENTS.md
```

---

## Anti-Patterns

- **Skipping the `code`-tool map**: build the symbol/reference map before falling back to explore-only passes
- **Unbounded pass count**: extend the sequential pass list to match project scale, but justify every extra pass — don't run more than the project warrants just because the formula says so
- **Ignoring existing**: ALWAYS read existing first, even with --create-new
- **Over-documenting**: Not every dir needs AGENTS.md
- **Redundancy**: Child never repeats parent
- **Generic content**: Remove anything that applies to ALL projects
- **Verbose style**: Telegraphic or die
