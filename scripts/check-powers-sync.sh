#!/usr/bin/env bash
# Fail if the powers/ mirror has drifted from .kiro/.
set -uo pipefail
cd "$(dirname "$0")/.."
status=0
for d in agents prompts skills steering settings; do
  if ! diff -rq ".kiro/$d" "powers/omo-kiro/$d" >/dev/null 2>&1; then
    echo "DRIFT: .kiro/$d vs powers/omo-kiro/$d"
    diff -rq ".kiro/$d" "powers/omo-kiro/$d" || true
    status=1
  fi
done
[ "$status" -eq 0 ] && echo "mirror in sync"
exit "$status"
