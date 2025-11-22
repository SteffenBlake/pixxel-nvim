local dotnet = require("easy-dotnet")

local M = {}

function M.setup()
    dotnet.setup({
        lsp = {
          enabled = false,
          roslynator_enabled = false
        },
        debugger = {
            auto_register_dap = false
        },
        test_runner = {
            viewmode = "float",
            mappings = {
                run_test_from_buffer = { lhs = "<leader><C-t>r", desc = "[R]un test from buffer" },
                peek_stack_trace_from_buffer = {},
                filter_failed_tests = { lhs = "<leader><C-t>f", desc = "[F]ilter failed tests" },
                debug_test = { lhs = "<leader><C-t>d", desc = "[D]ebug test" },
                go_to_file = { lhs = "<leader><C-t>g", desc = "[G]o to file" },
                run_all = { lhs = "<leader><C-t>a", desc = "Run [A]ll tests" },
                run = { lhs = "<leader><C-t>t", desc = "Run [T]est" },
                peek_stacktrace = { lhs = "<leader><C-t>p", desc = "[P]eek stacktrace of failed test" },
                expand = { lhs = "<leader><C-t>e", desc = "expand" },
                expand_node = { lhs = "<leader><C-t>E", desc = "expand node" },
                expand_all = { lhs = "<leader><C-t>-", desc = "expand all" },
                collapse_all = { lhs = "<leader><C-t>W", desc = "collapse all" },
                close = { lhs = "<leader><C-t>q", desc = "[Q]uit testrunner" },
                refresh_testrunner = { lhs = "<leader><C-t><C-r>", desc = "refresh testrunner" }
            },
        },

        auto_bootstrap_namespace = {
            type = "file_scoped"
        },
        notifications = {
            handler = false
        },
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
            vim.cmd("belowright 10split")
            vim.cmd("term " .. command)
        end,
    })
end

return M
