# Phase 2 + 3 — Hypothesis Formation & Parallel Investigation

One hypothesis is a hunch. Three hypotheses is a decision. Investigation is how you turn the decision into runtime evidence.

---

## Phase 2 — Hypothesis Formation (Minimum Three)

### Why three, not one

A single hypothesis creates confirmation bias: you'll read runtime state looking for evidence that confirms it and unconsciously discount contradictions. Three hypotheses force you to design queries that *distinguish* between them, which is the only way runtime evidence becomes decisive.

### Generate across orthogonal axes

If your three hypotheses are all variations of "the handler has a bug", you don't actually have three hypotheses. Span the space:

| Axis | Example framing |
|---|---|
| **User-code logic** | "The handler early-returns because condition X is unexpectedly true" |
| **Library/SDK behavior** | "The third-party client swallows the error and returns a stub" |
| **Environment/config** | "The env var is read at module-load time before it gets populated, so it's empty" |
| **Async/timing** | "The promise rejects (or goroutine panics) after the response is already sent" |
| **Silent side-effect** | "An earlier turn mutated shared state that the current turn inherits" |
| **Observability gap** | "The error is raised but suppressed before logging; it only exists as an unawaited rejection / ignored signal" |
| **Binary-level** (when applicable) | "The function we think is running is actually jumped over by a patched thunk / a different version loaded" |
| **Build-vs-runtime** | "The code we're reading is not the code that's running — stale build, wrong symlink, cached wheel, or dist/ ahead of src/" |

### For each hypothesis, write in the journal

1. **Claim** — one sentence.
2. **Distinguishing evidence** — the exact value or state that confirms or refutes it, AND where to read it (file:line, log source, breakpoint location, memory address).
3. **If true, the fix is** — two words. Forces you to think through fix cost before committing to the hunt.

### Collapse rule

If two hypotheses have identical distinguishing evidence, they aren't actually different — collapse them and find a real alternative. If you can't come up with a third distinct hypothesis, you don't understand the system well enough yet. Go read a little more code before investigating.

---

## Phase 3 — Sequential Investigation

Kiro subagents are sequential and blocking — there is no team mode, no background dispatch, no parallel fan-out. Investigate one hypothesis at a time, in its own subagent pass, folding each result into the journal before starting the next.

**Assignment rule**: one hypothesis → one sequential subagent pass. Pick the subagent whose lane fits the evidence source the hypothesis needs:

- **Runtime state** (attach to the live process, hit breakpoints, read variables/heap/goroutines/stack/registers): spawn `explore` (or drive the debugger yourself via `shell`/`code`) with a prompt that names the hypothesis and the exact state to inspect. Report observed values verbatim — never guess, and if the value isn't visible, say so.
- **Logs / timing** (grep server logs, stderr streams, SDK debug output such as `DEBUG`, `RUST_LOG`, `GODEBUG`, `PYTHONASYNCIODEBUG`, correlate timestamps into a latency timeline): spawn `explore` with a prompt describing what to grep and correlate. Flag anything that looks like a silent catch, a swallowed rejection, a panic recovered-and-ignored, or a success response that hides a failure signal (HTTP 200 with empty body, `stopReason=error`, exit 0 with error-in-stdout).
- **Reproduction** (smallest reliable repro — curl command, vitest/pytest/go test, tmux script, Playwright script for browser bugs, pwntools script for binary targets): spawn `explore` or do it directly. It must reproduce on first try. Document exact input, expected output, observed output. Save repro artifacts under the scratchpad and journal them immediately. If the bug is browser-based you MUST use Playwright CLI — do not simulate with curl.
- **Correlation** (cross-link findings from prior passes into a causal chain from symptom to suspected cause, identify missing evidence, propose the next single most-decisive runtime query): do this yourself after collecting the other passes' results — it needs the accumulated evidence, so it naturally runs last.

Run these passes one after another — each one blocks until it returns, so budget wall-clock time accordingly (this is slower than upstream's parallel team-mode dispatch, but Kiro has no background/parallel subagent execution). After each pass, update the journal and hypothesis statuses before dispatching the next pass.

Example, run in order (not simultaneously):

```
Pass 1: spawn `explore` — "[CONTEXT: bug summary + which hypothesis you're testing + what state to look at]
Runtime state investigation for hypothesis 1: ..."
   (wait for it to finish, journal the result)

Pass 2: spawn `explore` — "Log/timing investigation for hypothesis 2: ..."
   (wait for it to finish, journal the result)

Pass 3: spawn `explore` — "Reproduction minimizer for hypothesis 3: ..."
   (wait for it to finish, journal the result)
```

Synthesize across all passes once they've all reported back.

---

## Evidence capture discipline (both paths)

For every piece of runtime state captured, record in the journal:

```markdown
### <ISO timestamp> — <what you looked at>
- Source: <file:line | log source | curl command | breakpoint address>
- Value: `<verbatim>`
- Interpretation: <one line — why this matters>
- Refutes/Confirms: H<n>
```

**Verbatim values only. No paraphrasing.**

- `messages.length=0` is evidence.
- "messages seemed empty" is not evidence — it's a memory of an observation, and memory of observations is where debug sessions go to die.

If you find yourself about to paraphrase, stop, go back, and copy the raw value.

---

## Round completion

A "round" is complete when every hypothesis has either confirming or refuting evidence — or when you have exhausted the evidence sources available without a decisive result. If the round ends inconclusively, that counts as a failed round for the counter in the journal. See `04-oracle-triple.md` for what to do at 2 consecutive failed rounds.
