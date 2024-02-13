local M = {}

function M.setup()
    require('lualine').setup({
        options = {
            theme = 'onedark',
        },
    })
end

return M
