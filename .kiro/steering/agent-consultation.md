# Agent Consultation Protocol

OMO agents may consult other OMO agents from Kiro CLI.

Use the official Kiro `subagent` tool as the primary mechanism. Kiro's experimental `delegate` tool is deprecated and should not be used for new workflows.

Kiro CLI does not expose OpenCode-style `task()` or `call_omo_agent()` tools. In Kiro, describe the focused task and ask the current agent to spawn the named custom agent as a subagent. Custom orchestrator agents must include `subagent` in their `tools` array.

Fallback only: if `subagent` is unavailable in the current CLI session, use a separate Kiro CLI session:

```bash
kiro-cli chat --agent <agent-name> --no-interactive --trust-tools=fs_read,read "<consultation prompt>"
```

Use read-only trusted tools for reviewers, planners, and consultants by default. Add write or shell trust only when the consultation explicitly requires it and the user has accepted that risk. Do not use `--trust-all-tools` for routine consultations.

## When To Consult

- `metis`: before planning ambiguous, broad, architectural, or high-risk work.
- `momus`: after writing a plan and before execution.
- `explore`: when local repository structure or patterns are unclear.
- `librarian`: when external library documentation, package behavior, or source evidence matters.
- `oracle`: for high-stakes architecture, security, performance, or repeated debugging failures.
- `multimodal-looker`: for attached screenshots, diagrams, PDFs, and images.
- `prometheus`: when a task needs a saved implementation plan.
- `atlas`: when a saved plan should be executed.
- `sisyphus` or `hephaestus`: when a bounded task needs autonomous implementation.
- `sisyphus-junior`: when a small, clear task can be delegated safely.

Skill-level workflows wrap the common routes: `/omo-plan`, `/omo-review-plan`, `/omo-start-work`,
`/omo-review-work`, `/omo-research`, `/omo-ultrawork`, `/omo-debugging`.

## Consultation Prompt Shape

Use the handoff contract from `steering/orchestration.md`. The three binding fields are
`GOAL`, `STOP WHEN`, and `EVIDENCE` — a consultation without them will over-run or stop early,
because the child has none of this session's context.

```markdown
## Consultation
**Requesting agent**:
**GOAL**: the single outcome that makes this consultation done.
**STOP WHEN**: the exact observable condition that ends it.
**EVIDENCE**: what you must return to prove it.
**Current state**:
**Relevant files or plan path**:
**Constraints**:
**Expected output**:
```

Kiro subagents run one at a time and block until they return. Order your consultations; do not
describe them as parallel. Treat every result as a claim until you verify it against `EVIDENCE`.

After a subagent completes, summarize the specialist result in the current session and identify which agent produced it. If using the CLI-session fallback, say that the result came from a separate Kiro CLI agent run. If the fallback command fails because tools are not trusted in non-interactive mode, either rerun with a narrower explicit trust set or fall back to `/agent swap <name>` handoff.
