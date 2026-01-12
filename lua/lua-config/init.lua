local M = {}

function M.setup(ctx)
    table.insert(ctx.treesitter_languages, 'lua')
end

function M.run(_)
    vim.lsp.enable('lua_ls')
end

return M
