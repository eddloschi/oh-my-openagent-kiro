---
name: omo-review-work
description: Post-implementation review of completed work across five lanes - goal and constraint verification, code quality, security, hands-on QA execution, and context mining. Use before a PR handoff, when the user asks to review completed work, check what I just built, or verify the change is done properly. All five lanes must pass; any failure fails the review.
---

# OMO Review Work

Review the completed work described by `$ARGUMENTS` (or the current diff if no scope given).

Five lanes, run **sequentially** — Kiro subagents block, one at a time. This takes materially longer
than the upstream parallel version; that is expected, and worth saying to the user up front.
**All five must PASS.** Any FAIL fails the review. A lane you could not resolve is INCONCLUSIVE and
never counts as a pass.

## Phase 0 — Gather review context

Collect these once; every lane is fed from them.

```bash
git diff --name-only            # changed files (add a base ref if reviewing a branch)
git diff                        # the actual diff
git log --oneline -10
```

Also assemble:

- **GOAL** — the user's original request and every clarification, quoted.
- **CONSTRAINTS** — every rule, requirement, and limitation stated during the work, verbatim.
- **BACKGROUND** — why the work was needed.
- **RUN COMMAND** — how to start the app for QA. Check the package manifest's dev/start scripts, a
  Makefile default target, or a compose file.

Work in a review worktree when the tree is dirty with unrelated changes:
`git worktree add <path> <ref>`.

Unlike upstream's context-only reviewer, Kiro's `oracle` has `read` — give it paths and let it read
the files rather than pasting whole files into the prompt. Still paste the diff and the goal.

## Lane 1 — Goal and constraint verification (`oracle`)

*Did we build exactly what was asked, within the rules we were given?*

1. **Goal completeness** — break the goal into every sub-requirement, explicit and implied. Mark each
   ACHIEVED / MISSED / PARTIAL with code evidence. A missed implied requirement a reasonable engineer
   would have addressed is PARTIAL at minimum.
2. **Constraint compliance** — list every constraint; verify each with specific code evidence. A
   violated constraint is an automatic FAIL.
3. **Requirement gaps** — what the user clearly wanted but did not spell out.
4. **Over-engineering** — anything added that was not requested: unnecessary abstractions, extra
   features, premature optimization, speculative generality. Flag as scope creep.
5. **Edge cases** — trace at least five inputs or scenarios that would break this.
6. **Behavioral correctness** — walk the logic for 3+ representative scenarios.

## Lane 2 — Code quality (`oracle`)

Correctness, error handling and boundary conditions, naming, duplication, dead code, test coverage
of the *changed behavior*, and consistency with the surrounding patterns. Judge against the
repository's conventions, not a generic style guide.

## Lane 3 — Security (`oracle`)

Input validation, injection surfaces, authz/authn on new paths, secret handling, unsafe defaults,
dependency risk, and anything the diff exposes that was previously internal.

## Lane 4 — Context mining

What did the implementer miss because it lived outside the diff?

1. `explore` — cross-references in the repo: callers, sibling implementations, tests that should
   have changed, docs that now contradict the code.
2. `librarian` — external docs or issues bearing on the change.
3. If `gh` is installed: `gh issue list`, `gh pr list`, and related issue bodies for requirements
   stated outside this session. If it is not installed, skip with a one-line note.

Slack and Notion mining from upstream have no equivalent here — this port has no such MCP.

## Lane 5 — QA execution (run it yourself)

Do not delegate this lane: the orchestrating agent has `shell` and `write` and can drive the real
app, while a subagent cannot hand a live session back.

1. **Brainstorm scenarios** — how would a user actually exercise this change?
2. **Augment** — add the failure paths, the boundary inputs, and the adjacent regression.
3. **List them** as concrete steps with binary pass conditions.
4. **Execute** each against the running app, capturing real output as evidence.
5. **Compile** results — each scenario PASS or FAIL with the evidence path.

For UI or TUI surfaces, run `/omo-visual-qa`. Never `tmux capture-pane`.

## Lane prompt shape

Every spawn carries the handoff contract (`steering/orchestration.md`):

```markdown
**GOAL**: return a PASS / FAIL / INCONCLUSIVE verdict for the <lane name> review of this change.
**STOP WHEN**: you have a verdict with per-criterion evidence and, if FAIL, the blocking issues.
**EVIDENCE**: specific file paths and line references for every finding.
**Original goal**: <quoted>
**Constraints**: <verbatim>
**Changed files**: <paths — read them yourself>
**Diff**: <the diff>
```

Each lane returns:

```markdown
<verdict>PASS | FAIL | INCONCLUSIVE</verdict>
<confidence>HIGH | MEDIUM | LOW</confidence>
<summary>1-3 sentences</summary>
<findings>- [PASS/FAIL/WARN] Category: description — file:line — evidence</findings>
<blocking_issues>must-fix items; empty if PASS</blocking_issues>
```

## Phase 3 — Verdict

Verify each lane's findings yourself before accepting them: a lane's output is a claim, and a
finding that cites no criterion is a note, not a blocker.

```markdown
# Review Work — Final Report

## Overall verdict: PASSED | FAILED | INCONCLUSIVE

| Lane | Verdict | Confidence |
|---|---|---|
| Goal & constraints | | |
| Code quality | | |
| Security | | |
| Context mining | | |
| QA execution | | |

## Blocking issues
1. <issue> — file:line — why it blocks

## Key findings

## Recommendations
```

After a FAILED verdict: fix the criterion-cited blockers, then re-run only the affected lanes.
At most two rounds — then surface what remains to the user rather than looping.
