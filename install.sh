#!/usr/bin/env bash
# ==============================================================================
# dotfiles — stow 风格符号链接管理器
#
# 布局兼容 GNU stow：stow/<package>/<相对 $HOME 的路径>
# 默认把仓库里的文件以「相对符号链接」方式挂到 $HOME，卸载时只删除指向本仓库
# 的链接，绝不触碰运行时生成的文件（Noctalia 主题、effects.kdl 等）。
#
#   ./install.sh link                   # 建立/刷新所有链接（默认动作）
#   ./install.sh link --replace-identical   # 迁移用：实体文件与仓库内容完全一致时替换为链接
#   ./install.sh status                 # 只读检查，报告 ok / missing / conflict
#   ./install.sh unlink                 # 卸载链接并清理空目录
#
# 环境变量 DOTFILES_TARGET 可覆盖目标目录（默认 $HOME），便于测试。
# 若本机装了 GNU stow，也可以直接用：
#   stow --no-folding -t ~ -d ~/dotfiles/stow <package>
# ==============================================================================
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
STOW_DIR="$DOTFILES_ROOT/stow"
TARGET="${DOTFILES_TARGET:-$HOME}"

# 运行时会改写、但仓库里保留一份默认值的文件：已存在时永不覆盖。
VOLATILE_PATHS=(
  ".config/niri/effects.kdl"
)

# 独立 git 仓库：「仓库内路径|目标位置」，二者内容由各自的 git 仓库管理。
EXTERNAL_LINKS=(
  "external/nvim|.config/nvim"
  "external/emacs|.emacs.d"
)

C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_RED=$'\033[31m'; C_DIM=$'\033[2m'; C_RESET=$'\033[0m'

created=0; unchanged=0; replaced=0; skipped=0; removed=0; conflicting=0
conflicts=()

say_ok()     { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$1"; }
say_create() { printf '  %s+%s %s\n' "$C_GREEN" "$C_RESET" "$1"; }
say_skip()   { printf '  %s·%s %s %s\n' "$C_DIM" "$C_RESET" "$1" "$C_DIM$2$C_RESET"; }
say_warn()   { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$1"; }
say_err()    { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$1"; }

is_volatile() {
  local rel="$1" v
  for v in "${VOLATILE_PATHS[@]}"; do
    [[ "$rel" == "$v" ]] && return 0
  done
  return 1
}

managed_files() {
  local pkg_dir="$1"
  find "$pkg_dir" -mindepth 1 \( -type f -o -type l \) \
    -not -path '*/__pycache__/*' -not -name '*.pyc' \
    -printf '%P\n'
}

link_target_for() {
  # 相对符号链接（stow 默认行为），仓库整体搬迁后依然有效
  realpath --relative-to="$(dirname "$2")" "$1"
}

same_link() {
  local dest="$1" src="$2"
  [[ -L "$dest" ]] || return 1
  [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]
}

conflict() {
  conflicting=$((conflicting + 1))
  conflicts+=("$1")
  say_err "conflict  $1"
}

cmd_link() {
  local replace_identical=0
  for arg in "$@"; do
    case "$arg" in
      --replace-identical) replace_identical=1 ;;
      -h|--help) cmd_help; exit 0 ;;
      *) printf 'unknown option: %s\n' "$arg" >&2; exit 2 ;;
    esac
  done

  printf 'linking %s -> %s\n' "$STOW_DIR" "$TARGET"
  local pkg_dir pkg rel src dest
  for pkg_dir in "$STOW_DIR"/*/; do
    [[ -d "$pkg_dir" ]] || continue
    pkg="$(basename "$pkg_dir")"
    printf '%s\n' "${C_DIM}[$pkg]${C_RESET}"
    while IFS= read -r rel; do
      [[ -n "$rel" ]] || continue
      src="${pkg_dir}${rel}"
      dest="$TARGET/$rel"

      if is_volatile "$rel" && { [[ -e "$dest" || -L "$dest" ]]; }; then
        skipped=$((skipped + 1))
        say_skip "$rel" "(运行时状态，保留现状)"
        continue
      fi

      if same_link "$dest" "$src"; then
        unchanged=$((unchanged + 1))
        say_ok "$rel"
      elif [[ -L "$dest" ]]; then
        conflict "$rel (已是符号链接，指向 $(readlink "$dest"))"
      elif [[ -e "$dest" ]]; then
        if [[ "$replace_identical" == "1" ]] && cmp -s "$src" "$dest"; then
          rm -f "$dest"
          mkdir -p "$(dirname "$dest")"
          ln -s "$(link_target_for "$src" "$dest")" "$dest"
          replaced=$((replaced + 1))
          say_create "$rel (内容一致，已替换为链接)"
        else
          conflict "$rel (实体文件，未被替换)"
        fi
      else
        mkdir -p "$(dirname "$dest")"
        ln -s "$(link_target_for "$src" "$dest")" "$dest"
        created=$((created + 1))
        say_create "$rel"
      fi
    done < <(managed_files "$pkg_dir")
  done

  local entry src_rel dest_rel
  printf '%s\n' "${C_DIM}[external]${C_RESET}"
  for entry in "${EXTERNAL_LINKS[@]}"; do
    src_rel="${entry%%|*}"; dest_rel="${entry##*|}"
    src="$DOTFILES_ROOT/$src_rel"; dest="$TARGET/$dest_rel"
    if [[ ! -d "$src" ]]; then
      if [[ -d "$dest" && ! -L "$dest" ]]; then
        say_warn "$dest_rel 仍是实体目录：mv \"$dest\" \"$src\" && $0 link"
      else
        say_warn "$dest_rel 缺失（$src_rel 尚未克隆）"
      fi
      continue
    fi
    if same_link "$dest" "$src"; then
      unchanged=$((unchanged + 1))
      say_ok "$dest_rel -> $src_rel"
    elif [[ -e "$dest" || -L "$dest" ]]; then
      conflict "$dest_rel (已存在，未接管)"
    else
      mkdir -p "$(dirname "$dest")"
      ln -s "$(link_target_for "$src" "$dest")" "$dest"
      created=$((created + 1))
      say_create "$dest_rel -> $src_rel"
    fi
  done

  printf '\n新建 %d · 已是最新 %d · 替换 %d · 跳过 %d · 冲突 %d\n' \
    "$created" "$unchanged" "$replaced" "$skipped" "$conflicting"
  if (( conflicting > 0 )); then
    printf '%s有 %d 处冲突未处理，请人工确认后再重跑。%s\n' "$C_RED" "$conflicting" "$C_RESET" >&2
    return 1
  fi
  if command -v nyxniri >/dev/null 2>&1; then
    say_warn "检测到 NyxNiri：它用「复制」方式部署 .config/niri 与 .config/kitty，重复执行会覆盖这里的链接。"
  fi
  return 0
}

cmd_status() {
  local pkg_dir rel src dest missing=0 ok_n=0 conf=0 vol=0
  printf 'status: %s -> %s\n' "$STOW_DIR" "$TARGET"
  for pkg_dir in "$STOW_DIR"/*/; do
    [[ -d "$pkg_dir" ]] || continue
    printf '%s\n' "${C_DIM}[$(basename "$pkg_dir")]${C_RESET}"
    while IFS= read -r rel; do
      [[ -n "$rel" ]] || continue
      src="${pkg_dir}${rel}"; dest="$TARGET/$rel"
      if same_link "$dest" "$src"; then
        ok_n=$((ok_n + 1)); say_ok "$rel"
      elif is_volatile "$rel" && [[ -e "$dest" || -L "$dest" ]]; then
        vol=$((vol + 1)); say_skip "$rel" "(运行时状态)"
      elif [[ -e "$dest" || -L "$dest" ]]; then
        conf=$((conf + 1)); say_err "conflict  $rel"
      else
        missing=$((missing + 1)); say_warn "missing   $rel"
      fi
    done < <(managed_files "$pkg_dir")
  done
  local entry src_rel dest_rel
  for entry in "${EXTERNAL_LINKS[@]}"; do
    src_rel="${entry%%|*}"; dest_rel="${entry##*|}"
    src="$DOTFILES_ROOT/$src_rel"; dest="$TARGET/$dest_rel"
    if [[ ! -d "$src" ]]; then
      say_warn "$dest_rel 外部仓库不存在"
    elif same_link "$dest" "$src"; then
      ok_n=$((ok_n + 1)); say_ok "$dest_rel -> $src_rel"
    elif [[ -e "$dest" || -L "$dest" ]]; then
      conf=$((conf + 1)); say_err "conflict  $dest_rel"
    else
      missing=$((missing + 1)); say_warn "missing   $dest_rel"
    fi
  done
  printf '\n已链接 %d · 缺失 %d · 冲突 %d · 运行时保留 %d\n' "$ok_n" "$missing" "$conf" "$vol"
  (( missing == 0 && conf == 0 ))
}

