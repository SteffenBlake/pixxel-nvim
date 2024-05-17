local lspconfig = require('lspconfig')

local utils = require("utils")

require('lsp-config.autopairs-config').setup()
require('lsp-config.comment-config').setup()
require('lsp-config.cmp-config').setup()
-- require('lsp-config.llm-config').setup()
require('lsp-config.treesitter-config').setup()

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc, mode) utils.nmap(keys, func, "LSP: " .. desc, mode, bufnr) end


    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Do[K]umentation')
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Do[<c-K>]umentation')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

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

lspconfig.jsonls.setup {}

lspconfig.dartls.setup {}

local xsdTemplates = os.getenv('HOME') .. "/.local/share/nvim/xsd-templates/"
require'lspconfig'.lemminx.setup {
    settings = {
        xml = {
            fileAssociations = {
                {
                    systemId = xsdTemplates .. "XamlPresentation2006.xsd",
                    pattern = ".xaml"
                }
            }
        }
    }
}

require'lspconfig'.clangd.setup {
    cmd = {
        "clangd",
        "--query-driver=/usr/bin/arm-none-eabi-g++"
    }
}

require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", os.getenv('HOME') .. "/.local/lib/omnisharp/OmniSharp.dll" },
    filetypes = { "cs", "vb" },
    settings = {
      FormattingOptions = {
        -- Enables support for reading code style, naming convention and analyzer
        -- settings from .editorconfig.
        EnableEditorConfigSupport = true,
        -- Specifies whether 'using' directives should be grouped and sorted during
        -- document formatting.
        OrganizeImports = true,
      },
      MsBuild = {
        -- If true, MSBuild project system will only load projects for files that
        -- were opened in the editor. This setting is useful for big C# codebases
        -- and allows for faster initialization of code navigation features only
        -- for projects that are relevant to code that is being edited. With this
        -- setting enabled OmniSharp may load fewer projects and may thus display
        -- incomplete reference lists for symbols.
        LoadProjectsOnDemand = false,
      },
      RoslynExtensionsOptions = {
        -- Enables support for roslyn analyzers, code fixes and rulesets.
        EnableAnalyzersSupport = true,
        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        EnableImportCompletion = true,
        -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        -- true
        AnalyzeOpenDocumentsOnly = true,
      },
      Sdk = {
        -- Specifies whether to include preview versions of the .NET SDK when
        -- determining which version to use for project loading.
        IncludePrereleases = false,
      },
    },
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
})
