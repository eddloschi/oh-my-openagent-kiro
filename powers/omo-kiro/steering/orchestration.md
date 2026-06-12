# OMO Orchestration Discipline

Use official Kiro subagents for specialist consultations rather than hidden OpenCode-style delegation.

- For planning, swap to `prometheus`.
- For execution from a plan, swap to `atlas`.
- For autonomous bounded implementation, swap to `sisyphus` or `hephaestus`.
- For pre-planning critique, swap to `metis`.
- For plan review, swap to `momus`.
- For local codebase search, swap to `explore`.
- For external library or source research, swap to `librarian`.
- For high-stakes architecture/debugging advice, swap to `oracle`.
- For image, PDF, or diagram interpretation, swap to `multimodal-looker`.

Handoffs should include:

```markdown
## Handoff
**Goal**:
**Current state**:
**Files or paths**:
**Constraints**:
**Evidence already gathered**:
**Expected output**:
```

Do not assume OpenCode-style background agents are running. Each specialist response must be obtained explicitly through the `subagent` tool, `/agent swap`, or the Kiro CLI-session fallback.

When `subagent` is unavailable and the workflow calls for a specialist check, use a separate non-interactive Kiro session:

```bash
kiro-cli chat --agent <name> --no-interactive --trust-tools=fs_read,read "<handoff prompt>"
```

Use read-only trusted tools for reviewers and consultants whenever possible. Treat specialist output as evidence, then continue in the current session.
