# OMO Orchestration Discipline

Use official Kiro subagents for specialist consultations rather than hidden OpenCode-style delegation.

- For planning, use `/omo-plan` or swap to `prometheus`.
- For execution from a plan, use `/omo-start-work` or swap to `atlas`.
- For autonomous bounded implementation, swap to `sisyphus` or `hephaestus`.
- For pre-planning critique, swap to `metis`.
- For plan review, swap to `momus` (and `oracle` as the independent second reviewer).
- For review of completed work, use `/omo-review-work`.
- For local codebase search, swap to `explore`.
- For external library or source research, swap to `librarian`.
- For high-stakes architecture/debugging advice, swap to `oracle`.
- For image, PDF, or diagram interpretation, swap to `multimodal-looker`.
- For a small bounded edit inside larger work, delegate to `sisyphus-junior`.

## Handoff Contract (MANDATORY)

Every subagent spawn carries these fields. A spawn without them is a defect: the child has no
conversation context and will either over-run its scope or stop too early.

```markdown
## Handoff to <agent>
**GOAL**: the single outcome that makes this child done.
**STOP WHEN**: the exact observable condition that ends the child's work.
**EVIDENCE**: what the child returns to prove it — command output, file paths, diff, artifact.
**TASK**: what to do.
**DELIVERABLE**: the shape of the answer.
**SCOPE**: what is in and explicitly out.
**VERIFY**: how the child checks itself before answering.
**Context gathered**: facts the child would otherwise re-derive.
**Files or paths**:
```

`GOAL` / `STOP WHEN` / `EVIDENCE` are not optional prose. Name an observable state, not an
intention: "STOP WHEN `bun test src/auth` exits 0 and the new case appears in the output", not
"STOP WHEN the tests look right".

## Sequential Only

Kiro subagents run **one at a time** and block until they return. There is no background task
manager, no `run_in_background`, and no parallel fan-out. Never write or imply an instruction to
"dispatch these in one turn" or "run these in parallel" — plan the order instead, put the
cheapest disambiguating call first, and stop spawning as soon as the answer is settled.

Where a workflow inherits a parallel design from upstream (multi-lane review, multi-hypothesis
debugging), run the lanes sequentially and say so, so the user understands the extra wall-clock.

## Waiting Discipline

Because a spawn blocks, there is nothing to poll. Act on the child's output the moment it returns.

- Do not re-run a validation whose inputs did not change.
- Do not re-explore to double-check a fact you already have with a path.
- Do not spend a turn restating status. If work remains, do the next step.

## Claims, Not Approval

A subagent's output is a **claim** until you verify it against the `EVIDENCE` you asked for. A
summary, a "looks good", or a passing log quoted by a child is not proof that the command ran.
Re-run the cited check yourself when the claim gates a checkbox, a merge, or a done report.

## Fallbacks

When `subagent` is unavailable, use `/agent swap <name>`, or a separate non-interactive session:

```bash
kiro-cli chat --agent <name> --no-interactive --trust-tools=fs_read,read "<handoff prompt>"
```

Use read-only trusted tools for reviewers and consultants whenever possible. Treat specialist
output as evidence, then continue in the current session.
