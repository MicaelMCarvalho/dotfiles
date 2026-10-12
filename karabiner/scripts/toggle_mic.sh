#!/usr/bin/env bash

set -Eeuo pipefail

readonly MUTED_SOUND='/System/Library/Sounds/Tink.aiff'
readonly UNMUTED_SOUND='/System/Library/Sounds/Pop.aiff'

command -v osascript >/dev/null 2>&1 || exit 127

current_volume="$(osascript -e 'input volume of (get volume settings)')"

if (( current_volume > 0 )); then
  osascript -e 'set volume input volume 0'
  [[ -f "$MUTED_SOUND" ]] && afplay "$MUTED_SOUND"
else
  osascript -e 'set volume input volume 100'
  [[ -f "$UNMUTED_SOUND" ]] && afplay "$UNMUTED_SOUND"
fi
