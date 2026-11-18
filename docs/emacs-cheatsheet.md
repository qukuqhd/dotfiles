# Emacs 中文速查

这份文档只覆盖本机配置里我们自己维护的部分。Emacs 自带的 UI 提示和
docstring 仍是英文（Emacs 没有运行时 i18n），官方中文资料见文末。

## 启动页 / 主题 / 字体

- `<f2>` 或 `M-x dashboard-open`：打开 dashboard
- dashboard 里的 `主页` / `恢复会话` / `设置` / `更新`
- Noctalia 换壁纸后重新渲染主题：

  ```bash
  noctalia msg config-reload
  noctalia msg templates-apply
  ```

  然后 `M-x load-theme RET noctalia RET`
- 当前外观：
  - GUI logo：Noctalia 图标（`/usr/share/icons/hicolor/scalable/apps/noctalia.svg`）
  - 终端 banner：`~/.emacs.d/banner.txt`
  - 默认字体：JetBrainsMono NF，中文回退 Maple Mono NF CN
  - mode-line / fixed-pitch：JetBrainsMono NF
  - variable-pitch：Adwaita Sans
  - frame：94% 背景透明度 + 1px 主题色内边框
- 本速查：`M-x my/emacs-cheatsheet`

## clice（C/C++）

打开 C/C++ 文件后自动使用 clice（不是 clangd）。当前上下文显示在 mode line。

| 按键 | 命令 |
|---|---|
| `C-c z c` | 切换编译上下文 |
| `C-c z C` | 切换构建配置 |
| `C-c z r` | 重置为自动上下文 |
| `C-c z o` | 显示/隐藏其他上下文的代码 |
| `C-c z h` | 头文件 ↔ 源文件 |
| `C-c z k` | 查看编译命令 |
| `C-c z R` | 重启 clice |
| `C-c z d` | 查看当前 buffer 的 LSP/上下文状态 |
| `C-c z l` / `f` / `i` / `s` / `q` | lint / format check / index / scan / query |
| `C-c z t` | 打开 `clice.toml` |

其他：

- 保存 `clice.toml` 或切换构建配置后，clice 会请求重启，包会自动重连
- `std::string` 之类的自动 include 依赖 clice 的索引：项目里至少有一个 TU
  包含过 `<string>`，否则 clice 不知道这个符号

## Haskell

- 打开 `.hs` 自动启动 `haskell-mode` + Eglot + HLS（ghcup 里的
  `haskell-language-server-wrapper`）
- `M-x interactive-haskell-mode`：打开 GHCi 交互（之后 `C-c C-l` 加载 buffer）
- `M-x eglot-format`：用 HLS 格式化当前 buffer
- HLS 的 ghcup 路径由 `custom-post.el` 动态解析，不写死版本

## agent-shell（AI agent）

- `C-c a` / `F12`：打开/切换当前项目的 agent-shell
- `C-c A`：新 session
- `C-c z` 前缀：clice 命令（见上表）
- 临时错误会自动重试（5/10/20/40/80 秒，最多 5 次）
- Markdown buffer 里 `C-c p`：用 agent-shell 的渲染器预览

## Emacs 官方中文资料

- 中文教程：`C-h t`（`TUTORIAL.cn`，系统已带）
- 语言环境：`M-x set-language-environment`，本机 `LANG=zh_CN.UTF-8`
  通常已是 `Chinese-GBK`；这只影响编码/输入，不会翻译界面
- 官方 `emacs.info` / `elisp.info` 目前是英文，系统未安装中文 Info 手册
- 输入法：建议用 fcitx5，而不是 Emacs 内置输入法

## 说明

Emacs 的 `M-x` prompt、错误消息、`describe-*` docstring 都是编译进源码的
英文字符串；要整体汉化只能改 Emacs 源码或维护 gettext 翻译层，不适合本机
配置。这里选择的是“官方界面保持英文 + 自己的 dashboard/命令/文档中文”。
