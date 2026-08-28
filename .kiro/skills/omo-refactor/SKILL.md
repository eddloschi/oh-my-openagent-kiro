---
name: omo-refactor
description: "Structured refactor workflow: classify the intent, build a dependency codemap and impact-zone risk table, gate on test coverage, plan the steps, then execute one step at a time with diagnostics, tests, and a commit checkpoint after each. Use when the user asks to refactor, restructure, extract, split, simplify, modernize, clean up, or reorganize existing code without changing its behavior."
---

# Intelligent Refactor Command

## Usage
```
/omo-refactor <refactoring-target> [--scope=<file|module|project>] [--strategy=<safe|aggressive>]

Arguments:
  refactoring-target: What to refactor. Can be:
    - File path: src/auth/handler.ts
    - Symbol name: "AuthService class"
    - Pattern: "all functions using deprecated API"
    - Description: "extract validation logic into separate module"

Options:
  --scope: Refactoring scope (default: module)
    - file: Single file only
    - module: Module/directory scope
    - project: Entire codebase

  --strategy: Risk tolerance (default: safe)
    - safe: Conservative, maximum test coverage required
    - aggressive: Allow broader changes with adequate coverage
```

## What This Command Does

Performs intelligent, deterministic refactoring with full codebase awareness. Unlike blind search-and-replace, this command:

1. **Understands your intent** - Analyzes what you actually want to achieve
2. **Maps the codebase** - Builds a definitive codemap before touching anything
3. **Assesses risk** - Evaluates test coverage and determines verification strategy
4. **Plans meticulously** - Hands off to `/omo-plan` for a detailed plan
5. **Executes precisely** - Step-by-step refactoring with the `code` tool and `sg` (via `/omo-ast-grep`)
6. **Verifies constantly** - Runs tests after each change to ensure zero regression

---

# PHASE 0: INTENT GATE (MANDATORY FIRST STEP)

**BEFORE ANY ACTION, classify and validate the request.**

## Step 0.1: Parse Request Type

| Signal | Classification | Action |
|--------|----------------|--------|
| Specific file/symbol | Explicit | Proceed to codebase analysis |
| "Refactor X to Y" | Clear transformation | Proceed to codebase analysis |
| "Improve", "Clean up" | Open-ended | **MUST ask**: "What specific improvement?" |
| Ambiguous scope | Uncertain | **MUST ask**: "Which modules/files?" |
| Missing context | Incomplete | **MUST ask**: "What's the desired outcome?" |

## Step 0.2: Validate Understanding

Before proceeding, confirm:
- [ ] Target is clearly identified
- [ ] Desired outcome is understood
- [ ] Scope is defined (file/module/project)
- [ ] Success criteria can be articulated

**If ANY of above is unclear, ASK CLARIFYING QUESTION:**

```
I want to make sure I understand the refactoring goal correctly.

**What I understood**: [interpretation]
**What I'm unsure about**: [specific ambiguity]

Options I see:
1. [Option A] - [implications]
2. [Option B] - [implications]

**My recommendation**: [suggestion with reasoning]

Should I proceed with [recommendation], or would you prefer differently?
```

## Step 0.3: Create Initial Checklist

**IMMEDIATELY after understanding the request, post a numbered checklist in your response** and keep it updated as you progress (Kiro has no todo tool, so this checklist IS the tracking mechanism):

```
1. PHASE 1: Codebase Analysis - sequential explore passes
2. PHASE 2: Build Codemap - map dependencies and impact zones
3. PHASE 3: Test Assessment - analyze test coverage and verification strategy
4. PHASE 4: Plan Generation - hand off to /omo-plan for a detailed refactoring plan
5. PHASE 5: Execute Refactoring - step-by-step with continuous verification
6. PHASE 6: Final Verification - full test suite and regression check
```

---

# PHASE 1: CODEBASE ANALYSIS (SEQUENTIAL EXPLORATION)

**Mark step 1 as in progress in the checklist.**

## 1.1: Run Sequential Explore Passes

Kiro subagents are sequential and blocking — there is no background dispatch. Spawn `explore` as a Kiro subagent for each pass below, one after another, folding each result into your working notes before starting the next:

