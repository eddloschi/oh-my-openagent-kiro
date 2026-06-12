---
name: omo-plan
description: Create an OMO-style implementation plan in Kiro. Use when the user asks to plan, design steps, prepare work, create a task plan, or convert a goal into an executable markdown plan.
---

# OMO Plan

Use this workflow for `$ARGUMENTS`.

1. Swap to `prometheus`.
2. Gather codebase context before writing.
3. Consult `metis` first if the request has unclear intent, hidden requirements, architecture impact, or broad research needs.
4. Write a markdown plan under `.kiro/omo/plans/`.
5. Follow `steering/plan-format.md`.
6. Include must-have scope, explicit non-goals, ordered checkbox tasks, acceptance criteria, QA scenarios, and final verification.
7. Recommend `momus` review before implementation for multi-file or high-risk plans.

Handoff template:

```markdown
## Handoff to Prometheus
**Goal**: $ARGUMENTS
**Expected output**: Markdown plan saved under `.kiro/omo/plans/`.
**Constraints**: Kiro-native workflow, no OpenCode-only tools. Use Kiro CLI agent consultations or explicit swaps for specialist review.
```
