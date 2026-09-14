# dotfiles

个人 dotfiles 仓库：stow 风格布局 + 符号链接部署。收录当前正在使用的
窗口管理器、终端、nvim、emacs 配置，以及驱动配色的 Noctalia 模板。
![alt text](image.png)
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

## 与 [NyxNiri](https://github.com/ech678/NyxNiri) 的关系

[`~/NyxNiri`](https://github.com/ech678/NyxNiri) 仍在管理 `fish`、`starship`、`fastfetch`、`zed`、
`xdg-desktop-portal` 等系统层配置，部署方式是**复制**。它与本仓库重叠的
只有 `.config/niri` 和 `.config/kitty`：

- 重新运行 `nyxniri` 的安装/更新流程会覆盖这两个目录里的符号链接。
- 需要改 niri/kitty 时，请改本仓库后 `./install.sh link`，不要再走 [NyxNiri](https://github.com/ech678/NyxNiri)。

## 主题链路

Noctalia 是配色的单一来源：它渲染 `~/.config/<app>/themes/noctalia.*`、
`niri/noctalia.kdl`、`nvim/lua/matugen.lua`，并通过
`templates/nvim/apply.sh`、`templates/emacs/apply.sh` 通知运行中的编辑器
重载配色。因此本仓库只保存模板与静态配置，渲染产物一律现算。
