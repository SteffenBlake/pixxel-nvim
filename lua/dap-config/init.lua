local projLoader = require('dap-config.proj-loader')
local dap = require('dap')
local dapui = require("dapui")
local nvimTreeApi = require('nvim-tree.api')
local utils = require('utils')

dap.adapters.cs = {
    type = 'executable',
    command = 'netcoredbg',
    args = { '--interpreter=vscode' },
    -- enrich_config = function (old_config, on_config)
    --     projLoader.use_program_as_cwd(old_config, on_config)
    -- end
}

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

require("nvim-dap-virtual-text").setup()

local projLoaderOpts = {
    builders = {},
    setCwd = true
}

projLoaderOpts.builders["*.csproj"] =
{
    cmd = function(projPath) return {"dotnet", "build", "-c", "Debug", projPath} end,
    verbose = false
}

projLoader.setup(projLoaderOpts)

vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
utils.nmap('<F9>', dap.toggle_breakpoint, '[<F9>] Toggle Breakpoint')
utils.nmap('<F5>', projLoader.build_and_run, '[<F5>] Debug')

require('dap-config.neotest-config')
