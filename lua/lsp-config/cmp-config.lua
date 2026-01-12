local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy, {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'onsails/lspkind.nvim',
        },
    })
end

function M.run(ctx)
    local cmp = require('cmp')
    cmp.setup {
        completion = {
            completeopt = 'menu,noselect,noinsert'
        },
        mapping = cmp.mapping.preset.insert {
            ['<C-j>'] = cmp.mapping.select_next_item(),
            ['<C-k>'] = cmp.mapping.select_prev_item(),
            ['<C-h>'] = cmp.mapping.scroll_docs(-4),
            ['<C-l>'] = cmp.mapping.scroll_docs(4),
            ["<CR>"] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end,
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            })
        },
        sources = {
            { name = 'nvim_lsp' },
        },
        window = {
            completion = {
                col_offset = -3,
                side_padding = 0,
            },
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({
                    mode = "symbol_text", maxwidth = 50 
                })(entry, vim_item)

                local strings = vim.split(kind.kind, "%s", { trimempty = true })

                kind.kind = " " .. (strings[1] or "") .. " "
                kind.menu = "    (" .. (strings[2] or "") .. ")"
                return kind
            end,
        },
    }
end

return M
