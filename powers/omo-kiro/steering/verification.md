# Verification Discipline

Verification must be concrete and reproducible.

- Prefer project-native tests, type checks, linters, build commands, and smoke checks.
- Include exact commands and expected outcomes.
- For UI work, include selectors, viewport assumptions, and screenshot or browser checks when available.
- For API work, include concrete request examples and expected status/body shape.
- For refactors, verify behavior before and after meaningful change groups.
- If a command cannot run in the current environment, record why and identify the closest available check.

Avoid vague criteria such as "verify it works" or "check manually".
