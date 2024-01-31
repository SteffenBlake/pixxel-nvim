local M = {}

function M.setup()
    require('nvim_comment').setup({
        line_mapping = '<C-_><C-_>',
        operator_mapping = '<C-_>'
    })
end

return M
