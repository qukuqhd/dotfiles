-- Haskell: a small GHCi REPL without extra plugins.
--
-- `:Ghci` saves the current buffer, opens GHCi in a terminal split and
-- loads/compiles the file. `:GhciLoad` reloads it in the running REPL.
-- Unsaved edits have to be written before GHCi can load them.

local ghci_buf = nil

local function ghci_exe()
  local exe = vim.fn.exepath 'ghci'
  if exe ~= '' then
    return exe
  end
  local candidate = vim.fn.expand '~/.ghcup/bin/ghci'
  if vim.fn.executable(candidate) == 1 then
    return candidate
  end
  return nil
end

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    return nil
  end
  return vim.fn.fnamemodify(file, ':p')
end

local function repl_alive(buf)
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    return false
  end
  local job = vim.b[buf].terminal_job_id
  return job ~= nil and vim.fn.jobpid(job) > 0
end

local function load_current()
  local exe = ghci_exe()
  local file = current_file()
  if vim.bo.filetype ~= 'haskell' then
    return vim.notify('Ghci: not a Haskell buffer', vim.log.levels.WARN)
  end
  if not exe then
    return vim.notify('ghci not found (is ghcup on PATH?)', vim.log.levels.ERROR)
  end
  if not file then
    return vim.notify('current buffer has no file to load', vim.log.levels.WARN)
  end
  if vim.bo.modified then
    vim.cmd 'silent write'
  end

  if repl_alive(ghci_buf) then
    local win = vim.fn.bufwinid(ghci_buf)
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
    else
      vim.cmd 'botright 15new'
      vim.api.nvim_win_set_buf(0, ghci_buf)
    end
    vim.fn.chansend(vim.b[ghci_buf].terminal_job_id, ':load "' .. file .. '"\r')
    vim.cmd 'startinsert'
    return
  end

  vim.cmd 'botright 15new'
  vim.fn.termopen({ exe, file }, { cwd = vim.fs.dirname(file) })
  ghci_buf = vim.api.nvim_get_current_buf()
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('Ghci', load_current, {
  desc = 'Open GHCi and load the current buffer',
})
vim.api.nvim_create_user_command('GhciLoad', load_current, {
  desc = 'Reload the current buffer in GHCi',
})
