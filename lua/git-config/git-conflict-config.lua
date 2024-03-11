local M = {}

function M.setup()
    local gitConflict = require('git-conflict')

    gitConflict.setup({
        default_mappings = false,
        -- This will disable the diagnostics in a buffer whilst it is conflicted
        disable_diagnostics = false,
        -- command or function to open the conflicts list
        list_opener = 'copen',
        -- They must have background color, otherwise the default color will be used
        highlights = {
            incoming = 'DiffAdd',
            current = 'DiffText',
        }
    })
end

return M
