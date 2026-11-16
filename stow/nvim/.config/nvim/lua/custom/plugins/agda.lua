-- Agda support via Cornelis (agda-mode for Neovim)
-- https://github.com/agda/cornelis

-- Use the compiled cornelis binary instead of letting nvim-hs rebuild it.
vim.g.cornelis_use_global_binary = 1

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

-- Cornelis is built with cabal/GHC from ghcup. The hook must be registered
-- before vim.pack.add so it fires for installs in the current session.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == 'cornelis' and (kind == 'install' or kind == 'update') then
      if vim.env.CORNELIS_SKIP_BUILD == '1' then return end
      run_build(name, {
        'bash',
        '-lc',
        'export PATH="$HOME/.ghcup/bin:$PATH" && '
          .. 'patch_dir="$HOME/.config/nvim/lua/custom/plugins/cornelis-patch" && '
          .. 'cp "$patch_dir/Compat.hs" src/Cornelis/Vim/Compat.hs && '
          .. 'cp "$patch_dir/InfoWin.hs" src/Cornelis/InfoWin.hs && '
          .. 'cp "$patch_dir/Highlighting.hs" src/Cornelis/Highlighting.hs && '
          .. 'cabal install --installdir="$HOME/.local/bin" --overwrite-policy=always',
      }, ev.data.path)
    end
  end,
})

vim.pack.add {
  { src = 'https://github.com/agda/cornelis', version = 'nvim-0.12-compat' },
  'https://github.com/neovimhaskell/nvim-hs.vim',
  'https://github.com/kana/vim-textobj-user',
}

-- Basic keybindings. The :Cornelis* commands are registered by the cornelis
-- Haskell side when an .agda file is opened.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'agda',
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set('n', '<leader>l', ':CornelisLoad<CR>', opts)
    vim.keymap.set('n', '<leader>,', ':CornelisTypeContext<CR>', opts)
    vim.keymap.set('n', '<leader>r', ':CornelisRefine<CR>', opts)
    vim.keymap.set('n', '<leader>d', ':CornelisMakeCase<CR>', opts)
    vim.keymap.set('n', 'gd', ':CornelisGoToDefinition<CR>', opts)
  end,
})
