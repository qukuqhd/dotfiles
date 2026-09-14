# dotfiles

个人 dotfiles 仓库：stow 风格布局 + 符号链接部署。收录当前正在使用的
窗口管理器、终端、nvim、emacs 配置，以及驱动配色的 Noctalia 模板。

## 布局

```
dotfiles/
├── stow/                       # stow 包：stow/<pkg>/<相对 $HOME 的路径>
│   ├── niri/.config/niri/…
│   ├── kitty/.config/kitty/…
│   ├── alacritty/.config/alacritty/
│   ├── foot/.config/foot/
│   ├── hypr/.config/hypr/…
│   ├── noctalia/.config/noctalia/…
│   └── noctalia-integrations/.config/{labwc,sway,mango,umbriel,scroll}/
├── external/                   # 独立 git 仓库（nvim / emacs），见 external/README.md
└── install.sh                  # 部署脚本
```

`install.sh` 建立的是**相对符号链接**（GNU stow 默认行为），所以整个仓库
平移后链接依然有效。

## 用法

```bash
cd ~/dotfiles
./install.sh link                    # 建立/刷新链接
./install.sh status                  # 只读检查 ok / missing / conflict
./install.sh unlink                  # 卸载（只删指向本仓库的链接）
./install.sh link --replace-identical  # 迁移：实体文件与仓库逐字节相同时替换成链接
```

新机器首次部署：

```bash
git clone <this-repo> ~/dotfiles
git clone <your-kickstart-fork> ~/dotfiles/external/nvim
git clone <your-centaur-fork>   ~/dotfiles/external/emacs
~/dotfiles/install.sh link
```

装了 GNU stow 的话也可以按包单独 stow（务必加 `--no-folding`，否则会整目录
折叠成一个链接，把运行时生成的文件也卷进仓库）：

```bash
stow --no-folding -t ~ -d ~/dotfiles/stow niri
```

## 收录内容

| 包 | 内容 |
|---|---|
| `niri` | `config.kdl` 及拆分的 `binds/layout/rules/animations/monitor`、`__custom__` 自定义项、`scripts/`（EyeCare 切换、Scratch 菜单、Orbit 启动器、壁纸选择器） |
| `kitty` | `kitty.conf`、`__custom__.conf`（字体等个人偏好挂载点） |
| `alacritty` | `alacritty.toml`（Maple Mono 字体、透明度、Windows 风格按键） |
| `foot` | `foot.ini` |
| `hypr` | `hyprland.conf`/`.lua`、`scripts/`（截图、Scratch、EyeCare） |
| `noctalia` | `noctalia-config.toml`、`templates/`（nvim/emacs/gtk/zed/vscode 主题模板）、hooks |
| `noctalia-integrations` | labwc / sway / mango / umbriel / scroll 的 Noctalia 主题桥接配置 |
| `external/nvim` | kickstart.nvim fork（`init.lua` 个性化 + `lua/custom/` 插件集） |
| `external/emacs` | Centaur Emacs fork（`custom.el`、`lisp/init-*.el`、`themes/`） |

## 有意不纳入版本控制的文件

这些是**运行时生成物**，提交进来只会制造噪音，且会在下次换主题时被覆盖：

| 文件 | 生成者 |
|---|---|
| `niri/noctalia.kdl` | Noctalia |
| `kitty/themes/noctalia.conf`、`kitty/current-theme.conf`(软链) | Noctalia |
| `alacritty/themes/noctalia.toml` | Noctalia |
| `foot/themes/noctalia` | Noctalia |
| `ghostty/themes/noctalia`、`wezterm/colors/Noctalia.toml` | Noctalia（这两个终端暂无自有配置，故未收录） |
| `nvim/lua/matugen.lua` | Noctalia（换主题时重写，请勿提交） |
| `.emacs.d/themes/` 中的 Noctalia 产物、`elpa/`、`eln-cache/` | Emacs / Noctalia |
| `noctalia/settings.json` | Noctalia 运行时状态（位置、天气等） |

例外是 `niri/effects.kdl`：仓库里保留一份指向 `effects_normal.kdl` 的默认
链接（全新机器上 niri 才能通过 config 校验），但 `install.sh` 把它列为
“运行时状态”，一旦存在就绝不覆盖——EyeCare 的开关状态由它保存。

## 与 NyxNiri 的关系

`~/NyxNiri` 仍在管理 `fish`、`starship`、`fastfetch`、`zed`、
`xdg-desktop-portal` 等系统层配置，部署方式是**复制**。它与本仓库重叠的
只有 `.config/niri` 和 `.config/kitty`：

- 重新运行 `nyxniri` 的安装/更新流程会覆盖这两个目录里的符号链接。
- 需要改 niri/kitty 时，请改本仓库后 `./install.sh link`，不要再走 NyxNiri。

## 主题链路

Noctalia 是配色的单一来源：它渲染 `~/.config/<app>/themes/noctalia.*`、
`niri/noctalia.kdl`、`nvim/lua/matugen.lua`，并通过
`templates/nvim/apply.sh`、`templates/emacs/apply.sh` 通知运行中的编辑器
重载配色。因此本仓库只保存模板与静态配置，渲染产物一律现算。
