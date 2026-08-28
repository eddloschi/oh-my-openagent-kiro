# Third-Party Notices

Oh My OpenAgent for Kiro is MIT licensed (see `LICENSE`). Several skills vendor or adapt
third-party material. Each skill keeps its own `LICENSE` / `ATTRIBUTION.md` / `SOURCE`
file in place; this file is an index, not a replacement.

## omo-ast-grep

Vendored from the upstream ast-grep skill.

- Source: <https://github.com/code-yeongyu/ast-grep-skill> @ `3148c69` (ast-grep 0.43.0)
- License: MIT — see `.kiro/skills/omo-ast-grep/LICENSE`
- Pin record: `.kiro/skills/omo-ast-grep/SOURCE`
- The `sg` binary itself is ast-grep (<https://github.com/ast-grep/ast-grep>, MIT) and is
  installed by the user, not bundled here.

## omo-frontend

Adapted from the Oh My OpenAgent `frontend` shared skill.

- License: Apache-2.0 — see `.kiro/skills/omo-frontend/LICENSE-Apache-2.0.txt`
- Credits: `.kiro/skills/omo-frontend/ATTRIBUTION.md`
- Not vendored: the Layer B brand design-system references, which upstream materializes
  from the `nexu-io/open-design` git submodule at build time. See the skill's own note for
  how to add them locally.

## omo-ultimate-browsing

Adapted from the Oh My OpenAgent `ultimate-browsing` shared skill.

- Credits: `.kiro/skills/omo-ultimate-browsing/ATTRIBUTION.md`
- The skill drives third-party CLIs (`curl`, `yt-dlp`, Playwright, `agent-browser`) that the
  user installs separately under their own licenses.

## omo-research (claim-ledger verification gate)

The claim-ledger / independent-corroboration gate in `.kiro/skills/omo-research/SKILL.md`
adapts an idea (not code) from **insane-research** by fivetaku.

- Source: <https://github.com/fivetaku/insane-research>
- License: MIT
- Only the verification-gate concept is adapted; no source is vendored.

## Upstream

The whole package is a port of **Oh My OpenAgent** (<https://github.com/code-yeongyu/oh-my-openagent>),
tracking upstream `v4.19.4`. Prompts and skills here are condensed rewrites, not verbatim copies,
except where a skill directory is explicitly vendored as noted above.
