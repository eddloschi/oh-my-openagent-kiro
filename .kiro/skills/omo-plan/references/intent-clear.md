# omo-plan — CLEAR intent

Read this when intent routing resolved to CLEAR: the user knows the desired outcome, and the only
open items are preferences or tradeoffs the repo cannot answer. Also entered from the on-the-fence
tie-break (ask exactly one question).

## Stance

The user owns the outcome; genuine forks exist that only they can decide. Research first to ground,
THEN ask the surviving forks. You are a peer asking only what you genuinely cannot resolve — not an
interrogator gathering a feature list. Offer the high-accuracy review only when `review_required` is
false; if the user already asked for high accuracy, run it after approval instead of offering it.

## Research protocol

Explore before asking. Dispatch read-only research — internal patterns, conventions, test infra, plus
external docs and contracts — **one subagent at a time**, and use the `code` tool, `rg`, and direct
reads yourself between spawns.

Triage in front of the two filters: if the repo, system, or docs can answer it, explore and present
a cited confirmation, never a question. If only the user can answer it, it may proceed to the
interview. If you cannot tell who answers it, treat it as a user-decision.

Stop at sufficiency, one wave per open question. Never re-explore to double-check.

## Interview

**Topology lock first.** From the request plus exploration, enumerate the 1-6 top-level components
that can each succeed or fail independently, confirm them in ONE turn, and record them in the
draft's Components ledger (id, one-line outcome, status, evidence path). Do NOT collapse to one
component because the request looks small.

**Then the two filters** (full definition in `../SKILL.md`): (1) evidence-answerable → explore;
(2) intent plus a defensible default → adopt and record — EXCEPT owner-decisions (irreversible,
destructive, or safety-critical, or a cross-cutting product choice), which always survive as
questions.

**Ask with WHY.** Name what you explored, why it did not resolve, and which part of the plan forks
on the answer. 1-3 narrow questions per turn, each with 2-4 options and your recommended default
FIRST; a skipped question resolves to that default. Always confirm test strategy (TDD /
tests-after / none — agent-executed QA is always included).

**Foggiest-gap targeting.** Each turn, aim at the single open gap whose resolution most unblocks the
plan, and say why in one sentence; rotate across equally-foggy components. End every turn with the
question or the explicit next step — never passive.

**Clearance check after each turn**: objective defined? scope IN/OUT explicit? approach decided?
test strategy confirmed? no blocking ambiguity left? Any NO is your next question; all YES → present
the approval brief and stop.

## Approval and delivery

Run the durable approval gate (mechanics in `full-workflow.md`): present the brief once with
findings (paths), the approach, and EVERY surviving owner-decision as an explicit question with your
recommended option; then wait for the explicit okay.

If "start now, or review first?" would be your ONLY question, you have defaulted forks you should
have surfaced — list them first.

After approval: rerun the scaffold, run mandatory Metis, APPEND the todos, fill the human TL;DR
last. Then either run the dual high-accuracy review if `review_required` is true, or present the
handoff explanation and ask ONE question — start work now, or run the dual high-accuracy review
first? Never pick for the user when review was not requested. Never begin execution.

## Worked example

Request: "add a 5/min-per-IP rate-limit to `/login`".

1. Explore → auth middleware at `src/auth/login.ts:40`, an existing limiter util at
   `src/util/rate-limit.ts`, Redis client at `src/redis.ts`.
2. Topology lock (one turn): one active component — "login rate-limit".
3. Two surviving forks, each asked WITH WHY:
   - Storage backend (explored: repo already uses Redis; default = Redis; options Redis /
     in-memory / per-node) — why: persistence across nodes forks the design.
   - Over-limit response (default = 429 + Retry-After; options 429 / 423 / silent drop) — why: the
     client contract forks on it.
4. Approval brief → explicit okay → scaffold → append todos → deliver with the optional review
   question.
