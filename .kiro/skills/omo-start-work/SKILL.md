---
name: omo-start-work
description: Execute an existing OMO/Kiro markdown plan. Use when the user says start work, continue a plan, implement from a saved plan, or gives a .kiro/omo/plans/*.md path.
---

# OMO Start Work

Use this workflow for `$ARGUMENTS`.

1. Confirm exactly one markdown plan path, preferably `.kiro/omo/plans/*.md`.
2. Swap to `atlas`.
3. Re-read the plan from disk before editing.
4. Execute tasks in order unless dependencies require a clearly stated change.
5. Mark checkboxes as each task is completed.
6. Run the QA scenarios and final verification commands from the plan.
7. Record any deviations in the plan or a note under `.kiro/omo/drafts/`.

Handoff template:

```markdown
## Handoff to Atlas
**Plan path**: $ARGUMENTS
**Expected output**: Implement the plan, update checkboxes, run verification, summarize evidence.
```
