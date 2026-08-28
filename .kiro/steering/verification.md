# Verification Discipline

Verification must be concrete and reproducible.

- Prefer project-native tests, type checks, linters, build commands, and smoke checks.
- Include exact commands and expected outcomes.
- Source build/test commands from the plan's `## Success criteria`, or detect them from the project
  (package manifest scripts, Makefile, task runner). Never assume a specific toolchain.
- For API work, include concrete request examples and expected status/body shape.
- For UI work, include selectors, viewport assumptions, and screenshot checks via `/omo-visual-qa`.
- For refactors, verify behavior before and after meaningful change groups.
- If a command cannot run in the current environment, record why and identify the closest available
  check.

Avoid vague criteria such as "verify it works" or "check manually".

## Prose deliverables

A prompt, `SKILL.md`, steering doc, or other instruction file has no behavioral seam. Verify it by
reading it against the intended behavior, or by a machine-consumed assertion (a parsed frontmatter
field, a runtime-checked sentinel, JSON through its real validator). Never accept a text-grep,
word-count, or phrase-presence check as acceptance criteria for prose: that pins a diff, not
behavior.

## Commit discipline

Commit frequently: one atomic commit per verified increment (test red → green, evidence captured),
never one end-of-run omnibus. Before composing each message, study the history and match it:

```bash
git log --oneline -20
git log -5 -- <touched paths>
```

Match subject shape, scope names, message language, body style, and typical commit size. Use the
`/omo-git-master` skill for the commit workflow. Skip committing only when the user forbade it.

## Reviewer gate

Trigger a review pass when the user asked for rigor, when 3+ files changed, or for
refactor/migration/security work.

1. Verify each reviewer concern yourself against the evidence.
2. A concern **blocks** only when it names a success criterion the evidence fails. Record concerns
   that cite no criterion as notes with a one-line reason; fix or decline at your judgment.
3. Fix every criterion-cited blocker, re-run only the QA affected by the fix, capture fresh evidence.
4. Re-submit to the same reviewer **at most twice**, passing the delta diff, the cited blockers, and
   the already-approved criteria marked out of scope. An approval whose remaining items are all
   notes counts as approval.
5. If criterion-cited blockers remain after two re-reviews, stop and surface them to the user. Do
   not loop further.

## Terminal UI evidence

Never use `tmux capture-pane` as evidence — it degrades color and CJK column width. Capture TUI
output through the `/omo-visual-qa` skill's xterm.js render instead.
