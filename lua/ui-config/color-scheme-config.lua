local M = {}

function M.setup()
    local onedark = require('onedark');
    onedark.load()

    -- NOTE : Normal Mode -> warm
    vim.api.nvim_create_autocmd('ModeChanged', {
        callback = function(_)
            onedark.set_options('style', 'warm')
            onedark.load()
        end,
        pattern = '*:n',
    })

    -- NOTE : Insert Mode -> cool
    vim.api.nvim_create_autocmd('ModeChanged', {
        callback = function(_)
            onedark.set_options('style', 'cool')
            onedark.load()
        end,
        pattern = '*:i',
    })

    -- NOTE : Command Mode -> darker
    vim.api.nvim_create_autocmd('ModeChanged', {
        callback = function(_)
            onedark.set_options('style', 'darker')
            onedark.load()
        end,
        pattern = '*:c',
    })
    -- NOTE : Visual Mode -> warmer
    vim.api.nvim_create_autocmd('ModeChanged', {
        callback = function(_)
            onedark.set_options('style', 'warmer')
            onedark.load()
        end,
        pattern = '*:v',
    })
    -- NOTE : Replace Mode -> deep
    vim.api.nvim_create_autocmd('ModeChanged', {
        callback = function(_)
            onedark.set_options('style', 'deep')
            onedark.load()
        end,
        pattern = '*:r',
    })
end

return M
