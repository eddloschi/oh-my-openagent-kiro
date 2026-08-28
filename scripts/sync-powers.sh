#!/usr/bin/env bash
# Mirror .kiro/{agents,prompts,skills,steering,settings} into powers/omo-kiro/.
# POWER.md and model-map.json are power-only and are never touched here.
set -euo pipefail
cd "$(dirname "$0")/.."
for d in agents prompts skills steering settings; do
  rm -rf "powers/omo-kiro/$d"
  cp -R ".kiro/$d" "powers/omo-kiro/$d"
  echo "synced .kiro/$d -> powers/omo-kiro/$d"
done
