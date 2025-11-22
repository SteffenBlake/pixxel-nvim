local job_indicator = { require("easy-dotnet.ui-modules.jobs").lualine }

local M = {}

local function getWords()
    return tostring(vim.fn.wordcount().words)
end

function M.setup()
    require('lualine').setup({
        options = {
            theme = 'onedark',
            component_separators = { left = '|', right = '|' },
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = { 'mode', job_indicator },
            lualine_b = { 'branch', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { getWords },
            lualine_z = { 'location' }
        },
    })
end

return M
