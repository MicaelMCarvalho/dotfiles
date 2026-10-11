#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPOSITORY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$REPOSITORY_DIR"

printf 'Checking Bash syntax...\n'
bash -n install.sh scripts/check.sh scripts/monitors_position_macos/*.sh

printf 'Checking Zsh syntax...\n'
command -v zsh >/dev/null 2>&1 || {
  printf 'zsh is required.\n' >&2
  exit 127
}
zsh -n zsh/.zshrc zsh/.aliases zsh/.fzcmd_descriptions.zsh

if command -v shellcheck >/dev/null 2>&1; then
  printf 'Running ShellCheck...\n'
  shellcheck install.sh scripts/check.sh scripts/monitors_position_macos/*.sh
else
  printf 'Skipping ShellCheck (not installed).\n'
fi

if command -v wezterm >/dev/null 2>&1; then
  printf 'Validating WezTerm configuration...\n'
  wezterm --config-file "$REPOSITORY_DIR/wezterm/.wezterm.lua" show-keys --lua >/dev/null
else
  printf 'Skipping WezTerm validation (not installed).\n'
fi

git diff --check
printf 'All available checks passed.\n'
