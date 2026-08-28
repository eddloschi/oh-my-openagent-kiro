---
name: omo-review-plan
description: Dual high-accuracy review of an OMO/Kiro implementation plan before work starts. Use when the user asks to review, validate, critique, approve, or high-accuracy-check a .kiro/omo/plans/*.md plan. Runs momus and an independent oracle review of the same plan file and requires both to approve.
---

# OMO Review Plan

Review `$ARGUMENTS`.

## 1. Resolve exactly one plan path

Extract one `.kiro/omo/plans/*.md` path. A legacy `.omo/plans/*.md` path is accepted with a note
recommending the Kiro location. If none or several are present, ask for one.

Read the plan yourself first and compute its digest:

```bash
shasum -a 256 .kiro/omo/plans/<slug>.md
```

That digest binds this review round. Any edit to the plan invalidates the round.

## 2. Lane 1 — momus

Spawn `momus` with the **literal** plan path and the literal digest, and the instruction that its
first action is to read that exact path. Never hand it a summary, a field name, or a search hint.

## 3. Lane 2 — independent oracle

Then spawn `oracle` as the independent reviewer, with the same literal path and digest, reading the
plan fresh. It must not receive Momus's verdict or summary — the value of the lane is that it is
independent.

Kiro subagents are sequential, so lane 2 starts after lane 1 returns. This is slower than upstream's
parallel review; that is expected.

## 4. Aggregate

- Both `[OKAY]` → the plan passes. Report both verdicts.
- Any `[REJECT]` → the plan fails. Report the blocking issues (at most three per reviewer), fix
  them, then run a **fresh** round of both lanes against the updated plan and its new digest.
- Any `[INCONCLUSIVE]` → that lane is unresolved, never approval. Fix the retrieval problem and
  re-run the lane.

**At most two rounds.** If criterion-cited blockers remain after the second, stop and surface them
to the user rather than looping.

Before reporting a pass, re-read the plan and confirm the digest still matches the reviewed round.

## Handoff template

```markdown
## Handoff to <momus | oracle>
**GOAL**: decide whether this plan can be executed as written.
**STOP WHEN**: you return exactly one of [OKAY], [REJECT] (≤3 blocking issues), or [INCONCLUSIVE].
**EVIDENCE**: the literal path you read and the specific plan lines behind each issue.
**Plan path (literal)**: .kiro/omo/plans/<slug>.md
**Plan sha256 (literal)**: <digest>
**First action**: read that exact path. Do not search, do not use a summary, do not substitute
another file. If the read fails or the content does not match the digest, return [INCONCLUSIVE].
```
