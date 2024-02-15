local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

require('ui-config.color-scheme-config').setup()
require('ui-config.hoverhints-config').setup()
require('ui-config.lualine-config').setup()
require('ui-config.new-file-template-config').setup()
require('ui-config.nvim-tree-config').setup()
require('ui-config.scrollbar-config').setup()
