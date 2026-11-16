-- swank.nvim 本地补丁：libuv 回调（fast event context）里不能直接调 vim.notify，
-- 否则会报 E5560。这里做最小化字符串替换；插件安装/更新后由 PackChanged 钩子重新应用。
local M = {}

local PLUGIN_DIR = vim.fn.stdpath('data') .. '/site/pack/core/opt/swank.nvim'

local patches = {
  {
    file = 'lua/swank/transport.lua',
    old = [==[  handle:connect(host, port, function(err)
    if err then
      handle:close()
      on_connect(err)
      return
    end
    self.handle = handle
    on_connect(nil)
    handle:read_start(function(read_err, data)
      vim.schedule(function()
        if read_err or not data then
          self:_on_close()
          return
        end
        self:_feed(data)
      end)
    end)
  end)
]==],
    new = [==[  handle:connect(host, port, function(err)
    vim.schedule(function()
      if err then
        handle:close()
        on_connect(err)
        return
      end
      self.handle = handle
      on_connect(nil)
      handle:read_start(function(read_err, data)
        vim.schedule(function()
          if read_err or not data then
            self:_on_close()
            return
          end
          self:_feed(data)
        end)
      end)
    end)
  end)
]==],
  },
  {
    file = 'lua/swank/client.lua',
    old = [==[      on_exit = function(_, code)
        impl_job_id = nil
        if connection_state ~= "connected" then
          connection_state = "disconnected"
          local tail = table.concat(stderr_log, "\n")
          vim.notify(
            "swank.nvim: " .. impl .. " exited (code " .. code .. ")\n" .. tail,
            vim.log.levels.ERROR
          )
        end
        stderr_log = {}
      end,]==],
    new = [==[      on_exit = function(_, code)
        impl_job_id = nil
        if connection_state ~= "connected" then
          connection_state = "disconnected"
          local tail = table.concat(stderr_log, "\n")
          vim.schedule(function()
            vim.notify(
              "swank.nvim: " .. impl .. " exited (code " .. code .. ")\n" .. tail,
              vim.log.levels.ERROR
            )
          end)
        end
        stderr_log = {}
      end,]==],
  },
}

function M.apply()
  for _, p in ipairs(patches) do
    local path = PLUGIN_DIR .. '/' .. p.file
    local f = io.open(path, 'r')
    if not f then
      return
    end
    local content = f:read('*a')
    f:close()
    local patched, count = content:gsub(p.old, p.new, 1)
    if count > 0 then
      local out = io.open(path, 'w')
      if out then
        out:write(patched)
        out:close()
      end
    end
  end
end

return M
