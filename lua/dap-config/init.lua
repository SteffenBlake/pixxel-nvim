local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio"
        }
    })
end

function M.run(ctx)
    local dap = require('dap')
    local dapui = require("dapui")
    local nvimTreeApi = require('nvim-tree.api')

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
   
    vim.diagnostic.config({
        signs = {
            DapBreakpoint = { text = '🔴', texthl = '', linehl = '', numhl = '' }
        }
    })
    
    local wk = require('which-key')
    wk.add({
        { "<leader>dr", dap.continue, desc = "Build and [r]un" },
        { "<leader>db", dap.toggle_breakpoint, desc = "Toggle [b]reakpoint" },
        { "<leader>dl", dap.list_breakpoints, desc = "[l]ist Breakpoints" },
        { "<leader>dc", dap.clear_breakpoints, desc = "[c]lear breakpoints" },
        { "<leader>dt", dapui.toggle, desc = "[t]oggle DAP UI" },
    })

end

return M
