local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    })
end

function M.run(_)
    local fzfLua = require("fzf-lua")
    fzfLua.setup({
        "telescope",
    })

    vim.keymap.set(
        { "n", "v" }, "<leader>ra", fzfLua.lsp_code_actions, { silent = true, desc = "[a]ction menu" }
    )
end

return M
