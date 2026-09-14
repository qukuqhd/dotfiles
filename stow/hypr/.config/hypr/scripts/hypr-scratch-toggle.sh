#!/bin/bash
# Hyprland 版 Scratchpad 切换脚本 (对应 niri 的 niri-scratch-toggle.sh)
# 用 Hyprland special workspace "scratchpad" 实现
set -uo pipefail

CLASS="scratchpad"

if hyprctl clients -j 2>/dev/null | jq -e --arg c "$CLASS" '[.[] | select(.class == $c)] | length > 0' >/dev/null 2>&1; then
    hyprctl dispatch togglespecialworkspace scratchpad
else
    hyprctl dispatch exec kitty --class "$CLASS" --title Scratchpad
    sleep 0.4
    hyprctl dispatch togglespecialworkspace scratchpad
fi
