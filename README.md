# Oh My OpenAgent for Kiro

Oh My OpenAgent for Kiro ports the OMO workflow to Kiro-native primitives. It tracks upstream
[oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) **v4.19.4**.

- 11 custom agents for planning, execution, review, research, and specialist consultation.
- Kiro `subagent` support for agent-to-agent handoffs, with a binding GOAL / STOP WHEN / EVIDENCE
  contract on every spawn.
- Claude model tiers assigned by role.
- Kiro Code Intelligence through the `code` tool, plus `sg` (ast-grep) for structural search.
- MCP research tools: `context7`, `grep_app`, and `websearch`.
- 20 skills: the core OMO workflows plus the upstream shared-skill library.

This repository intentionally contains only the Kiro port. It does not include OpenCode plugins,
tmux tooling, Team Mode, or Oh My OpenAgent runtime internals — see
[`.kiro/steering/limitations.md`](.kiro/steering/limitations.md) for what that means in practice.

## Contents

```text
powers/omo-kiro/      Power package for Kiro IDE/local Power flows (mirror of .kiro/)
.kiro/agents/         CLI-ready custom agents
.kiro/prompts/        Agent prompts referenced by the agents
.kiro/skills/         Slash-invokable OMO workflows and specialist skills
.kiro/steering/       Shared workflow and safety rules
.kiro/settings/       Workspace MCP configuration
scripts/              Mirror sync and drift check
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
mkdir -p "$HOME/.kiro/powers"
cp -R .kiro/agents .kiro/prompts .kiro/skills .kiro/steering .kiro/settings "$HOME/.kiro/"
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
- `hephaestus`: deep execution and implementation (GPT-5.6, per upstream).
- `prometheus`: planning-only agent that writes markdown plans.
- `atlas`: executes saved plans step by step, with PR delivery modes.

Specialists:

- `oracle`: senior technical advisor, independent plan reviewer, review-work reviewer.
- `librarian`: external docs, source, issues, and examples.
- `explore`: local codebase discovery.
- `multimodal-looker`: image and visual inspection.
- `metis`: pre-plan critique and ambiguity analysis.
- `momus`: plan review and blocker detection.
- `sisyphus-junior`: bounded execution helper.

## Models

Agents are mapped to Claude tiers by role:

| Tier | Model | Agents |
|---|---|---|
| Opus | `claude-opus-5` | sisyphus, prometheus, oracle |
| Sonnet | `claude-sonnet-5` | atlas, metis, momus, multimodal-looker, sisyphus-junior |
| Haiku | `claude-haiku-4.5` | explore, librarian |
| GPT | `gpt-5.6-sol` | hephaestus |

`hephaestus` is the one non-Claude agent: upstream registers it only for GPT-5.x models and its
prompt is that execution contract. Switch it to `claude-opus-5` in `.kiro/agents/hephaestus.json`
and `powers/omo-kiro/model-map.json` if you would rather stay on a single provider.

Check your account before use:

```bash
kiro-cli chat --list-models
```

Kiro falls back to `chat.defaultModel` when a configured model id is unavailable, so a wrong id
degrades silently — verify the ids, then adjust `powers/omo-kiro/model-map.json` and the agent JSON
together if they differ.

## MCPs

Three remote MCP servers, embedded in each agent JSON and listed in `.kiro/settings/mcp.json`:

- `context7`: official library/framework docs.
- `grep_app`: public GitHub code search.
- `websearch`: Exa-backed web search.

No API keys are committed. If your environment requires authentication, add headers locally using
environment variables such as `${EXA_API_KEY}` or `${CONTEXT7_API_KEY}`.

## Use In Kiro CLI

```bash
kiro-cli agent list
kiro-cli mcp list
for f in .kiro/agents/*.json; do kiro-cli agent validate --path "$f" || exit 1; done
kiro-cli chat --agent prometheus
```

## Use In Kiro IDE

Install the Power package at `powers/omo-kiro/` through Kiro IDE's local Power flow. If your build
does not load local Powers directly, copy its `agents/`, `prompts/`, `skills/`, `steering/`, and
`settings/` into the matching `.kiro/` directories and reload the workspace.

## Workflows

Core:

```text
/omo-plan <task>                          Plan first: explore, route intent, approve, then write one plan
/omo-review-plan <plan.md>                Dual review (momus + independent oracle)
/omo-start-work <plan.md> [--worktree <p>] [--make-pr] [--ship]
/omo-ultrawork <goal>                     Autonomous end-to-end implementation
/omo-research <question>                  Evidence-first research with a claim ledger
/omo-review-work                          Five-lane review of completed work
/omo-goal <objective>|show|pause|resume|clear
/omo-handoff                              Context block for continuing in a fresh session
```

Specialist skills: `/omo-ast-grep`, `/omo-coding-agent-sessions`, `/omo-data-scientist`,
`/omo-debugging`, `/omo-frontend`, `/omo-git-master`, `/omo-init-deep`, `/omo-lsp-setup`,
`/omo-programming`, `/omo-refactor`, `/omo-remove-ai-slops`, `/omo-ultimate-browsing`,
`/omo-visual-qa`.

## Working state

Runtime state lives under `.kiro/omo/`, which this repository ignores:

```text
.kiro/omo/plans/          Approved work plans
.kiro/omo/drafts/         Planning drafts (the resume point)
.kiro/omo/goal.md         Active objective and its stop condition
.kiro/omo/boulder.json    Active plan and session status
.kiro/omo/notepads/       Per-plan learnings, decisions, issues, problems
.kiro/omo/start-work/     Execution evidence ledger
.kiro/omo/learnings/      Durable research notes
```

## Notes

- Use `/code init` in Kiro when you want LSP-backed Code Intelligence.
- Kiro subagents are **sequential** — there is no background dispatch. Workflows inherited from
  upstream's parallel design run lane by lane and say so.
- Use `subagent` for specialist consultation. Kiro's experimental `delegate` tool is deprecated.
- Do not send secrets or large private code snippets to remote MCPs.
- Some skills need external tooling — see [INSTALL.md](INSTALL.md#toolchain-prerequisites).
- Third-party material is credited in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
