local M = {}

function M.setup()
    local onedark = require('onedark')
    onedark.setup({
        style = 'cool'
    })
    onedark.load()
end

return M
