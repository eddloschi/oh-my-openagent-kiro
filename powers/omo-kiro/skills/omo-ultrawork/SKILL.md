---
name: omo-ultrawork
description: Run the OMO ultrawork/deep-work execution style in Kiro. Use when the user wants autonomous end-to-end implementation, asks to figure it out, or gives a bounded coding goal without requiring a formal plan first.
---

# OMO Ultrawork

Use this workflow for `$ARGUMENTS`.

1. Choose `sisyphus` for orchestration-heavy autonomous work.
2. Choose `hephaestus` for GPT-family deep execution.
3. Explore before editing when the codebase area is unfamiliar.
4. Keep changes scoped to the requested goal.
5. Verify with concrete commands before final response.
6. Escalate to `oracle` after repeated failed attempts or high-stakes architecture/security concerns.
7. Save durable learnings under `.kiro/omo/learnings/` only when they are likely to help future work.

Handoff template:

```markdown
## Handoff to Sisyphus or Hephaestus
**Goal**: $ARGUMENTS
**Mode**: Autonomous bounded implementation.
**Expected output**: Completed code changes, verification evidence, concise summary.
```