```
Pass 1: spawn `explore` to find all occurrences and definitions of [TARGET].
  Report: file paths, line numbers, usage patterns.

Pass 2: spawn `explore` to find all code that imports, uses, or depends on [TARGET].
  Report: dependency chains, import graphs.

Pass 3: spawn `explore` to find similar code patterns to [TARGET] in the codebase.
  Report: analogous implementations, established conventions.

Pass 4: spawn `explore` to find all test files related to [TARGET].
  Report: test file paths, test case names, coverage indicators.

Pass 5: spawn `explore` to find architectural patterns and module organization around [TARGET].
  Report: module boundaries, layer structure, design patterns in use.
```

If `[TARGET]` is narrow (single file, single symbol), you may collapse passes 2-5 into one combined `explore` pass — use judgment instead of always running all five.

## 1.2: Direct Tool Exploration

Interleave direct tool use with (or instead of) the explore passes above:

### `code` tool for precise analysis:

Run `/code init` first if it hasn't been run for this workspace (see `omo-lsp-setup`). Then use the `code` tool's LSP-backed operations to:
- Go to definition — where is [TARGET] actually defined?
- Find all references — every usage across the workspace
- Document/workspace symbols — hierarchical outline, search by name
- Diagnostics — capture the current errors/warnings baseline before touching anything

### `sg` (ast-grep) for structural pattern analysis:

Invoke `/omo-ast-grep` for guidance, or run `sg` directly:

```bash
# Find structural patterns
sg --pattern 'function $NAME($$$) { $$$ }' --lang ts src/

# Preview refactoring first
sg --pattern '[old_pattern]' --rewrite '[new_pattern]' --lang ts src/
```

### Grep for text patterns:

```bash
grep -rn "[search_term]" src/ --include="*.ts"
```

## 1.3: Consolidate Results

Fold the sequential explore-pass outputs and direct-tool findings into one working notes block before moving to Phase 2.

**Mark step 1 as done in the checklist once all passes are consolidated.**

---

# PHASE 2: BUILD CODEMAP (DEPENDENCY MAPPING)

**Mark step 2 as in progress in the checklist.**

## 2.1: Construct Definitive Codemap

Based on Phase 1 results, build:

```
## CODEMAP: [TARGET]

### Core Files (Direct Impact)
- `path/to/file.ts:L10-L50` - Primary definition
- `path/to/file2.ts:L25` - Key usage

### Dependency Graph
[TARGET]
├── imports from:
│   ├── module-a (types)
│   └── module-b (utils)
├── imported by:
│   ├── consumer-1.ts
│   ├── consumer-2.ts
│   └── consumer-3.ts
└── used by:
    ├── handler.ts (direct call)
    └── service.ts (dependency injection)

### Impact Zones
| Zone | Risk Level | Files Affected | Test Coverage |
|------|------------|----------------|---------------|
| Core | HIGH | 3 files | 85% covered |
| Consumers | MEDIUM | 8 files | 70% covered |
| Edge | LOW | 2 files | 50% covered |

### Established Patterns
- Pattern A: [description] - used in N places
- Pattern B: [description] - established convention
```

## 2.2: Identify Refactoring Constraints

Based on codemap:
- **MUST follow**: [existing patterns identified]
- **MUST NOT break**: [critical dependencies]
- **Safe to change**: [isolated code zones]
- **Requires migration**: [breaking changes impact]

**Mark step 2 as done in the checklist.**

---

# PHASE 3: TEST ASSESSMENT (VERIFICATION STRATEGY)

**Mark step 3 as in progress in the checklist.**

## 3.1: Detect Test Infrastructure

```bash
# Check for test commands
cat package.json | jq '.scripts | keys[] | select(test("test"))'

# Or for Python
ls -la pytest.ini pyproject.toml setup.cfg

# Or for Go
ls -la *_test.go
```

## 3.2: Analyze Test Coverage

Spawn `explore` as a Kiro subagent (synchronously — you need the answer before proceeding) to analyze test coverage for [TARGET]:
1. Which test files cover this code?
2. What test cases exist?
3. Are there integration tests?
4. What edge cases are tested?
5. Estimated coverage percentage?

