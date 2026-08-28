#!/usr/bin/env bash
# Fail if any OpenCode/Codex-only tool name is used as an *instruction* under .kiro/.
#
# Naming a token in order to ban or explain it ("never use `tmux capture-pane`", the
# limitations table, "Kiro does not expose `task()`") is correct and expected, so lines
# that carry a negation marker are allowed. Everything else is a real leak.
set -uo pipefail
cd "$(dirname "$0")/.."

TOKENS='(^|[^_[:alnum:]])task\(|call_omo_agent|subagent_type=|category=|run_in_background|todowrite|todoread|lsp_diagnostics|codegraph_|ast_grep_search|multi_agent|spawn_agent|team_create|team_send|team_task|team_shutdown|tmux capture-pane|ulw-loop|create_goal|update_goal|session_read'
# Lines that mention a token only to forbid, replace, or explain the absence of it.
# A markdown table row (the limitations matrix) documents replacements, not instructions.
NEGATION='[Nn]ever|[Nn]ot expose|does not|do not|[Nn]o longer|[Rr]emoved|unavailable|[Ii]nstead|[Uu]pstream|There is no|has no|absent|deprecated|banned|BANNED|없|지원하지|\|.*\|'
# Skills that legitimately name other harnesses as *data* they read, or document a protocol.
EXCLUDE='\.kiro/skills/omo-lsp-setup/references/|\.kiro/skills/omo-coding-agent-sessions/(references|scripts)/|\.kiro/skills/omo-programming/references/'

hits=$(grep -rnE "$TOKENS" .kiro 2>/dev/null | grep -vE "$EXCLUDE" | grep -viE "$NEGATION")

if [ -n "$hits" ]; then
  echo "FORBIDDEN TOKEN USED AS AN INSTRUCTION:"
  echo "$hits"
  exit 1
fi

bare=$(grep -rn '\.omo/' .kiro 2>/dev/null | grep -v '\.kiro/omo/' | grep -vE "$EXCLUDE")
if [ -n "$bare" ]; then
  echo "BARE .omo/ PATH (should be .kiro/omo/):"
  echo "$bare"
  exit 1
fi

echo "no forbidden tokens"
