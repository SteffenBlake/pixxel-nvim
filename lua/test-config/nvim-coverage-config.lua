local M = {}

function M.setup()


    local coverage = require("coverage")
    -- https://github.com/andythigpen/nvim-coverage?tab=readme-ov-file#configuration
    coverage.setup({
        commands =  false,
        auto_reload = true,
        summary = {
            width_percentage = 0.95,
            height_percentage = 0.95
        }
    })

end

return M
