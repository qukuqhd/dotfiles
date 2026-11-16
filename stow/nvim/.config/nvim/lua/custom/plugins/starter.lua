-- Custom startup screen with a custom logo (mini.starter, part of mini.nvim)
-- Shown when nvim is started without opening any files.
local starter = require 'mini.starter'

starter.setup {
  header = [[
███╗   ██╗  ██╗   ██╗  ██╗  ███╗   ███╗
████╗  ██║  ██║   ██║  ██║  ████╗ ████║
██╔██╗ ██║  ██║   ██║  ██║  ██╔████╔██║
██║╚██╗██║  ╚██╗ ██╔╝  ██║  ██║╚██╔╝██║
██║ ╚████║   ╚████╔╝   ██║  ██║ ╚═╝ ██║
╚═╝  ╚═══╝    ╚═══╝    ╚═╝  ╚═╝     ╚═╝
  ]],
  footer = 'Kickstart.nvim  |  Eva-Dark',
  content_hooks = {
    starter.gen_hook.aligning('center', 'center'),
    starter.gen_hook.indexing(),
  },
}
