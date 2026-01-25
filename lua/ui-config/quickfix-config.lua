local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        'kevinhwang91/nvim-bqf',
        {
            'stevearc/quicker.nvim',
            ft = "qf",
            opts = {},
        }
    })
end

function M.run(_)
    require("quicker").setup()
    require('bqf').setup()
end

return M
