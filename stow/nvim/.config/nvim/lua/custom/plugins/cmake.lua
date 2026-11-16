-- cmake-tools.nvim: C++ / CMake 构建工作流（configure / build / run / test）
-- https://github.com/Civitasv/cmake-tools.nvim
vim.pack.add { 'https://github.com/Civitasv/cmake-tools.nvim' }

require('cmake-tools').setup {
  -- 生成 / 编译等过程输出到 quickfix 列表
  cmake_executor = { name = 'quickfix', opts = {} },
  -- 运行程序用 Neovim 内置终端（本机未装 toggleterm，避免额外依赖）
  cmake_runner = { name = 'terminal', opts = {} },
}

-- <leader>c 系列快捷键
vim.keymap.set('n', '<leader>cb', '<Cmd>CMakeBuild<CR>', { desc = 'CMake: build' })
vim.keymap.set('n', '<leader>cr', '<Cmd>CMakeRun<CR>', { desc = 'CMake: run target' })
vim.keymap.set('n', '<leader>ct', '<Cmd>CMakeTest<CR>', { desc = 'CMake: test' })
vim.keymap.set('n', '<leader>cs', '<Cmd>CMakeSelectTarget<CR>', { desc = 'CMake: select target' })
vim.keymap.set('n', '<leader>ck', '<Cmd>CMakeSelectKit<CR>', { desc = 'CMake: select kit' })
vim.keymap.set('n', '<leader>cT', '<Cmd>CMakeSelectBuildType<CR>', { desc = 'CMake: select build type' })
