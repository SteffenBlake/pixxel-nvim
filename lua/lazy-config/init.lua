-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)
-- [[ Configure plugins ]]
local setup =
{
    -- NOTE: console-config

    -- NOTE: dap-config
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio"
        }
    },

    -- NOTE : git-Config
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    'akinsho/git-conflict.nvim',

    -- NOTE : lsp-Config
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'j-hui/fidget.nvim',
            'folke/neodev.nvim',
        },
    },
    -- Adds cycling for overloads in signature popups for LSP
    'Issafalcon/lsp-overloads.nvim',
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu'
    },
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
        },
    },
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
    -- Comment/uncomment commands
    'terrortylor/nvim-comment',
    -- Self hosted LLM code completion
    'huggingface/llm.nvim',
    -- Hoverhints with mouse
    "soulis-1256/eagle.nvim",
    -- Auto-append closing brace/bracket/parenth/etc
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
    },

    -- NOTE : nav-config
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    },
    "wsdjeg/vim-fetch",

    -- NOTE : neorg-config
    {
        "nvim-neorg/neorg",
        ft = 'norg',
        cmd = 'Neorg',
        priority = 30,
        after = 'nvim-treesitter',
        run = ":Neorg sync-parsers",
        tag = "v7.0.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('neorg-config')
        end
    },
    -- NOTE : prose-config
    -- Better line wrapping and nav between soft linewraps
    "preservim/vim-pencil",
    "dbmrq/vim-ditto",

    -- NOTE : test-config
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "Issafalcon/neotest-dotnet"
        }
    },
    {
        "andythigpen/nvim-coverage",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    -- NOTE : ui-config

    -- color-scheme (ui-config.color-scheme-config)
    {
        -- Theme inspired by Atom
        'navarasu/onedark.nvim',
        priority = 1000,
    },
    {
        'tamton-aquib/keys.nvim',
        --cmd = "KeysToggle"
    },
    -- Highlights usages of selected symbols
    'RRethy/vim-illuminate',
    -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    -- The nice status line you can see at the bottom of neovim ↓ ↓ ↓
    'nvim-lualine/lualine.nvim',
    -- Shows indent lines even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
    },
    -- Fuzzy Finder (files, lsp, git, grepping, etc)
    -- Also replaces default nvim picker with a fancy modal that supports search
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
    },
    -- <-- Fancy filetree over there
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    -- Scrollbar
    "petertriho/nvim-scrollbar",
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup()
            require("scrollbar.handlers.gitsigns").setup()
        end
    },
    -- Highlights on TODO/NOTE/HACK/PERF/FIX comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    -- New File Templates with selectors
    'SteffenBlake/new-file-template.nvim',
}

-- NOTE : TMUX support
if (os.getenv("TMUX") ~= nil) then
    table.insert(setup, "tpope/vim-obsession")
    table.insert(setup, "jabirali/vim-tmux-yank")
end

require('lazy').setup(setup)
