local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    })

    ctx.treesitter_languages = {}
end

function M.run(ctx)
    local treeSitterConfigs = require('nvim-treesitter.configs')

    vim.defer_fn(function()
        treeSitterConfigs.setup {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = ctx.treesitter_languages,

            -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
            auto_install = true,

            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<M-space>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>a'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>A'] = '@parameter.inner',
                    },
                },
            },
        }

        -- Tweaks to make markdown play nice
        vim.api.nvim_set_hl(0, 'mkdBold', { bold = true })
        vim.api.nvim_set_hl(0, 'mkdItalic', { italic = true })
        vim.api.nvim_set_hl(0, 'markdownBold', { bold = true })
        vim.api.nvim_set_hl(0, '@markup.italic.markdown_inline', { italic = true })
    end, 0)
end

return M
