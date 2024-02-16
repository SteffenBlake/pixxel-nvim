local M = {}

function M.setup()
    require('keys').setup(
        {
            enable_on_startup = true,
        }
    )
end

return M
