# Lane C: Review & Repair

Lane C runs after implementation and before final sign-off. It requires objective `/omo-visual-qa` evidence first, then applies designpowers judgment to the same artifact, then hands the reconciled context to `/omo-review-work`. The order matters: measurements and screenshots anchor the review; designpowers adds the human-centered judgment does not fully encode.

## Phase Owner

| Capability | Materialized designpowers source | owner | Mapping |
|---|---|---|---|
| Review an existing surface without rerunning discovery | `design-review` | `/omo-visual-qa` plus `/omo-review-work` | Use only for critique context; still captures objective artifacts and final review. |
| Critique against brief, plan, personas, design principles, taste, and craft | `designpowers-critique` | `/omo-visual-qa` evidence, then `/omo-review-work` | Run after screenshots and objective checks exist, so findings cite the built surface. |
| WCAG, COGA, keyboard, screen reader, motion, content, and adaptive needs | agent `accessibility-reviewer` | `/omo-visual-qa` evidence, then `/omo-review-work` | Treat the materialized agent file as reviewer-role guidance. Name who is affected and exact fixes. |
| Nielsen heuristics and cognitive walkthroughs | `heuristic-evaluation` plus agent `heuristic-evaluator` | `/omo-visual-qa` evidence, then `/omo-review-work` | Walk every key task and classify H1-H10 findings with severity. |
| Persona and task walkthroughs | `synthetic-user-testing` | `/omo-visual-qa` evidence, then `/omo-review-work` | Validate that inclusive-personas can complete real tasks under their assistive or situational contexts. |
| Human testing plan when needed | `usability-testing` | `/omo-review-work` context | Produce a test plan or follow-up recommendation when synthetic testing is insufficient. |
| Completion evidence discipline | `verification-before-shipping` | `/omo-review-work` | Summarize plan completion, accessibility results, persona walkthrough, content status, and debt status. |

Materialized agent references for this lane: `design-critic`, `accessibility-reviewer`, and `heuristic-evaluator`.

## Prompt Injection

Use this sequence for UI review and repair:

```text
Run `/omo-visual-qa` first against the actual built surface. Capture objective screenshots, diffs, browser or terminal artifacts, and any required visual QA report.

Then apply Lane C Review & Repair to the same artifact:
- designpowers-critique checks brief, plan, principles, personas, taste, craft, and design-system alignment
- accessibility-reviewer checks WCAG, COGA, keyboard, screen reader, touch, motion, adaptive preferences, and content accessibility
- heuristic-evaluation checks Nielsen H1-H10 and cognitive walkthroughs for key tasks
- synthetic-user-testing walks key tasks as each relevant persona from inclusive-personas
- usability-testing is used for a real-participant test plan when the evidence cannot be resolved synthetically
- verification-before-shipping turns the findings into a single evidence-backed report

Reconcile conflicts by this priority: accessibility over aesthetics, usability over style, brief over opinion, personas to break ties, user escalation for unresolved trade-offs.

Pass the reconciled Lane C report, objective /omo-visual-qa artifacts, open findings, and accepted design debt to `/omo-review-work` for final implementation review.
```

## Evidence Requirements

Lane C requires all of the following before pass:

- `/omo-visual-qa` artifact paths from the actual surface, such as screenshots, image diff JSON, terminal captures, or synthesized visual verdict.
- Design critique findings that cite the plan, brief, state, personas, or taste direction.
- Accessibility findings with severity, affected users, exact fix, and whether each issue is WCAG, COGA, adaptive, content, keyboard, screen reader, touch, or motion related.
- `heuristic-evaluation` results covering relevant Nielsen heuristics and cognitive walkthroughs for key tasks.
- `synthetic-user-testing` results with persona, task, steps, outcome, and barrier matrix.
- A repair decision for every Critical and Major issue: fixed and reverified, escalated to user, or blocking.
- Deferred Minor or Note findings routed to Lane D's design-debt-tracker flow.
- Final context handed to `/omo-review-work`, including objective artifacts and designpowers judgments for the same build.

## Guardrails

- Never run designpowers judgment before objective `/omo-visual-qa` evidence exists for the surface under review.
- A high numeric visual score cannot override an open accessibility, usability, or persona-blocking finding.
- Critical accessibility or critical H1/H3 usability findings block auto progress and require repair or explicit user decision.
- Minor findings may be deferred only when recorded as debt with affected users and suggested fix.
- The final sign-off owner is `/omo-review-work`; Lane C supplies review input, not final approval.
- Static screenshots can support visual critique, but interaction, keyboard, and screen reader findings must be labeled inferred unless they were actually exercised.

## Pass / Fail Behavior

PASS when objective `/omo-visual-qa` evidence exists, designpowers review lanes pass or have explicit accepted debt, and the reconciled context is handed to `/omo-review-work`.

FAIL when review runs without real artifacts, skips heuristic-evaluation, skips synthetic-user-testing for persona-critical flows, treats accessibility as optional, leaves Critical or Major issues unrepaired, or sends final context to `/omo-review-work` without the design findings.
