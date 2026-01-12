-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)

local console = require('console-config')
local dap = require('dap-config')
local git = require('git-config')
local lazy = require('lazy-config')
local lsp = require('lsp-config')
local ui = require('ui-config')
local whichKey = require('which-key-config')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.cmdheight = 1    -- Height for the command section at the bottom
vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

vim.o.conceallevel=3

-- copy block mode
vim.o.ve = 'block'

-- Disable wrap
vim.o.wrap = false;

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'
vim.o.mousemodel = 'popup'

-- Enable Spellcheck
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true


local context = {};

-- NOTE : SETUP

lazy.setup(context)
whichKey.setup(context)
ui.setup(context)
lsp.setup(context)

dap.setup(context)
console.setup(context)
git.setup(context)

if vim.env.NIX_ENABLE_DOTNET == "1" then
  require('dotnet-config').setup(context)
end

if vim.env.NIX_ENABLE_RUST == "1" then
  require('rust-config').setup(context)
end

-- NOTE : RUN
lazy.run(context)

whichKey.run(context)
dap.run(context)
console.run(context)
git.run(context)
lsp.run(context)

if vim.env.NIX_ENABLE_DOTNET == "1" then
  require('dotnet-config').run(context)
end

if vim.env.NIX_ENABLE_RUST == "1" then
  require('rust-config').run(context)
end

-- UI must always run last
ui.run(context)
