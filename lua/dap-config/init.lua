local dotnetLoader = require('dap-config.dotnet-loader')
local dap = require('dap')
local dapui = require("dapui")
local nvimTreeApi = require('nvim-tree.api')
local utils = require('utils')

dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = {'--interpreter=vscode'}
}

local csDapConfig = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.g['dotnet_dll']
    end,
  },
}

dap.configurations.cs = csDapConfig
dap.configurations.fsharp = csDapConfig

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
  nvimTreeApi.tree.close()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
  nvimTreeApi.tree.open()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
  nvimTreeApi.tree.open()
end

utils.nmap('<F9>', dap.toggle_breakpoint, '[<F9>] Toggle Breakpoint')

function DotnetBuildAndRun()
   dotnetLoader.getPath(dap.continue)
end

-- .cs .cshtml
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cs',
    callback = function ()
        utils.nmap('<F5>', DotnetBuildAndRun, '[<F5>] Debug')
    end,
})

require('dap-config.neotest-config')
