local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
    {
        'akinsho/git-conflict.nvim',
    })
end

function M.run(_)
    local gitConflict = require('git-conflict')

    gitConflict.setup({
        default_mappings = false,
        -- This will disable the diagnostics in a buffer whilst it is conflicted
        disable_diagnostics = false,
        -- command or function to open the conflicts list
        list_opener = 'copen',
        -- They must have background color, otherwise the default color will be used
        highlights = {
            incoming = 'DiffAdd',
            current = 'DiffText',
        }
    })

    local wk = require('which-key')
    wk.add({
        { "<leader>gc", "<cmd>GitConflictListQf<cr>", desc = "List [c]onflicts" },
        { "<leader>gn", "<cmd>GitConflictChooseNone<cr>", desc = "Choose [n]one" },
        { "<leader>gy", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose [y]ours" },
        { "<leader>gt", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose [t]heirs" },
        { "<leader>gb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose [b]oth" },
        { "<leader>gh", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev conflict" },
        { "<leader>gl", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
    })
end

return M