## 3.3: Determine Verification Strategy

Based on test analysis:

| Coverage Level | Strategy |
|----------------|----------|
| HIGH (>80%) | Run existing tests after each step |
| MEDIUM (50-80%) | Run tests + add safety assertions |
| LOW (<50%) | **PAUSE**: Propose adding tests first |
| NONE | **BLOCK**: Refuse aggressive refactoring |

**If coverage is LOW or NONE, ask user:**

```
Test coverage for [TARGET] is [LEVEL].

**Risk Assessment**: Refactoring without adequate tests is dangerous.

Options:
1. Add tests first, then refactor (RECOMMENDED)
2. Proceed with extra caution, manual verification required
3. Abort refactoring

Which approach do you prefer?
```

## 3.4: Document Verification Plan

```
## VERIFICATION PLAN

### Test Commands
- Unit: `bun test` / `npm test` / `pytest` / etc.
- Integration: [command if exists]
- Type check: `tsc --noEmit` / `pyright` / etc.

### Verification Checkpoints
After each refactoring step:
1. `code` tool diagnostics → zero new errors
2. Run test command → all pass
3. Type check → clean

### Regression Indicators
- [Specific test that must pass]
- [Behavior that must be preserved]
- [API contract that must not change]
```

**Mark step 3 as done in the checklist.**

---

# PHASE 4: PLAN GENERATION (`/omo-plan` HANDOFF)

**Mark step 4 as in progress in the checklist.**

## 4.1: Hand Off to `/omo-plan`

Invoke `/omo-plan` with a prompt containing:

```
Create a detailed refactoring plan:

## Refactoring Goal
[User's original request]

## Codemap (from Phase 2)
[Insert codemap here]

## Test Coverage (from Phase 3)
[Insert verification plan here]

## Constraints
- MUST follow existing patterns: [list]
- MUST NOT break: [critical paths]
- MUST run tests after each step

## Requirements
1. Break down into atomic refactoring steps
2. Each step must be independently verifiable
3. Order steps by dependency (what must happen first)
4. Specify exact files and line ranges for each step
5. Include rollback strategy for each step
6. Define commit checkpoints
```

## 4.2: Review and Validate Plan

After receiving the plan from `/omo-plan`:

1. **Verify completeness**: All identified files addressed?
2. **Verify safety**: Each step reversible?
3. **Verify order**: Dependencies respected?
4. **Verify verification**: Test commands specified?

## 4.3: Expand the Checklist

Convert the plan's steps into a granular numbered checklist in your response, e.g.:

```
5.1  Step 1: [description]
5.1v Verify Step 1: run tests
5.2  Step 2: [description]
5.2v Verify Step 2: run tests
...continue for all steps
```

**Mark step 4 as done in the checklist.**

---

# PHASE 5: EXECUTE REFACTORING (DETERMINISTIC EXECUTION)

**Mark step 5 as in progress in the checklist.**

## 5.1: Execution Protocol

For EACH refactoring step:

### Pre-Step
1. Mark the step's checklist entry as in progress
2. Read current file state
3. Capture `code` tool diagnostics as baseline

### Execute Step
Use appropriate tool:

**For Symbol Renames:**
Use the `code` tool's rename operation (prepare-rename validation, then execute the rename) — this is the LSP-backed rename Kiro exposes through `code`, not a raw `lsp_rename` call.

**For Pattern Transformations:**
```bash
# Preview first
sg --pattern '[pattern]' --rewrite '[rewrite]' --lang ts path/to/file.ts

# If preview looks good, execute
sg --pattern '[pattern]' --rewrite '[rewrite]' --lang ts path/to/file.ts --update-all
```
See `/omo-ast-grep` for the full `sg` workflow and flags.

**For Structural Changes:**
Use the `write`/edit tool for precise changes to the file.

### Post-Step Verification (MANDATORY)

1. Check diagnostics via the `code` tool — must be clean or same as baseline
2. Run tests: `bash("bun test")` (or the appropriate test command)
3. Type check: `bash("tsc --noEmit")` (or the appropriate type check)

