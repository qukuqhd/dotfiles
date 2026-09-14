#!/usr/bin/env bash
set -euo pipefail

# Noctalia 已经重新渲染 ~/.config/nvim/lua/matugen.lua，
# 通知所有正在运行的 nvim 重新加载配色。
pkill -SIGUSR1 nvim >/dev/null 2>&1 || true
