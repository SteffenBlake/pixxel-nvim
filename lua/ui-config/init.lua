local lualine = require('ui-config.lualine-config')
local nvimTree = require('ui-config.nvim-tree-config')
local scrollbar = require('ui-config.scrollbar-config')
local telescope = require('ui-config.telescope-config')
local theme = require('ui-config.theme-config')

local M = {}

function M.setup(ctx)
    lualine.setup(ctx)
    nvimTree.setup(ctx)
    scrollbar.setup(ctx)
    telescope.setup(ctx)
    theme.setup(ctx)

    table.insert(ctx.lazy, {
        -- Highlights usages of selected symbols
        'RRethy/vim-illuminate',
        -- Shows indent lines even on blank lines
        {
            'lukas-reineke/indent-blankline.nvim',
            main = 'ibl',
        },
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require('gitsigns').setup()
                require("scrollbar.handlers.gitsigns").setup()
            end
        },
        -- Highlights on TODO/NOTE/HACK/PERF/FIX comments
        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = {}
        },
    })
end

function M.run(ctx)
    lualine.run(ctx)
    nvimTree.run(ctx)
    scrollbar.run(ctx)
    telescope.run(ctx)
    theme.run(ctx)

    local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- [[ Highlight on yank ]]
    -- See `:help vim.highlight.on_yank()`
    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = '*',
    })
end

return M