### Step Completion
1. If verification passes → mark the step's checklist entry as done
2. If verification fails → **STOP AND FIX**

## 5.2: Failure Recovery Protocol

If ANY verification fails:

1. **STOP** immediately
2. **REVERT** the failed change
3. **DIAGNOSE** what went wrong
4. **OPTIONS**:
   - Fix the issue and retry
   - Skip this step (if optional)
   - Spawn `oracle` as a Kiro subagent for help
   - Ask user for guidance

**NEVER proceed to next step with broken tests.**

## 5.3: Commit Checkpoints

After each logical group of changes:

```bash
git add [changed-files]
git commit -m "refactor(scope): description

[details of what was changed and why]"
```

**Mark step 5 as done in the checklist when all refactoring steps are complete.**

---

# PHASE 6: FINAL VERIFICATION (REGRESSION CHECK)

**Mark step 6 as in progress in the checklist.**

## 6.1: Full Test Suite

```bash
# Run complete test suite
bun test  # or npm test, pytest, go test, etc.
```

## 6.2: Type Check

```bash
# Full type check
tsc --noEmit  # or equivalent
```

## 6.3: Lint Check

```bash
# Run linter
eslint .  # or equivalent
```

## 6.4: Build Verification (if applicable)

```bash
# Ensure build still works
bun run build  # or npm run build, etc.
```

## 6.5: Final Diagnostics

For each changed file, run the `code` tool's diagnostics — must all be clean.

## 6.6: Generate Summary

```markdown
## Refactoring Complete

### What Changed
- [List of changes made]

### Files Modified
- `path/to/file.ts` - [what changed]
- `path/to/file2.ts` - [what changed]

### Verification Results
- Tests: PASSED (X/Y passing)
- Type Check: CLEAN
- Lint: CLEAN
- Build: SUCCESS

### No Regressions Detected
All existing tests pass. No new errors introduced.
```

**Mark step 6 as done in the checklist.**

---

# CRITICAL RULES

## NEVER DO
- Skip the `code` tool diagnostics check after changes
- Proceed with failing tests
- Make changes without understanding impact
- Use `as any`, `@ts-ignore`, `@ts-expect-error`
- Delete tests to make them pass
- Commit broken code
- Refactor without understanding existing patterns

## ALWAYS DO
- Understand before changing
- Preview before applying (`sg --pattern ... --rewrite ... --lang ...`)
- Verify after every change
- Follow existing codebase patterns
- Keep the checklist updated in real-time
- Commit at logical checkpoints
- Report issues immediately

## ABORT CONDITIONS
If any of these occur, **STOP and consult user**:
- Test coverage is zero for target code
- Changes would break public API
- Refactoring scope is unclear
- 3 consecutive verification failures
- User-defined constraints violated

---

# Tool Usage Philosophy

You already know these tools. Use them intelligently:

## `code` tool
Leverage the `code` tool (Tree-sitter + LSP) for precision analysis. Key patterns:
- **Understand before changing**: go-to-definition to grasp context
- **Impact analysis**: find-references to map all usages before modification
- **Safe refactoring**: prepare-rename → rename for symbol renames
- **Continuous verification**: diagnostics after every change

## AST-Grep
Use `/omo-ast-grep` or the `sg` CLI directly for structural transformations.
**Critical**: Always preview first, review, then execute.

## Subagents
- `explore`: sequential codebase pattern discovery (one pass at a time — see Phase 1)
- `/omo-plan`: detailed refactoring plan generation (see Phase 4)
- `oracle`: read-only consultation for complex architectural decisions and debugging
- `librarian`: **Use proactively** when encountering deprecated methods or library migration tasks. Query official docs and OSS examples for modern replacements.

## Deprecated Code & Library Migration
When you encounter deprecated methods/APIs during refactoring:
1. Spawn `librarian` as a Kiro subagent to find the recommended modern alternative
2. **DO NOT auto-upgrade to latest version** unless user explicitly requests migration
3. If user requests library migration, use `librarian` to fetch latest API docs before making changes

---

**Remember: Refactoring without tests is reckless. Refactoring without understanding is destructive. This command ensures you do neither.**

<user-request>
$ARGUMENTS
</user-request>
