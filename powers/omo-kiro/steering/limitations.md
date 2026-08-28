# Kiro Port Limitations

This package is a Kiro-native workflow port of Oh My OpenAgent (tracking upstream v4.19.4), not an
OpenCode runtime clone. Some upstream behaviors have no Kiro equivalent and are handled differently.

## Not available, and what replaces it

| Upstream behavior | In this port |
|---|---|
| Background task manager / parallel subagent fan-out | Kiro subagents are sequential and blocking. Lanes run one at a time; workflows say so where the cost matters. |
| `create_goal` / `update_goal` and idle continuation | File-based goal at `.kiro/omo/goal.md` via `/omo-goal`, surfaced each turn by an agent `userPromptSubmit` hook. There is **no** idle auto-continuation in Kiro — you re-invoke. |
| Ralph Loop / `ulw-loop` | Removed upstream too. Use `/omo-goal` plus the plan checklist. |
| Team Mode, tmux control | Not ported. Sequential subagents instead. |
| `todowrite` / `todoread` | Plan checkboxes in `.kiro/omo/plans/`, or a numbered checklist in the response. |
| OpenCode plugin hooks / Stop-hook continuation | Kiro agent hooks (`agentSpawn`, `userPromptSubmit`) surface goal and boulder state, but cannot resume an idle session. |
| CodeGraph MCP | Kiro Code Intelligence (`code` tool), then `rg`, then `sg` via `/omo-ast-grep`. |
| `ast_grep` MCP server | Removed upstream as well; `sg` CLI via the `/omo-ast-grep` skill. |
| Runtime model fallback engine | Static `model` per agent; Kiro falls back to `chat.defaultModel` when an id is unavailable. |
| Review-round CAS state machine | Simplified flat draft state (`intent`, `review_required`, `status`, `plan_path`, `plan_sha256`, per-reviewer status/result). |
| Browser control tool | None in Kiro. `/omo-visual-qa` probes for a locally installed `agent-browser` or Playwright CLI and degrades explicitly when neither exists. |

## Intentional divergences from upstream v4.19.4

- **Hephaestus is the one non-Claude agent.** It runs on `gpt-5.6-sol`, matching upstream, which
  registers Hephaestus only for GPT-5.x models. Its behavioral rules (stop-condition declaration,
  waiting discipline, manual QA gate) are ported; upstream's GPT-specific subagent-ID contract and
  apply-patch permission guard are runtime mechanics with no Kiro equivalent and are not. Switch it
  to `claude-opus-5` in `agents/hephaestus.json` and `model-map.json` to stay on one provider.
- **Planning is not mandatory for multi-step work.** Upstream requires the plan agent for any 2+ step
  task. Here, `/omo-plan` is recommended when open design decisions remain — a known procedure with
  many steps does not need a plan. Sequential subagents make blanket planning disproportionate.
- **`omo-frontend` ships without the brand design-system references.** Upstream materializes them
  from the `nexu-io/open-design` submodule at build time; see the skill for how to add them locally.

## Consultation mechanics

Use the official Kiro `subagent` tool first. Kiro's experimental `delegate` tool is deprecated; do
not use it for new workflows. When `subagent` is unavailable, use `/agent swap <name>` or a separate
read-only CLI session:

```bash
kiro-cli chat --agent momus --no-interactive --trust-tools=fs_read,read "Review .kiro/omo/plans/example.md and return [OKAY], [REJECT], or [INCONCLUSIVE]."
```

This fallback is a separate process with its own tool permissions — not OpenCode-style background
delegation. Say so when you report its result.
