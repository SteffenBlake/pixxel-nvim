local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
        {
            "GustavEikaas/easy-dotnet.nvim",
            dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
            config = nil
        })

    table.insert(ctx.treesitter_languages, 'c_sharp')
end

function M.run(_)
    local dotnet = require('easy-dotnet')
    dotnet.setup({
        lsp = {
            enabled = false,          -- Enable builtin roslyn lsp
            roslynator_enabled = false, -- Automatically enable roslynator analyzer
        },
        debugger = {
            -- The path to netcoredbg executable
            bin_path = "netcoredbg",
            auto_register_dap = true,
            mappings = {
                open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
            },
        },
        test_runner = {
            ---@type "split" | "vsplit" | "float" | "buf"
            viewmode = "float",
            ---@type number|nil
            vsplit_width = nil,
            ---@type string|nil "topleft" | "topright"
            vsplit_pos = nil,
            enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
            noBuild = true,
            icons = {
                passed = "",
                skipped = "",
                failed = "",
                success = "",
                reload = "",
                test = "",
                sln = "󰘐",
                project = "󰘐",
                dir = "",
                package = "",
            },
            mappings = {
                run_test_from_buffer = { lhs = "<leader>tbr", desc = "[r]un test from buffer" },
                peek_stack_trace_from_buffer = { lhs = "<leader>tbp", desc = "[p]eek stack trace from buffer" },
                filter_failed_tests = { lhs = "<leader>tf", desc = "[f]ilter failed tests" },
                debug_test = { lhs = "<leader>td", desc = "[d]ebug test" },
                go_to_file = { lhs = "<leader>tg", desc = "[g]o to file" },
                run_all = { lhs = "<leader>tR", desc = "[R]un all tests" },
                run = { lhs = "<leader>tr", desc = "[r]un test" },
                peek_stacktrace = { lhs = "<leader>tp", desc = "[p]eek stacktrace of failed test" },
                expand = { lhs = "-", desc = "expand" },
                expand_node = { lhs = "_", desc = "expand node" },
                expand_all = { lhs = "~", desc = "expand all" },
                collapse_all = { lhs = "W", desc = "collapse all" },
                close = { lhs = "q", desc = "close testrunner" },
                refresh_testrunner = { lhs = "<C-r>", desc = "[󰘴r]efresh testrunner" }
            },
            --- Optional table of extra args e.g "--blame crash"
            additional_args = {}
        },
        ---@param action "test" | "restore" | "build" | "run"
        terminal = function(path, action, args)
            args = args or ""
            local commands = {
                run = function() return string.format("dotnet run --project %s %s", path, args) end,
                test = function() return string.format("dotnet test %s %s", path, args) end,
                restore = function() return string.format("dotnet restore %s %s", path, args) end,
                build = function() return string.format("dotnet build %s %s", path, args) end,
                watch = function() return string.format("dotnet watch --project %s %s", path, args) end,
            }
            local command = commands[action]()
            if require("easy-dotnet.extensions").isWindows() == true then command = command .. "\r" end
            vim.cmd("vsplit")
            vim.cmd("term " .. command)
        end,
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
            --block_scoped, file_scoped
            type = "file_scoped",
            enabled = true,
            use_clipboard_json = {
                behavior = "prompt", --'auto' | 'prompt' | 'never',
                register = "+",    -- which register to check
            },
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        -- telescope -> fzf -> snacks ->  basic
        picker = "telescope",
        background_scanning = false,
        notifications = {
            handler = false
        },
        diagnostics = {
            default_severity = "error",
            setqflist = false,
        },
    })

    vim.lsp.enable('roslyn_ls')

    local dap = require('dap')

    dap.adapters.cs = function(callback, _)
        callback({
            type = 'executable',
            command = 'netcoredbg',
            args = { '--interpreter=vscode' },
        })
    end

    dap.configurations.cs = {
        {
            type = "cs",
            name = "attach - netcoredbg",
            request = "attach",
            processId = require('dap.utils').pick_process,
        }
    }

    if vim.env.NIX_ENABLE_ANDROID ~= nil then
        dap.adapters.mono = function(callback, _)
            callback({
                type = 'server',
                command = 'vscode-mono-debug-server',
                port = 4711,
                args = { '--server' },
            })
        end

        table.insert(dap.configurations.cs, {
            type = "mono",
            name = "attach - vscode-mono-debug-server (port: 10000)",
            address = "localhost",
            port = 10000,
            request = "attach",
        })
    end

    local wk = require('which-key')
    wk.add({
        {
            "<leader>pn",
            function()
                dotnet.create_new_item(vim.fn.expand("%:p:h"))
            end,
            desc = "Add a [n]ew item from template"
        },
        { "<leader>pp", dotnet.run_profile,  desc = "Run a specific [p]rofile" },
        { "<leader>pr", dotnet.run_default,  desc = "[r]un default profile" },
        { "<leader>pb", dotnet.build,        desc = "[b]uild" },
        { "<leader>pv", dotnet.project_view, desc = "Project [v]iew" },
        { "<leader>ps", dotnet.secrets,      desc = "Project [s]ecrets" },

        { "<leader>tr", dotnet.testrunner,   desc = "Dotnet Test [r]unner" },
    })
end

return M
