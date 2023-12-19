local lspconfig = require('lspconfig')
local hoverHints = require('hoverhints')

local utils = require("utils")

vim.cmd('autocmd BufRead,BufNewFile *.hbs set filetype=html')

require('lsp-config.cmp-config')
require('lsp-config.comment-config')
require('lsp-config.treesitter-config')

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
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

lspconfig.tsserver.setup {}

lspconfig.html.setup {
    filetypes = { "html", "hbs", "handlebars" }
}

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

hoverHints.setup()

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        on_attach(nil, ev.buf)
    end,
})
