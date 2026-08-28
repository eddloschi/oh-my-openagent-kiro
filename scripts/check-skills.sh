#!/usr/bin/env bash
# Every SKILL.md has frontmatter name/description, and name matches its directory.
set -uo pipefail
cd "$(dirname "$0")/.."
status=0
for f in .kiro/skills/*/SKILL.md; do
  d=$(basename "$(dirname "$f")")
  n=$(awk -F': ' '/^name:/{print $2; exit}' "$f" | tr -d '"'"'"' \r')
  if [ "$n" != "$d" ]; then echo "NAME MISMATCH: $f has name='$n', dir='$d'"; status=1; fi
  if ! grep -q '^description:' "$f"; then echo "NO DESCRIPTION: $f"; status=1; fi
done
[ "$status" -eq 0 ] && echo "skills ok"
exit "$status"
