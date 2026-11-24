#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -gt 1 ]; then
  printf 'Usage: bash install.sh [destination]\n' >&2
  exit 1
fi

destination="${1-${CODEX_HOME:-$HOME/.codex}/skills/duet}"
if [ -z "$destination" ]; then
  printf 'Error: destination must not be empty.\n' >&2
  exit 1
fi
if [ -e "$destination" ] || [ -L "$destination" ]; then
  if [ ! -d "$destination" ]; then
    printf 'Error: destination is not a directory: %s\n' "$destination" >&2
    exit 1
  fi
fi
if ! command -v git >/dev/null 2>&1; then
  printf 'Error: git is required. Install git and run this installer again.\n' >&2
  exit 1
fi

staging="$(mktemp -d "${TMPDIR:-/tmp}/duet-install.XXXXXXXX")"
trap 'rm -rf -- "$staging"' EXIT

git clone --depth 1 --branch main --single-branch \
  https://github.com/YuhangJia123/duet.git "$staging/source"

files=(
  SKILL.md
  README.md
  README.zh-CN.md
  agents/openai.yaml
  references/cost-and-sources.md
  models.json
)

# Validate the complete snapshot before changing the installed skill.
for file in "${files[@]}"; do
  if [ ! -f "$staging/source/$file" ]; then
    printf 'Error: required source file is missing: %s\n' "$file" >&2
    exit 1
  fi
done

mkdir -p -- "$destination/agents" "$destination/references"
for file in "${files[@]}"; do
  if [ "$file" = models.json ] && { [ -e "$destination/$file" ] || [ -L "$destination/$file" ]; }; then
    continue
  fi
  cp -- "$staging/source/$file" "$destination/$file"
done

printf '\nInstalled duet to: %s\n' "$destination"
printf 'Invoke it with $duet in Codex. /duet works only if your host forwards slash text to the model.\n'
printf 'Existing models.json and extra files are preserved on updates.\n'
