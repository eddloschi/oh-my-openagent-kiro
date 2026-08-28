---
name: "omo-kiro"
displayName: "OMO for Kiro"
description: "A Kiro-native port of the Oh My OpenAgent workflow (tracking upstream v4.19.4). Provides OMO-style planning, execution, research, review, and 20 workflow and specialist skills without requiring Kiro CLI runtime customization."
keywords: [kiro, agents, planning, execution, research, omo]
author: "local"
---

# OMO for Kiro

## Overview

OMO for Kiro packages the Oh My OpenAgent workflow as Kiro-native primitives:

- Custom agents in `agents/` for planning, execution, review, research, and advice.
- Large role prompts in `prompts/`, referenced from agent JSON with `file://`.
- Shared workflow rules in `steering/`.
- User-facing workflow skills in `skills/`.
- A deterministic `model-map.json` for choosing account-available Kiro models.
- Kiro Code Intelligence through the `code` tool for coding agents, plus `sg` (ast-grep) for
  structural search.
- Remote MCP research tools for `context7`, `grep_app`, and `websearch`.
- A binding GOAL / STOP WHEN / EVIDENCE contract on every subagent handoff.

This Power preserves OMO's practical workflow shape: understand the request, plan with evidence, review blockers, execute deliberately, verify, and record reusable learnings.

## Onboarding

### Prerequisites

- Kiro CLI with local Power support.
- A Kiro account with at least one coding-capable model configured.
- Optional network/search tools for `librarian`; otherwise it works from locally available docs and repositories.
- Optional LSP setup via `/code init` for enhanced references, definitions, hover docs, diagnostics, and rename support. Built-in Tree-sitter code intelligence works without LSP.
- Optional external tooling for specialist skills: `node` (plan scaffolding, visual QA), `python3`
  (ast-grep helper, session finder, browsing engine), `sg`, `uv`, `gh`, and a browser CLI
  (`agent-browser` or Playwright) for web visual QA. Each skill degrades with an explicit message
  when its tool is absent.

### Installation

Install this directory through Kiro's local Power path flow. If your Kiro build expects files under `.kiro/`, copy or link the package contents into the equivalent workspace paths:

```text
agents/   -> .kiro/agents/
skills/   -> .kiro/skills/
steering/ -> .kiro/steering/
settings/ -> .kiro/settings/
```

Leave `prompts/` beside `agents/`, or update each agent `prompt` path after copying.

### First Run

1. Review `model-map.json`.
2. Run `kiro-cli chat --list-models --format json-pretty`.
3. This package maps agents by role: Opus 5 (sisyphus, prometheus, oracle), Sonnet 5 (atlas, metis,
   momus, multimodal-looker, sisyphus-junior), Haiku 4.5 (explore, librarian), and GPT-5.6 Sol
   (hephaestus — upstream registers that agent only for GPT-5.x models).
4. Kiro falls back to `chat.defaultModel` when a model id is unavailable — silently. Confirm the ids
   are in your account; if not, replace them in both the agent JSON and `model-map.json`.
5. Add or replace `"model": "<kiro-model-id>"` only after confirming that model appears in your account.
6. Validate agents:

```text
kiro-cli agent validate --path powers/omo-kiro/agents/sisyphus.json
kiro-cli agent validate --path powers/omo-kiro/agents/prometheus.json
kiro-cli agent validate --path powers/omo-kiro/agents/atlas.json
```

Repeat for the other files in `agents/`.

### MCP Setup

This package includes workspace MCP configuration for three remote research servers:

- `context7`: official library and framework documentation.
- `grep_app`: public GitHub code search.
- `websearch`: Exa-backed web search.

Each OMO agent embeds these MCP servers in its agent JSON so `kiro-cli chat --agent <name>` can load them directly. The active workspace also has `.kiro/settings/mcp.json` for visibility and non-agent sessions. The package copy lives at `powers/omo-kiro/settings/mcp.json`.

Validate MCP loading with:

```text
kiro-cli mcp list
kiro-cli mcp status context7
kiro-cli mcp status grep_app
kiro-cli mcp status websearch
```

Do not commit API keys. If a remote MCP needs authentication in your account, add headers locally with environment-variable references such as `${EXA_API_KEY}` or `${CONTEXT7_API_KEY}`.

## Common Workflows

### Plan a Task

Use `/omo-plan <task>`.

Expected flow:

1. Swap to `prometheus`.
2. Inspect the codebase and relevant docs.
3. Write a markdown plan under `.kiro/omo/plans/`.
4. Include concrete acceptance criteria and verification commands.

### Review a Plan

Use `/omo-review-plan .kiro/omo/plans/<plan>.md`.

Expected flow:

