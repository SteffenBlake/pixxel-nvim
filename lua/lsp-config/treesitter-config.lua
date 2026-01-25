local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    })

    ctx.treesitter_languages = {}
end

function M.run(ctx)
    local treeSitter = require('nvim-treesitter');
    treeSitter.install(ctx.treesitter_languages);

    -- Tweaks to make markdown play nice
    vim.api.nvim_set_hl(0, 'mkdBold', { bold = true })
    vim.api.nvim_set_hl(0, 'mkdItalic', { italic = true })
    vim.api.nvim_set_hl(0, 'markdownBold', { bold = true })
    vim.api.nvim_set_hl(0, '@markup.italic.markdown_inline', { italic = true })
end

return M
