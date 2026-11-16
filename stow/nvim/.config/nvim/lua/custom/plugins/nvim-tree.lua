-- nvim-tree: 文件目录树
-- https://github.com/nvim-tree/nvim-tree.lua

-- 关闭内置 netrw，避免 :Explore 与 nvim-tree 冲突
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add { 'https://github.com/nvim-tree/nvim-tree.lua' }

require('nvim-tree').setup {
  sort = { sorter = 'case_sensitive' },
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = false, custom = { 'node_modules', '.git' } },
  actions = { open_file = { quit_on_open = true } },
  update_focused_file = { enable = true, update_cwd = true },
}

-- 打开/关闭目录树
vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
vim.keymap.set('n', '\\', '<Cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
