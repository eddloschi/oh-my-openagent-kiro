---
name: omo-review-plan
description: Review an OMO/Kiro implementation plan for blockers. Use when the user asks to review, validate, critique, or approve a .kiro/omo/plans/*.md plan before work starts.
---

# OMO Review Plan

Use this workflow for `$ARGUMENTS`.

1. Swap to `momus`.
2. Extract exactly one markdown plan path.
3. Re-read the plan from disk every time.
4. Verify referenced files and claimed patterns.
5. Check whether each task can start and has executable QA.
6. Return `[OKAY]` or `[REJECT]`.
7. If rejecting, list at most three blocking issues with exact fixes.

Handoff template:

```markdown
## Handoff to Momus
**Plan path**: $ARGUMENTS
**Expected output**: `[OKAY]` or `[REJECT]` with blocker-only review.
```
