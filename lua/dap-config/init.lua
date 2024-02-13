local projLoader = require('dap-config.proj-loader')
local dap = require('dap')
local dapui = require("dapui")
local nvimTreeApi = require('nvim-tree.api')
local utils = require('utils')

-- dap.defaults.fallback.external_terminal = {
--     command = 'tmux';
--     args = {'new-window', '-c', '"#{pane_current_path}"'};
-- }

-- dap.defaults.fallback.force_external_terminal = true

dap.adapters.cs = {
    type = 'executable',
    command = 'netcoredbg',
    args = { '--interpreter=vscode' },
}
dap.configurations.cs = {
  {
    type = "cs",
    name = "attach - netcoredbg",
    request = "attach",
    processId = require('dap.utils').pick_process,
  },
}

dap.adapters.dart = {
  type = 'executable',
  command = 'flutter',
  args = {'debug_adapter'}
}
dap.adapters.flutter = {
  type = 'executable',
  command = 'flutter',
  args = {'debug_adapter'}
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

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "\\[dap-repl\\]",
    callback = vim.schedule_wrap(function(args)
      vim.api.nvim_set_current_win(vim.fn.bufwinid(args.buf))
    end)
})

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
