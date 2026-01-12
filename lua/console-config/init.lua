local M = {}

function M.setup(ctx)
end

local function normalize(str)
    return string.gsub(str, "\n", "")
end

local function send_to_term(cmd)
    -- Open a small bottom terminal
    vim.cmd("belowright 10split")
    vim.cmd("term")
    -- Get the current terminal buffer and send the command
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
end

local function send_lines()
    vim.cmd("normal! V")
    M.send_selected()
end

local function send_selected()
    if not (vim.fn.mode() == "v" or vim.fn.mode() == "V") then
        vim.notify(
            "Use this in visual mode",
            "warn",
            { title = "Terminal Sender" }
        )
        return
    end

    vim.cmd('normal! "ty')
    local cmd = vim.fn.getreg("t")

    send_to_term(cmd)
end

function M.run(ctx)
    local wk = require("which-key")
    wk.add({
        { 
            "<leader>co", 
            function() 
                vim.cmd("belowright 10split") 
                vim.cmd("term") 
            end, 
            desc = "[o]pen a console", 
            mode = "n" 
        },
        { 
            "<leader>ce", 
            send_lines,
            desc = "[e]xecute current line", mode = "n" 
        },
        { 
            "<leader>ce", 
            send_selected,
            desc = "[e]xecute selection", mode = "v" 
        }
    })
end

return M
