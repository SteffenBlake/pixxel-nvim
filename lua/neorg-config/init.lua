require('neorg').setup {
    load = {
        ["core.defaults"] = {
            config = {
            }
        },
        ["core.keybinds"] = {
            config = {
                hook = function(keybinds)
                    keybinds.remap_key("norg", "n", "<C-Space>", "<Leader>t")
                end
            }
        },
        ["core.journal"] = {
            config = {
                workspace = "journal"
            }
        },
        ["core.completion"] = {
            config = {
                engine = 'nvim-cmp'
            }
        },
        ["core.concealer"] = {
            config = {
            }
        },
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/Documents/notes",
                    journal = "~/Documents/journal"
                },
                default_workspace = 'notes',
                index = "index.norg"
            }
        },
        ["core.export"] = {
            config = {
            }
        },
        ["core.export.markdown"] = {
            config = {
            }
        },
        ["core.ui.calendar"] = {
            config = {
            }
        },
    }
}
