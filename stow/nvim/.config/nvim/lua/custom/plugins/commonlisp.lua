-- Common Lisp：swank.nvim（REPL / 求值 / SLDB 调试器 / inspector / xref）
-- https://github.com/corigne/swank.nvim
-- 先注册补丁钩子：上游在 libuv 回调里直接 vim.notify 会触发 E5560，
-- 安装/更新后自动重新应用本地补丁。
local patch = require('custom.commonlisp-patch')

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == 'swank.nvim' and (kind == 'install' or kind == 'update') then
      patch.apply()
    end
  end,
})

vim.pack.add { 'https://github.com/corigne/swank.nvim' }

-- 确保当前磁盘上的插件也带补丁
patch.apply()

-- 默认配置即可：打开 .lisp 文件时自动启动 sbcl 并连接 Swank
require('swank').setup {
  autostart = {
    enabled = true,
    implementation = 'sbcl',
  },
}
