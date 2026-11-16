-- Ctrl-S 保存（normal / visual / insert 模式）
vim.keymap.set({ 'n', 'x' }, '<C-s>', '<Cmd>write<CR>', { desc = 'Save buffer' })
-- 插入模式：保存并退出到普通模式
vim.keymap.set('i', '<C-s>', '<Esc><Cmd>write<CR>', { desc = 'Save buffer and go to Normal mode' })

-- nvim 每次 LspAttach 都会把插入模式的 <C-S> 重新绑成签名帮助，
-- 这里在它之后重新断言为保存，保证 C-s 保存始终生效
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    vim.keymap.set('i', '<C-s>', '<Esc><Cmd>write<CR>', { desc = 'Save buffer and go to Normal mode' })
  end,
})
