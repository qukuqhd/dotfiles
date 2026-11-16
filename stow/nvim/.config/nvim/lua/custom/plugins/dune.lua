-- Dune build/test commands for the current OCaml project.
local function project_root()
  return vim.fs.root(0, { 'dune-project', 'dune-workspace', '*.opam', '.git' }) or vim.fn.getcwd()
end

local function run_dune(args)
  vim.cmd 'botright split'
  vim.cmd 'resize 12'
  local buffer = vim.api.nvim_get_current_buf()
  vim.fn.termopen(vim.list_extend({ 'dune' }, args), { cwd = project_root() })
  vim.api.nvim_buf_set_name(buffer, 'dune://' .. table.concat(args, '-'))
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('DuneBuild', function() run_dune { 'build' } end, { desc = 'Run dune build' })
vim.api.nvim_create_user_command('DuneTest', function() run_dune { 'runtest' } end, { desc = 'Run dune runtest' })
vim.api.nvim_create_user_command('DuneClean', function() run_dune { 'clean' } end, { desc = 'Run dune clean' })

vim.keymap.set('n', '<leader>db', '<cmd>DuneBuild<cr>', { desc = '[D]une [B]uild' })
vim.keymap.set('n', '<leader>dt', '<cmd>DuneTest<cr>', { desc = '[D]une [T]est' })
vim.keymap.set('n', '<leader>dc', '<cmd>DuneClean<cr>', { desc = '[D]une [C]lean' })
