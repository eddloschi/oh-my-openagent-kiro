# Oh My OpenAgent for Kiro

Oh My OpenAgent for Kiro ports the OMO workflow to Kiro-native primitives:

- 11 custom agents for planning, execution, review, research, and specialist consultation.
- Kiro `subagent` support for agent-to-agent handoffs.
- Claude model tiers assigned by role.
- Kiro Code Intelligence through the `code` tool.
- MCP research tools: `context7`, `grep_app`, and `websearch`.
- Skills for the main workflows: plan, start work, review plan, research, and ultrawork.

This repository intentionally contains only the Kiro port. It does not include OpenCode plugins, tmux tooling, Team Mode, or Oh My OpenAgent runtime internals.

## Contents

```text
powers/omo-kiro/      Power package for Kiro IDE/local Power flows
.kiro/agents/         CLI-ready custom agents
.kiro/prompts/        Large agent prompts referenced by the agents
.kiro/skills/         Slash-invokable OMO workflows
.kiro/steering/       Shared workflow and safety rules
.kiro/settings/       Workspace MCP configuration
```

## Installation

For agent-executable installation steps, see [INSTALL.md](INSTALL.md).

Quick local CLI install into another workspace:

```bash
export TARGET_WORKSPACE="/path/to/project"
mkdir -p "$TARGET_WORKSPACE/.kiro" "$TARGET_WORKSPACE/powers"
cp -R .kiro/agents .kiro/prompts .kiro/skills .kiro/steering .kiro/settings "$TARGET_WORKSPACE/.kiro/"
cp -R powers/omo-kiro "$TARGET_WORKSPACE/powers/"
```

Quick global CLI install:

```bash
mkdir -p "$HOME/.kiro"
cp -R .kiro/agents .kiro/prompts .kiro/skills .kiro/steering .kiro/settings "$HOME/.kiro/"
mkdir -p "$HOME/.kiro/powers"
cp -R powers/omo-kiro "$HOME/.kiro/powers/"
```

Validate after either install:

```bash
kiro-cli agent list
kiro-cli mcp list
```

## Agents

Primary agents:

- `sisyphus`: high-autonomy orchestration and completion.
- `hephaestus`: deep execution and implementation.
- `prometheus`: planning-only agent that writes markdown plans.
- `atlas`: executes saved plans step by step.

Specialists:

- `oracle`: senior technical advisor.
- `librarian`: external docs, source, issues, and examples.
- `explore`: local codebase discovery.
- `multimodal-looker`: image and visual inspection.
- `metis`: pre-plan critique and ambiguity analysis.
- `momus`: plan review and blocker detection.
- `sisyphus-junior`: bounded execution helper.

## Models

The agents are configured for the highest available Claude tiers reported in this Kiro account:

- Opus: `claude-opus-4.8`
- Sonnet: `claude-sonnet-4.6`
- Haiku: `claude-haiku-4.5`

Check your account before use:

```bash
kiro-cli chat --list-models
```

If a model is unavailable, replace the `model` field in the affected agent JSON with another listed model or with `auto`.

## MCPs

The port includes three remote MCP servers:

- `context7`: official library/framework docs.
- `grep_app`: public GitHub code search.
- `websearch`: Exa-backed web search.

They are embedded in each agent JSON so `kiro-cli chat --agent <name>` can load them directly. The same servers are also listed in `.kiro/settings/mcp.json` for workspace visibility.

No API keys are committed. If your environment requires authentication, add headers locally using environment variables such as `${EXA_API_KEY}` or `${CONTEXT7_API_KEY}`.

## Use In Kiro CLI

Clone or copy this repository, then run Kiro CLI from the repository root:

```bash
kiro-cli agent list
kiro-cli mcp list
```

Validate the agents:

```bash
for f in .kiro/agents/*.json; do kiro-cli agent validate --path "$f" || exit 1; done
```

Start a session with an agent:

```bash
kiro-cli chat --agent prometheus
kiro-cli chat --agent sisyphus
kiro-cli chat --agent librarian
```

For non-interactive checks:

```bash
kiro-cli chat --agent librarian --no-interactive --trust-tools=read,fs_read,@context7,@grep_app,@websearch \
  "Use context7 to summarize React useEffect in two sentences."
```

## Use In Kiro IDE

Use the Power package at:

```text
powers/omo-kiro/
```

Install it through Kiro IDE's local Power flow. If your Kiro IDE build does not load local Powers directly, copy the Power contents into the workspace-level Kiro directories:

```text
powers/omo-kiro/agents/   -> .kiro/agents/
powers/omo-kiro/prompts/  -> .kiro/prompts/
powers/omo-kiro/skills/   -> .kiro/skills/
powers/omo-kiro/steering/ -> .kiro/steering/
powers/omo-kiro/settings/ -> .kiro/settings/
```

Then reload the workspace and check that the agents appear in the agent picker.

## Workflows

Plan:

```text
/omo-plan <task>
```

Review a plan:

```text
/omo-review-plan .kiro/omo/plans/<plan>.md
```

Execute a saved plan:

```text
/omo-start-work .kiro/omo/plans/<plan>.md
```

Research:

```text
/omo-research <question>
```

Autonomous implementation:

```text
/omo-ultrawork <goal>
```

## Notes

- Use `/code init` in Kiro when you want LSP-backed Code Intelligence.
- Use `subagent` for specialist consultation. The older experimental delegate feature is deprecated by Kiro.
- Do not send secrets or large private code snippets to remote MCPs.
- Plans and working memory should live under `.kiro/omo/`, which is ignored by this repository.
