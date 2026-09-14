# external/ — 独立 git 仓库

这两个目录是从 `~/.config` 搬进来的、拥有独立 git 历史的上游 fork，
因此**不纳入本仓库的版本控制**（见根目录 `.gitignore`），由各自的仓库管理：

| 目录 | 来源 | 挂载位置 | 远端 |
|---|---|---|---|
| `nvim/` | `~/.config/nvim` | `~/.config/nvim` | `nvim-lua/kickstart.nvim` |
| `emacs/` | `~/.emacs.d` | `~/.emacs.d` | `seagle0128/.emacs.d`（Centaur Emacs） |

`install.sh link` 会在两个目录存在时自动建立符号链接；目录不存在时会提示
（新机器上先 clone 自己的 fork 到这里）。

同步个人改动：

```bash
git -C ~/dotfiles/external/nvim  status
git -C ~/dotfiles/external/emacs status
```

注意 `~/.emacs.d/elpa`（约 73M）与 `~/.emacs.d/eln-cache` 属于生成物，
由 Centaur Emacs 自带的 `.gitignore` 排除，不要提交。