1. Swap to `momus`.
2. Re-read the plan from disk.
3. Verify referenced files and executable QA.
4. Return `[OKAY]` or `[REJECT]` with at most three blocking issues.

### Execute a Plan

Use `/omo-start-work .kiro/omo/plans/<plan>.md`.

Expected flow:

1. Swap to `atlas`.
2. Execute checklist tasks in order.
3. Mark checkboxes as work is completed.
4. Run the plan's verification commands.

### Autonomous Deep Work

Use `/omo-ultrawork <goal>` for end-to-end implementation when a full plan would slow down a bounded
task. It declares a binding stop condition, defines scenario QA, implements test-first, and commits
per verified increment.

Use `sisyphus` for orchestration-heavy work and `hephaestus` for deep single-thread execution.

### Review Completed Work

Use `/omo-review-work` before a PR handoff. Five lanes run sequentially — goal and constraint
verification, code quality, security, context mining, and hands-on QA — and all must pass.

### Session Continuity

Use `/omo-goal <objective>` to record a persistent objective and its stop condition in
`.kiro/omo/goal.md`; agent hooks surface it at the start of each turn. Use `/omo-handoff` to produce
a context block for continuing in a fresh session.

### Specialist Skills

`/omo-ast-grep`, `/omo-coding-agent-sessions`, `/omo-data-scientist`, `/omo-debugging`,
`/omo-frontend`, `/omo-git-master`, `/omo-init-deep`, `/omo-lsp-setup`, `/omo-programming`,
`/omo-refactor`, `/omo-remove-ai-slops`, `/omo-ultimate-browsing`, `/omo-visual-qa`.

### Research

Use `/omo-research <question>`.

Expected flow:

1. Swap to `explore` for local codebase discovery.
2. Swap to `librarian` for external library and documentation evidence.
3. Use `oracle` for high-stakes technical advice.
4. Synthesize findings with paths, links, and next steps.

## Known Limitations

This package does not implement OpenCode-only runtime features. See
`steering/limitations.md` for the full table and the intentional divergences from upstream.

- No background task manager: **Kiro subagents are sequential and blocking**. Workflows inherited
  from upstream's parallel design (review-work, debugging's Oracle Triple, visual QA's dual pass)
  run lane by lane and take correspondingly longer.
- No goal tool or idle continuation: `/omo-goal` writes `.kiro/omo/goal.md` and agent hooks surface
  it each turn, but nothing resumes an idle session.
- No Team Mode, no tmux UI, no runtime model fallback engine, no OpenCode plugin APIs, no
  OpenCode custom delegated task tool semantics.
- No browser-control tool: `/omo-visual-qa` probes for a local `agent-browser` or Playwright CLI.
- `hephaestus` runs on `gpt-5.6-sol`, matching upstream; it is the one non-Claude agent.
- `/omo-frontend` ships without the upstream brand design-system references (a git submodule
  upstream); the skill documents how to add them.

Use Kiro's official `subagent` tool as the primary specialist mechanism. The old experimental `delegate` tool is deprecated by Kiro and should not be used for new OMO-Kiro workflows.

If `subagent` is unavailable, use explicit `/agent swap <name>` handoffs or run specialists as separate non-interactive Kiro CLI sessions. For fallback CLI workflows, agents may consult each other through commands like:

```text
kiro-cli chat --agent momus --no-interactive --trust-tools=fs_read,read "Review .kiro/omo/plans/example.md and return [OKAY] or [REJECT]."
```

This fallback is not OpenCode-style background delegation. It is a separate Kiro CLI invocation with its own tool permissions and output.

## Troubleshooting

- If an agent cannot load its prompt, check the relative `file://../prompts/<agent>.md` path from the agent JSON file.
- If a skill does not activate, invoke it directly by slash command and tune its `description`.
- If validation rejects a `model`, remove the field and let Kiro use `chat.defaultModel`.
- If read-only agents request write permissions, verify their `tools` list excludes `write`.

## Best Practices

- Keep plans under `.kiro/omo/plans/` and drafts under `.kiro/omo/drafts/` — both are created by
  `skills/omo-plan/scripts/scaffold-plan.mjs`, never by hand.
- Give every subagent handoff a GOAL, a STOP WHEN condition, and an EVIDENCE requirement.
- Treat subagent output as a claim until you verify it against the evidence you asked for.
- Ask `momus` to review plans before execution when work spans multiple files or requires QA.
- Use `explore` before changing unfamiliar areas.
- Use `librarian` for external library behavior and current docs.
- Use `context7`, `grep_app`, and `websearch` through Kiro MCPs for official docs, public examples, and current web evidence.
- Record reusable findings in `.kiro/omo/learnings/` when they affect future work.
