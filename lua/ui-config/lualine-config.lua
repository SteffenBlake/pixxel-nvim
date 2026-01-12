local M = {}

local function getWords()
    return tostring(vim.fn.wordcount().words)
end

function M.setup(ctx)
    table.insert(ctx.lazy, {
        'nvim-lualine/lualine.nvim'
    })

    ctx.lualine_sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { getWords },
        lualine_z = { 'location' }
    }
end

function M.run(ctx)
    require('lualine').setup({
        options = {
            theme = 'onedark',
            component_separators = { left = '|', right = '|' },
            section_separators = { left = '', right = '' },
        },
        sections = ctx.lualine_sections,
    })
end

return M
