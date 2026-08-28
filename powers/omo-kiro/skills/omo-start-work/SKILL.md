---
name: omo-start-work
description: Execute an OMO/Kiro work plan end to end. Use when the user says start work, execute plan, continue plan, resume plan, implement from a saved plan, ship this, or gives a .kiro/omo/plans/*.md path. Registers a goal and every task, executes each plan checkbox with its own QA, verifies every done-claim independently, and delivers directly or as a pull request.
---

# OMO Start Work

Execute `$ARGUMENTS`. Swap to `atlas`.

## 1. Select the plan

In order: a path in the request → `active_plan` in `.kiro/omo/boulder.json` → the only plan in
`.kiro/omo/plans/` → otherwise list candidates and ask.

If there is **no** selectable plan, bootstrap through `/omo-plan` first. In that case the user's
"start work" counts as approval to generate the plan, but execution still starts only after the plan
file exists.

Re-read the plan from disk every time.

## 2. Goal + task registration (MANDATORY, before any work)

**Goal** — write `.kiro/omo/goal.md` with the plan name and path, the concrete end state, the shape
(N todos + F final tasks, counted), the delivery mode, the binding `STOP WHEN` condition, and how
completion will be verified. One work session = one goal. See `/omo-goal`.

**Tasks** — decompose every plan task into implementation-level sub-steps and list them all, grouped
by wave, before starting. Mark in progress when work starts, done immediately after its verification
passes. Never batch-complete. Never run work that is not a registered task; append discovered work
as a task before doing it.

## 3. Session state and notepads

Write `.kiro/omo/boulder.json` (`schema_version`, `active_work_id`, and per-work `active_plan`,
`plan_name`, `status`, `worktree_path`, `started_at`). Scaffold
`.kiro/omo/notepads/<plan-slug>/{learnings,decisions,issues,problems}.md` and append to them as you
go — `edit` or shell `>>`, never overwrite.

## 4. Execute

Work the next unchecked `- [ ] N.` row in plan order unless a dependency requires otherwise. Keep
changes in scope. Delegate a bounded, clearly specified sub-step to `sisyphus-junior` with
GOAL / STOP WHEN / EVIDENCE — one subagent at a time; Kiro subagents are sequential.

Per task: run the plan's QA (happy and failure), run the `code` tool's diagnostics on the touched
area, then commit the verified increment matching repository history style (`/omo-git-master`).

## 5. Verify before you check the box

Produce a **DoneClaim** — files changed, commands run, manual-QA channel, evidence path — then
verify it yourself by re-running the cited check and reading the real output. A subagent summary or
a quoted log you did not produce is a claim, not proof. Only then mark the checkbox and append a
line to `.kiro/omo/start-work/ledger.jsonl`.

Build and test commands come from the plan's `## Success criteria` / `## Verification strategy`, or
from project detection — never assume a toolchain. For UI or TUI evidence use `/omo-visual-qa`;
never `tmux capture-pane`.

## 6. Final verification wave

Run each F-task, one at a time. Classify each: **approve** (met, with evidence), **reject** (not met
— fix or record the blocker), **missing** (the plan gave no checkable criterion — say so, do not
invent a pass). Surface the results and wait for the user before declaring complete.

## 7. Deliver

- default — work in the current tree.
- `--worktree <abs-path>` — `git worktree add`, work there, merge back on completion unless told
  otherwise.
- `--make-pr` — implies a worktree; push the branch, open a PR with `gh pr create`, hand off the URL.
  Merge only on an explicit ask.
- `--ship` — implies `--make-pr`; keep working until the PR is merged (CI and review addressed), then
  clean up the worktree and sync `.kiro/omo/` state back.

If `gh` is unavailable, say so, push the branch if a remote exists, and hand off the branch name and
compare URL. Do not silently degrade.

Run a completion audit against the goal's `STOP WHEN` before declaring done, then set boulder status
`complete` and clear `.kiro/omo/goal.md`.

## Handoff template

```markdown
## Handoff to Atlas
**GOAL**: execute $ARGUMENTS to its stated end state.
**STOP WHEN**: every `- [ ] N.` row is checked with verified evidence, the F-wave is approved, and
the delivery mode's artifact exists (merged branch, PR URL, or working-tree diff).
**EVIDENCE**: the ledger at `.kiro/omo/start-work/ledger.jsonl`, the exact verification commands and
their output, and the final diff.
**Constraints**: plan scope only; sequential subagents; verify every done-claim independently.
```
