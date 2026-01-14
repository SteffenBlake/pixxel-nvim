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
    local chat = require("CopilotChat")
    local fzfLua = require("fzf-lua")


    -- Function to pick and add files to Copilot chat
    local function pick_files_for_chat()
        fzfLua.files({
            prompt = "Add files to Copilot Chat> ",
            cwd = vim.fn.getcwd(),
            multiprocess = true,
            actions = {
                ["default"] = function(selected, opts)
                    if (#selected > 0) then
                        chat.open()
                        chat.chat:append("\n")
                    end
                    for _, entry in ipairs(selected) do
                        -- Use relative path from CWD
                        local file = fzfLua.path.entry_to_file(entry, opts).path
                        local relative_path = vim.fn.fnamemodify(file, ":.")
                        chat.chat:append("#file:" .. relative_path .. "\n")
                    end
                end
            }
        })
    end

    local wk = require('which-key')
    wk.add({
        { "<leader>lt", ":CopilotChatToggle<CR>", desc = "[t]oggle Copilot chat", mode = { 'n' } },
        { "<leader>ls", ":CopilotChatStop<CR>", desc = "[s]top Copilot chat output", mode = { 'n' } },
        { "<leader>lp", ":CopilotChatPrompts<CR>", desc = "View [p]romt templates", mode = { 'n', 'v' } },
        { "<leader>le", ":CopilotChatExplain<CR>", desc = "[e]xplain current selection", mode = { 'n', 'v' } },
        { "<leader>lr", ":CopilotChatReview<CR>", desc = "[r]eview current selection", mode = { 'n', 'v' } },
        { "<leader>lf", pick_files_for_chat, desc = "Pick [f]iles for chat context", mode = { 'n' } },
        { "<leader>lx", ":CopilotChatFix<CR>", desc = "Fi[x] current selection", mode = { 'n', 'v' } },
        { "<leader>lo", ":CopilotChatOptimize<CR>", desc = "[o]ptimize current selection", mode = { 'n', 'v' } },
        { "<leader>ld", ":CopilotChatDocs<CR>", desc = "[d]ocument current selection", mode = { 'n', 'v' } },
    })
end


return M
