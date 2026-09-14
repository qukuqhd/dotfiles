#!/bin/bash
# Hyprland 版 EyeCare 切换脚本
# 由 niri 版 ~/.config/niri/scripts/toggle-eyecare.sh 移植
# 状态存于 ~/.local/state/hypr-eyecare, 启动时用 --sync 重新对齐 wlsunset
set -uo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/hypr-eyecare"
EYECARE_TEMP=5500

mkdir -p "$STATE_DIR"

CURRENTLY_ON=false
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE" 2>/dev/null)" = "on" ]; then
    CURRENTLY_ON=true
fi

apply_state() {
    if [ "$1" = "on" ]; then
        hyprctl keyword decoration:blur:enabled false >/dev/null 2>&1 || true
        hyprctl keyword decoration:active_opacity 1.0 >/dev/null 2>&1 || true
        hyprctl keyword decoration:inactive_opacity 1.0 >/dev/null 2>&1 || true
        echo on > "$STATE_FILE"
    else
        hyprctl keyword decoration:blur:enabled true >/dev/null 2>&1 || true
        hyprctl keyword decoration:active_opacity 0.9 >/dev/null 2>&1 || true
        hyprctl keyword decoration:inactive_opacity 0.85 >/dev/null 2>&1 || true
        echo off > "$STATE_FILE"
    fi
}

if [ "${1:-}" = "--sync" ]; then
    pkill -x wlsunset 2>/dev/null || true
    noctalia msg nightlight-disable 2>/dev/null || true
    if [ "$CURRENTLY_ON" = "true" ]; then
        nohup wlsunset -T 6500 -t "$EYECARE_TEMP" -d 0.3 -S 00:00 -s 00:00 >/dev/null 2>&1 &
    fi
    exit 0
fi

pkill -x wlsunset 2>/dev/null || true
noctalia msg nightlight-disable 2>/dev/null || true

if [ "$CURRENTLY_ON" = "true" ]; then
    apply_state off
    notify-send -t 2000 "Eye Care : Off"
else
    apply_state on
    sleep 0.05
    nohup wlsunset -T 6500 -t "$EYECARE_TEMP" -d 0.3 -S 00:00 -s 00:00 >/dev/null 2>&1 &
    notify-send -t 2000 "Eye Care : On"
fi
