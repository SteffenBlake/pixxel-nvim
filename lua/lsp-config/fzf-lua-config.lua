local M = {}

function M.setup()
    require("fzf-lua").setup({
        "telescope"
    })
end

return M
