---
name: omo-handoff
description: Produce a handoff context block to continue this work in a fresh session. Use when the session is getting long, quality is degrading, the context window is filling up, or the user asks to hand off, wrap up for a new session, or summarize context for continuation.
---

# OMO Handoff

Create a handoff summary covering `$ARGUMENTS` (or the whole session if no scope was given).

## 1. Check there is something to hand off

If the session has no meaningful work or context, say so instead of manufacturing a summary.

## 2. Gather concrete state

Kiro has no session-read tool, so the conversation in your context IS the record of what the user
asked. Quote it verbatim; do not paraphrase, tidy, or reconstruct a request you are unsure of. If
early turns were summarized away and you cannot quote a request exactly, say that explicitly in the
output rather than guessing.

Then gather the programmatic state:

```bash
git status --porcelain
git diff --stat
git log --oneline -10
```

Plus, when they exist: `.kiro/omo/goal.md` (the active objective and its stop condition),
`.kiro/omo/boulder.json` (active plan and status), the unchecked rows of the active plan under
`.kiro/omo/plans/`, and any notepad files under `.kiro/omo/notepads/<plan>/`.

## 3. Extract

Write in the first person ("I did…", "you told me…"). Focus on capabilities, decisions, and what
matters for continuing — not a file-by-file replay. Skip variable names, storage keys, and constants
unless they are load-bearing. Constraints must be verbatim; never invent one.

Ask yourself: what did I just implement? What instructions are still in force? Which files matter?
Was there a plan or spec to carry over? What did I discover (APIs, patterns, gotchas)? What is still
open?

## 4. Output this exact block

```
HANDOFF CONTEXT
===============

USER REQUESTS (AS-IS)
---------------------
- [exact verbatim user requests — not paraphrased]

GOAL
----
[one sentence: what should be done next]

WORK COMPLETED
--------------
- [first-person bullets of what was done, with file paths where relevant]
- [key implementation decisions]

CURRENT STATE
-------------
- [state of the codebase or task]
- [build/test status]
- [uncommitted changes, active branch or worktree]

PENDING TASKS
-------------
- [unchecked plan rows or remaining steps, in order]

KEY FILES
---------
- [at most 10 paths, each with one line on why it matters]

IMPORTANT DECISIONS
-------------------
- [decision — and the reason it was made]

EXPLICIT CONSTRAINTS
--------------------
- [verbatim constraints the user stated]

CONTEXT FOR CONTINUATION
------------------------
- [anything the next session would otherwise re-derive or get wrong]
```

## 5. Tell the user how to use it

Paste the block as the first message of a new `kiro-cli chat` session (or a fresh Kiro IDE chat).
State state lives on disk under `.kiro/omo/`, so a new session picks up the goal, plan, boulder
state, and notepads on its own.
