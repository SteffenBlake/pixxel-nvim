local M = {}

function M.register_leader()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
end

function M.directions()
    return {
        L = "H",
        R = "L",
        U = "K",
        D = "J"
    }
end

function M.setup_core()
    require('keybinds.which-key-config').setup()

    vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

    local tmux_sender = require('console-config.tmux-sender')
    local telescope = require('telescope')
    local tele_builtin = require('telescope.builtin')
    -- local omnisharp_extended = require('omnisharp_extended')
    local harpoon = require('harpoon')
    local dap = require('dap')
    local dapui = require('dapui')
    local projLoader = require('dap-config.proj-loader')
    local neotest = require('neotest')
    local coverage = require('coverage')
    local fzf = require('fzf-lua')

    local lsp_references = function()
        print(vim.bo.filetype)
        -- if (vim.bo.filetype == 'cs') then
        --     print("Using Omnisharp extended...")
        --     omnisharp_extended.telescope_lsp_references()
        -- end
        tele_builtin.lsp_references()
    end

    local lsp_definitions = function()
        print(vim.bo.filetype)
        -- if (vim.bo.filetype == 'cs') then
        --     print("Using Omnisharp extended...")
        --     omnisharp_extended.telescope_lsp_definition()
        -- end
        tele_builtin.lsp_definitions()
    end

    local lsp_implementations = function()
        print(vim.bo.filetype)
        -- if (vim.bo.filetype == 'cs') then
        --     print("Using Omnisharp extended...")
        --     omnisharp_extended.telescope_lsp_implementation()
        -- end
        tele_builtin.lsp_implementations()
    end

    local wk = require("which-key")
    
    wk.add({
      -- [C]onsole
      { "<leader>ce", function() tmux_sender.send_lines() end, desc = "[e]xecute current line", mode = "n" },
      { "<leader>ce", function() tmux_sender.send_selected() end, desc = "[e]xecute selection", mode = "v" },
      { "<leader>c", group = "[C]onsole" },
    
      -- [F]iles
      { "<leader>fg", tele_builtin.git_files, desc = "Search [g]it files" },
      { "<leader>fh", tele_builtin.oldfiles, desc = "Search file [h]istory" },
      { "<leader>fr", tele_builtin.live_grep, desc = "Search files by g[r]ep" },
      { "<leader>fb", tele_builtin.buffers, desc = "Search current [b]uffers" },
      { "<leader>fc", require('git-config.git-dirty-picker').git_dirty_picker, desc = "Search [c]hanged files" },
      { "<leader>ft", require('nvim-tree.api').tree.toggle, desc = "[t]oggle file tree" },
      { "<leader>f", group = "[F]iles" },
    
      -- [H]arpoon
      { "<leader>ha", function() harpoon:list():select(1) end, desc = "Jump to harpoon 1" },
      { "<leader>he", function() harpoon:list():select(2) end, desc = "Jump to harpoon 2" },
      { "<leader>hi", function() harpoon:list():select(3) end, desc = "Jump to harpoon 3" },
      { "<leader>ho", function() harpoon:list():select(4) end, desc = "Jump to harpoon 4" },
      { "<leader>hu", function() harpoon:list():select(5) end, desc = "Jump to harpoon 5" },
      { "<leader>hh", function() harpoon:list():append() end, desc = "[h]arpoon!" },
      { "<leader>hj", function() harpoon:list():prev() end, desc = "Prev" },
      { "<leader>hk", function() harpoon:list():next() end, desc = "Next" },
      { "<leader>hl", require('nav-config.harpoon-config').harpoon_picker, desc = "[l]ist harpoons" },
      { "<leader>h", group = "[H]arpoon" },
    
      -- [S]earch
      { "<leader>sr", lsp_references, desc = "[r]eferences" },
      { "<leader>sd", lsp_definitions, desc = "[d]efinitions" },
      { "<leader>si", lsp_implementations, desc = "[i]mplementations" },
      { "<leader>ss", tele_builtin.lsp_document_symbols, desc = "[s]ymbols" },
      { "<leader>sf", tele_builtin.current_buffer_fuzzy_find, desc = "[f]ind" },
      { "<leader>sw", tele_builtin.diagnostics, desc = "Diagnostic [w]arnings" },
      { "<leader>s", group = "[S]earch" },
    
      -- [R]efactor
      { "<leader>ra", fzf.lsp_code_actions, desc = "[a]ction menu", mode = { "n", "v" } },
      { "<leader>rr", vim.lsp.buf.rename, desc = "[r]ename" },
      { "<leader>rf", "<cmd>Format<cr>", desc = ":[f]ormat", mode = { "n", "v" } },
      { "<leader>ru", telescope.extensions.undo.undo, desc = "[U]ndo History", mode = { "n", "v" } },
      { "<leader>r", group = "[R]efactor" },
    
      -- [G]it
      { "<leader>gs", tele_builtin.git_branches, desc = "[s]witch branches" },
      { "<leader>gc", "<cmd>GitConflictListQf<cr>", desc = "List [c]onflicts" },
      { "<leader>gn", "<cmd>GitConflictChooseNone<cr>", desc = "Choose [n]one" },
      { "<leader>gy", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose [y]ours" },
      { "<leader>gt", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose [t]heirs" },
      { "<leader>gb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose [b]oth" },
      { "<leader>gh", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev conflict" },
      { "<leader>gl", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
      { "<leader>g", group = "[G]it" },
    
      -- [D]ebug
      { "<leader>dr", projLoader.build_and_run, desc = "Build and [r]un" },
      { "<leader>db", dap.toggle_breakpoint, desc = "Toggle [b]reakpoint" },
      { "<leader>dl", dap.list_breakpoints, desc = "[l]ist Breakpoints" },
      { "<leader>dc", dap.clear_breakpoints, desc = "[c]lear breakpoints" },
      { "<leader>dt", dapui.toggle, desc = "[t]oggle DAP UI" },
      { "<leader>d", group = "[D]ebug" },
    
      -- [T]ests
      { "<leader>tn", neotest.run.run, desc = "Run the [n]earest test" },
      {
        "<leader>td",
        function() neotest.run.run({ strategy = "dap" }) end,
        desc = "[d]ebug the nearest test"
      },
      {
        "<leader>tf",
        function() neotest.run.run(vim.fn.expand("%")) end,
        desc = "Test the entire [f]ile"
      },
      { "<leader>ts", coverage.summary, desc = "[S]ummarize test coverage" },
      { "<leader>t", group = "[T]ests" },
    })

end

return M
