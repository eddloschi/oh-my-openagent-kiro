# Kiro Port Limitations

This package is a Kiro-native workflow port, not an OpenCode runtime clone.

Unavailable v1 behaviors:

- OpenCode background task manager.
- Team Mode coordination.
- tmux control.
- OpenCode plugin hooks.
- Runtime model fallback.
- OpenCode custom task delegation tools.

Use official Kiro subagents first. Use Kiro agent swaps, explicit handoff text, or Kiro CLI non-interactive agent runs only when subagents are unavailable or unsuitable. When a prompt mentions consultation, the agent may:

- Spawn the named custom agent with the `subagent` tool.
- Swap manually with `/agent swap <name>`.
- Run a read-only specialist from shell, for example:

```bash
kiro-cli chat --agent momus --no-interactive --trust-tools=fs_read,read "Review .kiro/omo/plans/example.md and return [OKAY] or [REJECT]."
```

Do not use Kiro's deprecated experimental `delegate` tool for new workflows. Do not describe Kiro subagents as OpenCode-style background delegation. Avoid nested CLI execution unless `subagent` is unavailable and the workflow calls for a specialist check or the user asks for it.
