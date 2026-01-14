local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
            opts = {
                model = 'claude-sonnet-4.5',
                temperature = 0.1,
                window = {
                    layout = 'vertical',
                    width = 0.3,
                },
                auto_insert_mode = true,
            }
        })
end

function M.run(_)
    local wk = require('which-key')
    wk.add({
        { "<leader>lt", ":CopilotChatToggle<CR>", desc = "[t]oggle Copilot chat", mode = { 'n' } },
        { "<leader>ls", ":CopilotChatStop<CR>", desc = "[s]top Copilot chat output", mode = { 'n' } },
        { "<leader>lp", ":CopilotChatPrompts<CR>", desc = "View [p]romt templates", mode = { 'n', 'v' } },
        { "<leader>le", ":CopilotChatExplain<CR>", desc = "[e]xplain current selection", mode = { 'n', 'v' } },
        { "<leader>lr", ":CopilotChatReview<CR>", desc = "[r]eview current selection", mode = { 'n', 'v' } },
        { "<leader>lf", ":CopilotChatFix<CR>", desc = "[f]ix current selection", mode = { 'n', 'v' } },
        { "<leader>lo", ":CopilotChatOptimize<CR>", desc = "[o]ptimize current selection", mode = { 'n', 'v' } },
        { "<leader>ld", ":CopilotChatDocs<CR>", desc = "[d]ocument current selection", mode = { 'n', 'v' } },
    })
end

return M
