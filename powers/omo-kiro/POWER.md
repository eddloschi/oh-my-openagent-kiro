---
name: "omo-kiro"
displayName: "OMO for Kiro"
description: "A Kiro-native port of the Oh My OpenAgent workflow. Provides OMO-style planning, execution, research, review, and specialist agents without requiring Kiro CLI runtime customization."
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
- Kiro Code Intelligence through the `code` tool for coding agents.
- Remote MCP research tools for `context7`, `grep_app`, and `websearch`.

This Power preserves OMO's practical workflow shape: understand the request, plan with evidence, review blockers, execute deliberately, verify, and record reusable learnings.

## Onboarding

### Prerequisites

- Kiro CLI with local Power support.
- A Kiro account with at least one coding-capable model configured.
- Optional network/search tools for `librarian`; otherwise it works from locally available docs and repositories.
- Optional LSP setup via `/code init` for enhanced references, definitions, hover docs, diagnostics, and rename support. Built-in Tree-sitter code intelligence works without LSP.

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
3. This package currently maps agents to the highest available Claude tiers: Opus 4.8, Sonnet 4.6, and Haiku 4.5.
4. If a mapped model is unavailable in another account, replace it with the nearest available tier or `auto`.
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

Use `/omo-ultrawork <goal>` for end-to-end implementation when a full plan would slow down a bounded task.

Use `sisyphus` for Claude-like orchestration and `hephaestus` for GPT-family deep execution.

### Research

Use `/omo-research <question>`.

Expected flow:

1. Swap to `explore` for local codebase discovery.
2. Swap to `librarian` for external library and documentation evidence.
3. Use `oracle` for high-stakes technical advice.
4. Synthesize findings with paths, links, and next steps.

## Known Limitations

This v1 package does not implement OpenCode-only runtime features:

- No Team Mode.
- No tmux UI.
- No OpenCode background task manager.
- No runtime model fallback engine.
- No OpenCode plugin APIs.
- No OpenCode custom delegated task tool semantics.

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

- Keep plans under `.kiro/omo/plans/`.
- Keep drafts and research notes under `.kiro/omo/drafts/`.
- Ask `momus` to review plans before execution when work spans multiple files or requires QA.
- Use `explore` before changing unfamiliar areas.
- Use `librarian` for external library behavior and current docs.
- Use `context7`, `grep_app`, and `websearch` through Kiro MCPs for official docs, public examples, and current web evidence.
- Record reusable findings in `.kiro/omo/learnings/` when they affect future work.
