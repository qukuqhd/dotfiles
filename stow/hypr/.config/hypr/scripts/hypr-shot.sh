#!/bin/bash
# Hyprland 版截图脚本 (对应 niri 内置截图)
# 用法: hypr-shot.sh region|screen|window
set -uo pipefail

MODE="${1:-region}"
DIR="$HOME/图片/Screenshots"
mkdir -p "$DIR"
TS="$(date '+%Y-%m-%d %H-%M-%S')"
FILE="$DIR/Screenshot from $TS.png"

case "$MODE" in
    region)
        GEOM="$(slurp)" || exit 1
        grim -g "$GEOM" "$FILE" || exit 1
        ;;
    screen)
        OUT="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.monitor // empty')"
        if [ -n "$OUT" ]; then
            grim -o "$OUT" "$FILE" || exit 1
        else
            grim "$FILE" || exit 1
        fi
        ;;
    window)
        GEOM="$(hyprctl activewindow -j 2>/dev/null | jq -r 'if .class then "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])" else empty end')"
        [ -n "$GEOM" ] || exit 1
        grim -g "$GEOM" "$FILE" || exit 1
        ;;
    *)
        echo "usage: $0 region|screen|window" >&2
        exit 2
        ;;
esac

notify-send -t 1500 "Screenshot saved" "$FILE"