cmd_unlink() {
  local pkg_dir rel src dest
  printf 'unlinking %s <- %s\n' "$TARGET" "$STOW_DIR"
  for pkg_dir in "$STOW_DIR"/*/; do
    [[ -d "$pkg_dir" ]] || continue
    while IFS= read -r rel; do
      [[ -n "$rel" ]] || continue
      src="${pkg_dir}${rel}"; dest="$TARGET/$rel"
      if same_link "$dest" "$src"; then
        rm -f "$dest"
        removed=$((removed + 1))
        say_create "删除链接 $rel"
        # 逐级清理空目录，止于 $TARGET
        local d; d="$(dirname "$dest")"
        while [[ "$d" != "$TARGET" && "$d" == "$TARGET"/* ]] && [[ -d "$d" ]] && [[ -z "$(ls -A "$d")" ]]; do
          rmdir "$d"; d="$(dirname "$d")"
        done
      fi
    done < <(managed_files "$pkg_dir")
  done
  local entry suffix
  for entry in "${EXTERNAL_LINKS[@]}"; do
    src="$DOTFILES_ROOT/${entry%%|*}"; dest="$TARGET/${entry##*|}"
    if same_link "$dest" "$src"; then
      rm -f "$dest"; removed=$((removed + 1)); say_create "删除链接 ${entry##*|}"
    fi
  done
  printf '\n删除 %d 个链接（仓库内容未改动）\n' "$removed"
}

cmd_help() {
  sed -n '3,14p' "$0" | sed 's/^# \{0,1\}//'
}

case "${1:-link}" in
  link)   shift || true; cmd_link "$@" ;;
  status) cmd_status ;;
  unlink) cmd_unlink ;;
  -h|--help|help) cmd_help ;;
  *) printf 'usage: %s [link|status|unlink]\n' "$0" >&2; exit 2 ;;
esac
