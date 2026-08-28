# OMO Plan Format

Plans live in `.kiro/omo/plans/<slug>.md`, drafts in `.kiro/omo/drafts/<slug>.md`. Both are
created by `.kiro/skills/omo-plan/scripts/scaffold-plan.mjs` — never hand-build the skeleton.

## Template (headers verbatim, in this order)

```markdown
# <slug> - Work Plan
## TL;DR (For humans)
## Scope
## Verification strategy
## Execution strategy
## Todos
## Final verification wave
## Commit strategy
## Success criteria
```

`## TL;DR (For humans)` is written LAST, after the detailed plan, and covers: what you'll get,
why this approach, what it will NOT do, effort, risk, and the decisions made for the user.
`## Scope` states Must have and Must NOT have explicitly.

## Task row grammar (strict)

- Implementation rows: `- [ ] N. <title>` where `N` is a positive integer.
- Final verification rows: `- [ ] F<n>. <title>`.
- Both start at column zero. Prose headings, numbered paragraphs, and ordinary bullets are **not**
  task substitutes and are never counted as tasks.

Before handing a plan off, run a structural self-check: every implementation and final-verifier row
is column-zero and matches its grammar, sits in the right section, and no prose is standing in for
a task. Repair the plan before handoff if any check fails.

## Per-task content

Each todo carries:

- **References** — exact paths and patterns to follow. The executor has no interview context, so be
  exhaustive; "every X in Y" beats a vague pointer.
- **Acceptance criteria** — agent-executable, zero human judgment.
- **QA** — a happy-path and a failure-path scenario, each with the exact command or tool invocation
  and an evidence path.
- **Commit** — the commit this task produces.

Target 5-8 todos per wave; fewer than 3 (outside the final wave) usually means under-splitting.
Implementation + its test are ONE todo.

## Final verification wave

After all todos, F-tasks that must all pass: plan-compliance audit, code-quality review, real
manual QA, and scope fidelity. Surface the results and wait for the user before declaring done.

## Scope rule

**Full scope is the default.** Plan the entire request. "MVP", "v1", "phase 1", or any reduced
subset is never something you invent or offer — it exists only if the user introduces it. Scope-OUT
and Must-NOT-Have entries are guardrails against unrequested additions, never reductions of the
request.
