#!/usr/bin/env bash

set -Eeuo pipefail

command -v displayplacer >/dev/null 2>&1 || {
  printf 'displayplacer is required (brew install displayplacer).\n' >&2
  exit 127
}

displayplacer \
  'id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 hz:120 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0' \
  'id:07040476-DCF5-4BDD-BB11-3EBD4AC452EC res:1920x1080 hz:75 color_depth:8 enabled:true scaling:off origin:(-225,-1080) degree:0'
