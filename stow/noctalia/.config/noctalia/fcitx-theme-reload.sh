#!/usr/bin/env bash
# NyxMellow 皮肤更新后，让 fcitx5 真正加载新皮肤。
#
# 背景：fcitx5 只在**启动时**读取主题资源（theme.conf / panel.svg / highlight.svg）。
# 用 inotify 监控主题目录实测：
#   - `fcitx5-remote --check -r`（重载配置）→ 零文件访问，候选窗皮肤不变
#   - 改 classicui.conf 里的 Theme 名称（nyxmellow ↔ default）→ 同样零文件访问
#   - 手动 cat 主题文件（对照组）→ 能抓到 open/access，说明监控有效
# 结论：Noctalia 每次重渲染皮肤后必须重启 fcitx5，只重载配置会一直停留在
# 上一次启动时读到的那份皮肤（表现为“换了主题但输入法皮肤没生效”）。
#
# 为避免每次调色板变化都打断输入，这里先比对皮肤内容指纹：没变就直接退出。
set -uo pipefail

theme_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fcitx5/themes/nyxmellow"
stamp="${XDG_CACHE_HOME:-$HOME/.cache}/noctalia/nyxmellow-skin.sha"
files=("$theme_dir/theme.conf" "$theme_dir/panel.svg" "$theme_dir/highlight.svg")

sum="$(cat "${files[@]}" 2>/dev/null | sha256sum | cut -c1-16)"
[ -n "$sum" ] || exit 0

# 皮肤内容没变：什么都不做，不打扰正在输入的会话
if [ "$sum" = "$(cat "$stamp" 2>/dev/null)" ]; then
    exit 0
fi

mkdir -p "$(dirname "$stamp")"
printf '%s' "$sum" > "$stamp"

# 皮肤变了：重启 fcitx5（只重载配置不会重新读取皮肤资源）
fcitx5-remote --check -r >/dev/null 2>&1 || true
if pgrep -x fcitx5 >/dev/null 2>&1; then
    fcitx5-remote --check -e >/dev/null 2>&1 || pkill -x fcitx5 >/dev/null 2>&1 || true
    sleep 1
fi
if ! pgrep -x fcitx5 >/dev/null 2>&1; then
    setsid fcitx5 -d >/dev/null 2>&1 &
fi
