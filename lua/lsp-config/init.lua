local lspconfig = require('lspconfig')
local utils = require("utils")

require('lsp-config.autopairs-config').setup()
require('lsp-config.comment-config').setup()
require('lsp-config.fzf-lua-config')
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

local mason_lspconfig = require('mason-lspconfig')

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

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
    on_attach = on_attach
}

lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

lspconfig.svelte.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

lspconfig.html.setup {
    capabilities = capabilities,
    filetypes = { "html", "hbs", "handlebars" },
    on_attach = on_attach,
}

lspconfig.jsonls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

lspconfig.dartls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

lspconfig.ruff.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            disableTaggedHints = true,
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
            },
        },
    }
}

local msbuildCmd = {}
if vim.fn.has('win32') == 1 then
    msbuildCmd = {
        'dotnet',
        'C:\\Program Files\\msbuild-project-tools-server\\MSBuildProjectTools.LanguageServer.Host.dll'
    }
elseif vim.fn.has('unix') == 1 then
    msbuildCmd = {
        'dotnet',
        '/usr/local/lib/msbuild-project-tools-server/MSBuildProjectTools.LanguageServer.Host.dll'
    }
end

lspconfig.msbuild_project_tools_server.setup {
    capabilities = capabilities,
    cmd = msbuildCmd,
    filetypes = { "csproj", "sln" },
    on_attach = on_attach,
}

local roslynCmd = {}
if vim.fn.has('win32') == 1 then
    roslynCmd = {
        'dotnet',
        'C:\\Program Files\\Roslyn\\Microsoft.CodeAnalysis.LanguageServer.dll',
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
    }
elseif vim.fn.has('unix') == 1 then
    roslynCmd = {
        'dotnet',
        '/usr/local/lib/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll',
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
    }
end

require("roslyn").setup({
        config = {
        cmd = roslynCmd,
        on_attach = on_attach,
        settings = {
            ["csharp|background_analysis"] = {
                background_analysis = {
                    dotnet_analyzer_diagnostics_scope = "fullSolution",
                    dotnet_compiler_diagnostics_scope = "fullSolution"
                }
            },
            ["csharp|formatting"] = {
                dotnet_organize_imports_on_format = true
            }
        }
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
})
