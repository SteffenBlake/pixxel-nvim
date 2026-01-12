local M = {}

function M.setup(ctx)
    table.insert(ctx.treesitter_languages, 'rust')
end


function M.run(ctx)
    vim.lsp.enable('rust_analyzer')
end

return M
