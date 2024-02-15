local M = {}

function M.setup()
    -- See `:help telescope` and `:help telescope.setup()`
    local telescope = require('telescope')

    telescope.setup {
        defaults = {
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    width = 0.95,
                    height = 0.95,
                    preview_cutoff = 1,
                    promp_position = "top"
                },
                horizontal = {
                    width = 0.95,
                    height = 0.95,
                    preview_cutoff = 1,
                    promp_position = "top",
                }
            },
            mappings = {
                i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                    -- even more opts
                }
            }
        }
    }

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, 'fzf')

    telescope.load_extension("ui-select")
end

return M
