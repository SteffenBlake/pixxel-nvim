local M = {}

function M.setup()
    -- https://github.com/andythigpen/nvim-coverage?tab=readme-ov-file#configuration
    require("coverage").setup({
        commands =  false
    })
end

return M
