---
name: omo-research
description: "Evidence-first research across the local codebase, official docs, public source, and the web. Use when the user asks to investigate, research, compare options, find out how something works, check a library's behavior, or understand an unfamiliar pattern. Runs explore/librarian/oracle passes, keeps a claim ledger with sources and confidence, verifies contested claims by running code, and reports gaps honestly. The deep multi-wave mode activates only on an explicit request for deep research."
---

# OMO Research

Research `$ARGUMENTS`.

## 1. Decompose

Break the question into at least three axes (e.g. how it works here / how it works upstream / what
the tradeoffs are). Name them up front — the axes are what you report against.

For a small question, one pass per axis is enough. Escalate to the deep loop below only when the
user explicitly asked for deep or exhaustive research.

## 2. Gather — sequentially

Kiro subagents run one at a time and block. Order the passes by information value and stop as soon
as the question is settled; do not complete a roster for its own sake.

- `explore` — local repository discovery: where it lives, what pattern the project uses, what the
  tests assume. Give it GOAL / STOP WHEN / EVIDENCE.
- `librarian` — external docs, library source, issues, PRs, examples, via `@context7`, `@grep_app`,
  and `@websearch`.
- `oracle` — architecture tradeoffs, repeated failures, or a high-risk decision. Consult after the
  facts are in, not before.

Between spawns, use the `code` tool, `rg`, and direct reads yourself. Every subagent result is a
**claim** until you verify it against a path or a citation.

## 3. Expand, then converge

When a pass returns a lead that changes the answer, follow it. Stop expanding when leads run dry,
when two consecutive passes add nothing new, or at depth 5 — whichever comes first. Say which
stopping condition fired.

## 4. Verify contested claims

If a claim is load-bearing and contested, do not settle it by citation count — settle it by
execution. Write the smallest script or command that demonstrates the behavior, run it with `shell`,
and report the real output. A claim you verified this way is MEASURED; everything else is not.

## 5. Claim ledger (required before you answer)

Every non-trivial claim gets a row before it appears in the synthesis:

| Claim | Source (path / permalink) | Type | Confidence |
|---|---|---|---|

- **Type** is MEASURED (you ran it), DERIVED (follows from measured facts, and you show the step), or
  ASSUMED (neither — say so).
- A **high-risk external claim** — one the user would act on, that you cannot measure — needs at
  least two independent sources plus one deliberate counter-search for contradicting evidence.
  Without that, tag it **unverified** in the answer rather than asserting it. Do not launder a single
  blog post into a fact.
- Numbers carry their type. An unsourced number is not a finding.

*(The independent-corroboration gate adapts an idea from fivetaku's insane-research; see
`THIRD-PARTY-NOTICES.md`.)*

## 6. Report

```markdown
## Answer
<direct answer to the question, per axis>

## Evidence
- <path or link>: <the claim it supports> [MEASURED | DERIVED | ASSUMED]

## Confidence and gaps
- <what you could not establish, and what it would take>

## Next steps
```

Do not write files unless the user asks. When they do ask for a durable note, write it to
`.kiro/omo/learnings/<topic>.md`.

## Handoff template

```markdown
## Research handoff
**GOAL**: answer — $ARGUMENTS
**STOP WHEN**: every axis has an answer or a stated gap, and every non-trivial claim has a source
row in the ledger.
**EVIDENCE**: file paths with line numbers for local claims; permalinks with versions for external
claims; real command output for measured claims.
**Scope**: local codebase, external docs/source, or both.
```
