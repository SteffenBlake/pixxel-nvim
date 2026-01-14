local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            keys = {},
        })
end

function M.run(ctx)
    local wk = require("which-key")
    wk.add({
        { "<leader>c",  group = "[c]onsole" },

        { "<leader>f",  group = "[f]iles" },

        { "<leader>s",  group = "[s]earch" },

        { "<leader>r",  group = "[r]efactor" },

        { "<leader>g",  group = "[g]it" },

        { "<leader>d",  group = "[d]ebug" },

        { "<leader>t",  group = "[t]ests" },

        { "<leader>tb", group = "from [b]uffer" },

        { "<leader>p",  group = "[p]roject" },

        { "<leader>l",  group = "[l]lm stuff" },
    })
end

return M
