local projLoader = require('dap-config.proj-loader')
local dap = require('dap')
local dapui = require("dapui")
local nvimTreeApi = require('nvim-tree.api')

-- dap.defaults.fallback.external_terminal = {
--     command = 'tmux';
--     args = {'new-window', '-c', '"#{pane_current_path}"'};
-- }

-- dap.defaults.fallback.force_external_terminal = true

dap.adapters.cs = function(callback, config)
    if (config.request ~= "launch") then
        callback({
            type = 'executable',
            command = 'netcoredbg',
            args = { '--interpreter=vscode' },
        })
        return
    end

    if (not(config.ssh)) then
        callback({
            type = 'executable',
            command = 'netcoredbg',
            args = { '--interpreter=vscode' },
        })
        return
    end

    -- Compose SSH info
    local sshTarget = config.ssh.user .. '@' .. config.ssh.domain

    local targetDir =
        "C:/Users/" .. config.ssh.user ..
        "/AppData/Local/Temp/" .. config.program:gsub("%.", "-") .. "/"

    print("targetDir: " .. targetDir)

    local targetDll = targetDir .. config.program
    local scpTargetDir = sshTarget .. ":" .. targetDir

    -- Copy the files over to the target dir
    vim.system({ 'scp', '-r', config.cwd, scpTargetDir }):wait()

    -- Invoke the adapter
    callback({
        type = 'executable',
        command = 'ssh',
        args = {
            sshTarget,
            'netcoredbg.exe --interpreter=vscode'
        },
        -- Override the program value to be the target machine location
        enrich_config = function(oldConfig, configCallback)
            oldConfig.program = targetDll
            configCallback(oldConfig)
        end
    })
end

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
    args = { 'debug_adapter' }
}
dap.adapters.flutter = {
    type = 'executable',
    command = 'flutter',
    args = { 'debug_adapter' }
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
    cmd = function(projPath) return { "dotnet", "build", "-c", "Debug", projPath } end,
    verbose = false
}

projLoader.setup(projLoaderOpts)

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
