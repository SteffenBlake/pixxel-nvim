local lspconfig = require('lspconfig')
-- local hoverHints = require('hoverhints')
local llm = require('llm')

local utils = require("utils")

vim.cmd('autocmd BufRead,BufNewFile *.hbs set filetype=html')

require('lsp-config.cmp-config')
require('lsp-config.comment-config')
require('lsp-config.treesitter-config')

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc, mode) utils.nmap(keys, func, "LSP: " .. desc, mode, bufnr) end

    nmap('<c-r><c-r>', vim.lsp.buf.rename, '<c-r><c-r> Rename')
    nmap('<a-cr>', function() vim.cmd("CodeActionMenu") end, '[a-cr] Code Action', { 'n', 'v' })

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('<F12>', require('telescope.builtin').lsp_references, '[F12]ind References')
    nmap('<C-F12>', require('telescope.builtin').lsp_implementations, '[C-F12]ind Implementations')
    nmap('D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Do[K]umentation')
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Do[<c-K>]umentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    nmap('<C-K><C-F>', function() vim.cmd("Format") end, '[C-K C-F] Format Document', { 'n', 'v' })

    --- Guard against servers without the signatureHelper capability
    if client.server_capabilities.signatureHelpProvider then

        nmap("<c-s>", ":LspOverloadsSignature<CR>", "Show [C-S]ignatures", { 'n', 'i' })

        require('lsp-overloads').setup(client, {
            -- UI options are mostly the same as those passed to vim.lsp.util.open_floating_preview
            ui = {
                border = "single", -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
                height = nil,      -- Height of the signature popup window (nil allows dynamic sizing based on content of the help)
                width = nil,       -- Width of the signature popup window (nil allows dynamic sizing based on content of the help)
                wrap = true,       -- Wrap long lines
                wrap_at = nil,     -- Character to wrap at for computing height when wrap enabled
                max_width = nil,   -- Maximum signature popup width
                max_height = nil,  -- Maximum signature popup height
                -- Events that will close the signature popup window: use {"CursorMoved", "CursorMovedI", "InsertCharPre"} to hide the window when typing
                close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
                focusable = true,                       -- Make the popup float focusable
                focus = false,                          -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
                offset_x = 0,                           -- Horizontal offset of the floating window relative to the cursor position
                offset_y = 0,                           -- Vertical offset of the floating window relative to the cursor position
                floating_window_above_cur_line = false, -- Attempt to float the popup above the cursor position
                -- (note, if the height of the float would be greater than the space left above the cursor, it will default
                -- to placing the float below the cursor. The max_height option allows for finer tuning of this)
                silent = true -- Prevents noisy notifications (make false to help debug why signature isn't working)
            },
            keymaps = {
                next_signature = "<C-j>",
                previous_signature = "<C-k>",
                next_parameter = "<C-l>",
                previous_parameter = "<C-h>",
                close_signature = "<A-s>"
            },
            display_automatically = true -- Uses trigger characters to automatically display the signature overloads when typing a method signature
        })
    end
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end,
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
}

lspconfig.html.setup {
    filetypes = { "html", "hbs", "handlebars" },
    on_attach = on_attach,
}

lspconfig.jsonls.setup{}

lspconfig.dartls.setup{}

-- lspconfig.omnisharp.setup {
--     cmd = { "omnisharp" },
--     enable_roslyn_analyzers = true,
--     -- analyze_open_documents_only = true,
--     organize_imports_on_format = true,
--     enable_import_completion = true,
-- }

-- lspconfig.csharp_ls.setup{}

require("roslyn").setup({
    dotnet_cmd = "dotnet",              -- this is the default
    roslyn_version = "4.8.0-3.23475.7", -- this is the default
    on_attach = on_attach,
    capabilities = capabilities
})

-- hoverHints.setup()

-- llm.setup({
--     model = "https://localhost:5000",
--     enable_suggestions_on_startup = false,
--     enable_suggestions_on_files = "*.cs",
--     tls_skip_verify_insecure = true,
--     context_window = 4096,
--     fim = {
--         enabled = true,
--         prefix = "<fim_prefix>",
--         middle = "</fim_suffix><fim_middle>",
--         suffix = "</fim_prefix><fim_suffix>",
--     },
--     tokens_to_clear = { "</fim_middle>" },
-- })

vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
   callback = function(ev)
       -- Enable completion triggered by <c-x><c-o>
       vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
   end,
})
