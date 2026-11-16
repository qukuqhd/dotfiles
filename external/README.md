# external/ — 独立 git 仓库

这里存放拥有独立 git 历史的上游 fork，**不纳入本仓库的版本控制**（见根目录
`.gitignore`），由各自的仓库管理：

| 目录 | 来源 | 挂载位置 | 远端 |
|---|---|---|---|
| `emacs/` | `~/.emacs.d` | `~/.emacs.d` | `seagle0128/.emacs.d`（Centaur Emacs） |

Neovim 配置已经迁入 `../stow/nvim/.config/nvim`，由 `install.sh` 按文件建立
符号链接，不再放在这里。`nvim-pack-lock.json`、`lua/matugen.lua` 等运行时
生成物只存在于 `~/.config/nvim`，不进仓库。

`install.sh link` 会在 `external/emacs` 存在时自动建立 `~/.emacs.d` 的符号链接；
目录不存在时会提示（新机器上先 clone 自己的 Centaur fork 到这里）。

同步个人改动：

```bash
git -C ~/dotfiles/external/emacs status
```

注意 `~/.emacs.d/elpa`（约 73M）与 `~/.emacs.d/eln-cache` 属于生成物，
由 Centaur Emacs 自带的 `.gitignore` 排除，不要提交。
