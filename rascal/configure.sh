#!/usr/bin/env bash

set -euo pipefail

readonly domain=dev.chang.FinderTwo

set_initial_preference() {
  local key="FinderTwo.$1"
  shift
  if ! defaults read "$domain" "$key" >/dev/null 2>&1; then
    defaults write "$domain" "$key" "$@"
  fi
}

set_initial_preference theme -string dracula
set_initial_preference density -string compact
set_initial_preference vimEnabled -bool true
