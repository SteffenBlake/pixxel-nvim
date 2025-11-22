local dap = require('dap')
local dapui = require("dapui")
local nvimTreeApi = require('nvim-tree.api')

dap.adapters.mono = function(callback, config)
    callback({
        type = 'server',
        command = 'mono-debug',
        port = 4711,
        args = { '--server' },
    })
end

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
    {
        type = "mono",
        name = "attach - vscode-mono-debug",
        address = "localhost",
        port = 10000,
        request = "attach",
    },
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

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
