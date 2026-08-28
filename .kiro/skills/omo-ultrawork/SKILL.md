---
name: omo-ultrawork
description: Autonomous end-to-end implementation in Kiro. Use when the user wants a bounded coding goal built, verified, and committed without a formal plan first, says figure it out, just do it, or asks for deep autonomous work. Declares a binding stop condition, defines scenario QA, implements test-first, verifies on real surfaces, and commits per increment.
---

# OMO Ultrawork

Build `$ARGUMENTS`.

## 1. Pick the worker

- `sisyphus` — orchestration-heavy autonomous work, the default.
- `hephaestus` — deep single-thread execution on a complex implementation.
- `/omo-plan` — **only** when open design decisions remain after context gathering. A known
  procedure never needs a plan, however many steps it has.

## 2. Register the goal (BINDING)

Before implementing, state one line naming the exact observable state that ends the run:

> I'll stop right away when `<observable condition>`.

Name a state, not an intention. For multi-turn work, record it with `/omo-goal` so it survives the
turn. The moment the condition holds, answer and stop — no bonus verification, no polish loop, no
unrequested review round.

## 3. Scenario contract

Name at least three scenarios before coding: the happy path, an edge case, and an adjacent
regression the change could cause. Each gets a binary pass condition and a real-surface evidence
channel (command + output, request + response, rendered capture). "The tests pass" is not a
scenario.

## 4. Explore, then implement

`code` tool → `rg` → `sg` via `/omo-ast-grep`. Read before changing unfamiliar code. Prefer existing
patterns and helpers. Keep changes scoped to the goal — no unrequested features, dependencies, or
adjacent refactors.

**TDD floor**: write the failing check first, watch it fail for the right reason, then make it pass.
Exempt: pure formatting, comment-only edits, dependency bumps, and rename-only changes.

## 5. Verify on the real surface

Run the scenario QA, not just the unit tests. Run the `code` tool's diagnostics. For UI or TUI work,
use `/omo-visual-qa` for capture and review, and `/omo-frontend` for design decisions.
Never use `tmux capture-pane` as evidence — it degrades color and CJK width.

Re-run only the checks a fix actually affects.

## 6. Commit per increment

One atomic commit per verified increment, never an end-of-run omnibus. Study `git log --oneline -20`
and `git log -5 -- <touched paths>` before composing each message and match the repository's style.
Use `/omo-git-master`.

## 7. Review gate (when it triggers)

Trigger on user rigor language, 3+ changed files, or refactor/migration/security work: run
`/omo-review-work`, or consult `oracle`.

Verify each concern yourself. A concern blocks only when it names a success criterion the evidence
fails; the rest are notes. Fix the blockers, re-run only the affected QA, and resubmit **at most
twice** — then surface what remains to the user rather than looping.

## 8. Escalate and record

Consult `oracle` after two failed fix attempts, or for a high-stakes architecture or security call.
Save a durable learning to `.kiro/omo/learnings/` only when it will help future work.

## Handoff template

```markdown
## Handoff to <sisyphus | hephaestus>
**GOAL**: $ARGUMENTS
**STOP WHEN**: <the exact observable state that ends this run>
**EVIDENCE**: the scenario QA commands and their real output, the diff, and the commits.
**Constraints**: scope to the request; test-first; verify on the real surface; commit per increment.
```
