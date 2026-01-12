local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, 'terrortylor/nvim-comment')
end

function M.run(ctx)
    require('nvim_comment').setup({
        line_mapping = '<C-_><C-_>',
        operator_mapping = '<C-_>'
    })
end

return M
