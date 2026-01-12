local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
    {
        'lewis6991/gitsigns.nvim',
    })
end

function M.run(_)
    require('gitsigns').setup(
        {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        })
end

return M
