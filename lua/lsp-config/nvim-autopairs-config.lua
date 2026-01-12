local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
    })
end

function M.run(_)
    require("nvim-autopairs").setup {}
end

return M
