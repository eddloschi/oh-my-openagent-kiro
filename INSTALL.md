# Install Oh My OpenAgent for Kiro

This guide is written for an agent installing this repository into a Kiro workspace or into the user's global Kiro configuration.

Do not install generated working memory. The `.kiro/omo/` directory is runtime state and should stay out of the repository and out of installation copies.

## What To Install

Install these directories:

```text
.kiro/agents/
.kiro/prompts/
.kiro/skills/omo-*/
.kiro/steering/
.kiro/settings/mcp.json
powers/omo-kiro/
```

Do not install unrelated conversion tools, upstream source checkouts, temporary plans, logs, or `.git/`.

## Before Installing

From this repository root, validate the source:

```bash
for f in .kiro/agents/*.json; do kiro-cli agent validate --path "$f" || exit 1; done
kiro-cli mcp list
```

Check model availability:

```bash
kiro-cli chat --list-models
```

If a configured model is unavailable, edit the affected agent JSON before installing and use a listed model or `auto`.

## Local Workspace Install

Use this when OMO-Kiro should be available only inside one project.

Set the target workspace:

```bash
export TARGET_WORKSPACE="/path/to/project"
```

Create Kiro directories:

```bash
mkdir -p "$TARGET_WORKSPACE/.kiro/agents"
mkdir -p "$TARGET_WORKSPACE/.kiro/prompts"
mkdir -p "$TARGET_WORKSPACE/.kiro/skills"
mkdir -p "$TARGET_WORKSPACE/.kiro/steering"
mkdir -p "$TARGET_WORKSPACE/.kiro/settings"
mkdir -p "$TARGET_WORKSPACE/powers"
```

Copy OMO-Kiro files:

```bash
cp .kiro/agents/*.json "$TARGET_WORKSPACE/.kiro/agents/"
cp .kiro/prompts/*.md "$TARGET_WORKSPACE/.kiro/prompts/"
cp -R .kiro/skills/omo-* "$TARGET_WORKSPACE/.kiro/skills/"
cp .kiro/steering/*.md "$TARGET_WORKSPACE/.kiro/steering/"
cp .kiro/settings/mcp.json "$TARGET_WORKSPACE/.kiro/settings/mcp.json"
cp -R powers/omo-kiro "$TARGET_WORKSPACE/powers/"
```

Validate from the target workspace:

```bash
cd "$TARGET_WORKSPACE"
kiro-cli agent list
kiro-cli mcp list
for f in .kiro/agents/*.json; do kiro-cli agent validate --path "$f" || exit 1; done
```

Smoke test:

```bash
kiro-cli chat --agent librarian --no-interactive --trust-tools=read,fs_read,@context7,@grep_app,@websearch \
  "Use context7 to summarize React useEffect in two sentences."
```

## Global CLI Install

Use this when OMO-Kiro should be available from any workspace on the machine.

Create global Kiro directories:

```bash
mkdir -p "$HOME/.kiro/agents"
mkdir -p "$HOME/.kiro/prompts"
mkdir -p "$HOME/.kiro/skills"
mkdir -p "$HOME/.kiro/steering"
mkdir -p "$HOME/.kiro/settings"
mkdir -p "$HOME/.kiro/powers"
```

Copy OMO-Kiro files:

```bash
cp .kiro/agents/*.json "$HOME/.kiro/agents/"
cp .kiro/prompts/*.md "$HOME/.kiro/prompts/"
cp -R .kiro/skills/omo-* "$HOME/.kiro/skills/"
cp .kiro/steering/*.md "$HOME/.kiro/steering/"
cp .kiro/settings/mcp.json "$HOME/.kiro/settings/mcp.json"
cp -R powers/omo-kiro "$HOME/.kiro/powers/"
```

Validate from any directory:

```bash
kiro-cli agent list
kiro-cli mcp list
for f in "$HOME/.kiro/agents"/*.json; do kiro-cli agent validate --path "$f" || exit 1; done
```

Start a global agent:

```bash
kiro-cli chat --agent sisyphus
```

## Kiro IDE Install

For IDE Power usage, install or point the IDE at:

```text
powers/omo-kiro/
```

If the IDE build does not load local Powers directly, use the local workspace install above and reload the workspace. The agents should appear in the agent picker.

## MCP Credentials

The default MCP setup does not commit credentials.

Configured servers:

- `context7`: `https://mcp.context7.com/mcp`
- `grep_app`: `https://mcp.grep.app`
- `websearch`: `https://mcp.exa.ai/mcp?tools=web_search_exa`

If authentication is required, edit the local or global MCP config with environment-variable based headers. Do not hardcode tokens in this repository.

Example:

```json
{
  "mcpServers": {
    "websearch": {
      "url": "https://mcp.exa.ai/mcp?tools=web_search_exa",
      "headers": {
        "Authorization": "Bearer ${EXA_API_KEY}"
      },
      "disabled": false
    }
  }
}
```

## Updating An Existing Install

Before replacing files, inspect user changes:

```bash
git status --short
```

For a local workspace, compare:

```bash
diff -ru .kiro/agents "$TARGET_WORKSPACE/.kiro/agents" || true
diff -ru .kiro/prompts "$TARGET_WORKSPACE/.kiro/prompts" || true
```

Then repeat the local or global copy steps. Do not delete user-created agents, skills, steering files, or settings unless explicitly requested.
