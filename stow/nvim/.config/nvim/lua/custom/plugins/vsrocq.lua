-- VsRocq: Rocq (Coq) 语言服务器接入
-- https://github.com/tomtomjhj/vsrocq.nvim

-- Coqtail 仅用于 .v 文件类型识别和语法高亮，禁用其自身功能
-- 注意：变量名是 coqtail_supported（下划线），README 里写的 coqtail#supported 已过时
vim.g.loaded_coqtail = 1
vim.g.coqtail_supported = 0
vim.g.coqtail_nomap = 1

-- 注：已把 Coqtail 安装目录里 ftplugin/coq.vim 的误报提示（"requires Python"）移除，
--     见 ~/.local/share/nvim/site/pack/core/opt/Coqtail/ftplugin/coq.vim

vim.pack.add { 'https://github.com/whonore/Coqtail' }
vim.pack.add { 'https://github.com/tomtomjhj/vsrocq.nvim' }

-- vsrocqtop 不支持 textDocument/signatureHelp，
-- 禁用 coq 缓冲区的补全（blink.cmp 就不会自动请求签名帮助，也就不再报错）
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'coq',
  callback = function()
    vim.b.completion = false
  end,
})

require('vsrocq').setup {
  vsrocq = {
    -- 连续模式：文档内容变化时自动持续检查证明
    proof = { mode = 'Continuous' },
  },
  lsp = {
    -- vsrocqtop 通过 opam 安装，显式指定路径更稳妥
    cmd = { vim.fn.expand('~/.opam/default/bin/vsrocqtop') },
    on_attach = function(client, bufnr)
      local map = function(keys, cmd, desc)
        vim.keymap.set('n', keys, '<Cmd>' .. cmd .. '<CR>', { buffer = bufnr, desc = 'VsRocq: ' .. desc })
      end

      -- 手动模式下的证明导航
      map('<leader>rf', 'VsRocq stepForward', 'Step forward')
      map('<leader>rb', 'VsRocq stepBackward', 'Step backward')
      map('<leader>ri', 'VsRocq interpretToPoint', 'Interpret to point')
      map('<leader>rg', 'VsRocq interpretToEnd', 'Interpret to end')
      map('<leader>rj', 'VsRocq jumpToEnd', 'Jump to checked end')

      -- 面板与模式切换
      map('<leader>rp', 'VsRocq panels', 'Open panels')
      map('<leader>rc', 'VsRocq continuous', 'Continuous mode')
      map('<leader>rm', 'VsRocq manual', 'Manual mode')
    end,
  },
}
