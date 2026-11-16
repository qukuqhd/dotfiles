-- lean.nvim: Lean 4 定理证明器支持（LSP + infoview）
-- https://github.com/Julian/lean.nvim
vim.pack.add { 'https://github.com/Julian/lean.nvim' }

-- nvim 0.12+ 推荐用法：设置 vim.g.lean_config 即可，打开 .lean 文件时自动激活
vim.g.lean_config = {
  mappings = true, -- 启用默认键位（如 <Space>i 打开 infoview）
  -- 自动隐式参数（如 `{α}`、`{n}`）以 inlay hint 形式内联显示
  inlay_hint = { enabled = true },
  infoview = {
    autoopen = true, -- 进入 .lean 文件时自动打开 infoview
    view_options = {
      show_types = true, -- 在 infoview 中显示假设的类型
      show_term_goals = true, -- 显示 term goal（期望类型）
    },
  },
}
