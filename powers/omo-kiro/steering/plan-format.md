# OMO Plan Format

Plans live in `.kiro/omo/plans/` and use markdown checkboxes.

Every implementation plan should include:

- Goal and non-goals.
- Current findings with file paths and relevant line references when available.
- Assumptions and open questions.
- Ordered task checklist.
- Per-task acceptance criteria.
- Per-task QA scenarios with a concrete tool, steps, and expected result.
- Final verification commands.
- Rollback or recovery notes for risky work.

Tasks should be executable by a capable developer without needing another planning pass. Keep each task scoped to a coherent change, not an entire feature area.
