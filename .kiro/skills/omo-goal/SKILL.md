---
name: omo-goal
description: Set, show, pause, resume, or clear the persistent objective for this work session. Use when the user says set a goal, what's the goal, pause the goal, resume, clear the goal, or when starting multi-turn autonomous work that must survive a context reset. Stores the objective and its binding stop condition in .kiro/omo/goal.md, which agent hooks surface back at the start of each turn.
---

# OMO Goal

Handle `$ARGUMENTS`.

The goal lives in `.kiro/omo/goal.md`. The `sisyphus`, `hephaestus`, `atlas`, and `prometheus`
agents carry a `userPromptSubmit` hook that prints this file at the start of every turn, so the
objective survives a long session or a context reset.

**Kiro has no idle continuation.** Upstream's `/goal` re-injects a prompt when the session goes
quiet; Kiro does not. This file is a durable contract you re-read, not a scheduler. Say so if the
user expects the agent to keep working unattended.

## Subcommands

| Input | Action |
|---|---|
| `<objective>` | Set or replace the active goal. |
| *(empty)* or `show` | Read `.kiro/omo/goal.md` and print it. Say "no active goal" when absent. |
| `pause` | Set `status: paused`. Leave the body intact. |
| `resume` | Set `status: active`. |
| `clear` | Delete the file — but run the completion audit first (below). |

## Setting a goal

Write `.kiro/omo/goal.md`:

```markdown
---
status: active
created: <iso8601>
---
# Goal

<the objective, in full — not an abbreviation of what the user said>

**End state**: the concrete things that will exist or behave differently when this is done.
**STOP WHEN**: the exact observable condition that ends the run.
**EVIDENCE**: what will prove it — commands, artifacts, paths.
**Out of scope**: what this goal explicitly does not cover.
```

`STOP WHEN` must name an observable state, not an intention. "when `bun test src/auth` exits 0 and
the 401 case appears in the output" is a stop condition; "when auth works" is not. A goal without a
usable stop condition is the main cause of a run that never ends — push back and get one.

## Working under a goal

- Each turn should make meaningful progress toward the goal.
- Focus on completing the objective fully, not partially.
- If stuck, change approach rather than repeating the failed one.
- Track progress with the plan checkboxes (when a plan exists) or a numbered checklist in your
  response.
- The moment `STOP WHEN` holds, report and stop. Do not add unrequested verification or polish.

## Completion audit (before clearing as done)

Do not clear a goal as complete on a feeling. Restate the objective and the `STOP WHEN` condition,
then check each against evidence you already captured — the commands you ran and their real output.
If any piece is unproven, the goal is not complete: either produce the evidence or say what is
missing. Only then delete the file.

`/omo-goal clear` on an abandoned goal is fine and needs no audit — say plainly that it was cleared
without being completed.
