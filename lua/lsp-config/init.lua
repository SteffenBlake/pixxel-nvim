local cmp = require('lsp-config.cmp-config')
local fzfLua = require('lsp-config.fzf-lua-config')
local lspOverloads = require('lsp-config.lsp-overloads-config')
local nvimAutopairs = require('lsp-config.nvim-autopairs-config')
local nvimComment = require('lsp-config.nvim-comment-config')
local treesitter = require('lsp-config.treesitter-config')

local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        'neovim/nvim-lspconfig',
    })

    cmp.setup(ctx)
    fzfLua.setup(ctx)
    lspOverloads.setup(ctx)
    nvimAutopairs.setup(ctx)
    nvimComment.setup(ctx)
    treesitter.setup(ctx)
end

function M.run(ctx)
    cmp.run(ctx)
    fzfLua.run(ctx)
    lspOverloads.run(ctx)
    nvimAutopairs.run(ctx)
    nvimComment.run(ctx)
    treesitter.run(ctx)

    local wk = require('which-key')
    wk.add({
        { "<leader>e",  vim.diagnostic.open_float, desc = "Open floating diagnostic message", mode = { "n" } },
        { "<leader>rf", vim.lsp.buf.format,        desc = "[f]ormat current buffer with LSP", mode = { "n", "v" } },
        { "<leader>rr", vim.lsp.buf.rename,        desc = "[r]ename" },
    })
end

return M
