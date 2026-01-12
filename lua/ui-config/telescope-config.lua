local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'debugloop/telescope-undo.nvim',
                'nvim-telescope/telescope-ui-select.nvim',
                -- Fuzzy Finder Algorithm which requires local dependencies to be built.
                -- Only load if `make` is available. Make sure you have the system
                -- requirements installed.
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    -- NOTE: If you are having trouble with this installation,
                    --       refer to the README for telescope-fzf-native for more instructions.
                    build = 'make',
                    cond = function()
                        return vim.fn.executable 'make' == 1
                    end,
                },
            },
        })
end

function M.run(_)
    local telescope = require('telescope')
    local tele_builtin = require('telescope.builtin')

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
            },
            undo = {

            }
        }
    }

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, 'fzf')

    telescope.load_extension("ui-select")
    telescope.load_extension("undo")

    local wk = require('which-key')
    wk.add({
        { "<leader>fg", tele_builtin.git_files,                 desc = "Search [g]it files" },
        { "<leader>fh", tele_builtin.oldfiles,                  desc = "Search file [h]istory" },
        { "<leader>fr", tele_builtin.live_grep,                 desc = "Search files by g[r]ep" },
        { "<leader>fb", tele_builtin.buffers,                   desc = "Search current [b]uffers" },

        { "<leader>sr", tele_builtin.lsp_references,            desc = "[r]eferences" },
        { "<leader>sd", tele_builtin.lsp_definitions,           desc = "[d]efinitions" },
        { "<leader>si", tele_builtin.lsp_implementations,       desc = "[i]mplementations" },
        { "<leader>ss", tele_builtin.lsp_document_symbols,      desc = "[s]ymbols" },
        { "<leader>sf", tele_builtin.current_buffer_fuzzy_find, desc = "[f]ind" },
        { "<leader>sw", tele_builtin.diagnostics,               desc = "Diagnostic [w]arnings" },

        { "<leader>ru", telescope.extensions.undo.undo,         desc = "[U]ndo History",          mode = { "n", "v" } },

        { "<leader>gs", tele_builtin.git_branches,              desc = "[s]witch branches" },
    })

    -- Ensure that fzf register as default AFTER all telescope stuff is setup
    local fzfLua = require("fzf-lua")
    fzfLua.register_ui_select()
end

return M
