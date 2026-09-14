#!/usr/bin/env bash
set -uo pipefail

if command -v emacsclient >/dev/null 2>&1; then
  emacsclient -e "(load-theme 'noctalia t)" >/dev/null 2>&1 || true
fi
