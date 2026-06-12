---
name: omo-research
description: Run OMO-style research in Kiro. Use when the user asks to investigate a codebase area, external library, architecture option, source behavior, documentation, or unfamiliar pattern.
---

# OMO Research

Use this workflow for `$ARGUMENTS`.

1. Use `explore` for local repository discovery.
2. Use `librarian` for external library docs, source, issues, examples, and current behavior.
3. Use `oracle` for architecture trade-offs, repeated debugging failures, or high-risk decisions.
4. Synthesize evidence with file paths, links when available, and direct next steps.
5. State confidence and gaps.
6. Do not write files unless the user asks for a durable research note.

Handoff template:

```markdown
## Research Handoff
**Question**: $ARGUMENTS
**Scope**: Local codebase, external docs/source, or both.
**Expected output**: Evidence-backed answer with next steps and unresolved gaps.
```
