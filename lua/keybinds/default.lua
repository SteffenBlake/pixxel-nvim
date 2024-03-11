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

    local git_conflict = require('git-conflict')
    local tmux_sender = require('console-config.tmux-sender')
    local telescope = require('telescope')
    local tele_builtin = require('telescope.builtin')
    local harpoon = require('harpoon')
    local dap = require('dap')
    local dapui = require('dapui')
    local projLoader = require('dap-config.proj-loader')
    local neotest = require('neotest')

    local normalMode = {
        c = {
            name = "[C]onsole",
            e = { tmux_sender.send_lines, "[e]xecute current line" }
        },
        f = {
            name = "[F]iles",
            g = { tele_builtin.git_files, "Search [g]it files" },
            h = { tele_builtin.oldfiles, "Search file [h]istory" },
            r = { tele_builtin.live_grep, "Search files by g[r]ep" },
            b = { tele_builtin.buffers, "Search current [b]uffers" },
            c = { require('git-config.git-dirty-picker').git_dirty_picker, "Search [c]hanged files" },
            t = { require('nvim-tree.api').tree.toggle, "[t]oggle file tree" }
        },
        h = {
            name = "[H]arpoon",
            a = { function() harpoon:list():select(1) end, "Jump to harpoon 1" },
            e = { function() harpoon:list():select(2) end, "Jump to harpoon 2" },
            i = { function() harpoon:list():select(3) end, "Jump to harpoon 3" },
            o = { function() harpoon:list():select(4) end, "Jump to harpoon 4" },
            u = { function() harpoon:list():select(5) end, "Jump to harpoon 5" },
            h = { function() harpoon:list():append() end, "[h]arpoon! " },
            j = { function() harpoon:list():prev() end, "Prev" },
            k = { function() harpoon:list():next() end, "Next" },
            l = { require('nav-config.harpoon-config').harpoon_picker, "[l]ist harpoons" }
        },
        s = {
            name = "[S]earch",
            r = { tele_builtin.lsp_references, "[r]eferences" },
            d = { tele_builtin.lsp_definitions, "[d]efinitions" },
            i = { tele_builtin.lsp_implementations, "[i]mplementations" },
            s = { tele_builtin.lsp_document_symbols, "[s]ymbols" },
            f = { tele_builtin.current_buffer_fuzzy_find, "[f]ind" },
            w = { tele_builtin.diagnostics, "Diagnostic [w]arnings" }
        },
        r = {
            name = "[R]efactor",
            a = { "<cmd>CodeActionMenu<cr>", "[a]ction menu" },
            r = { vim.lsp.buf.rename, "[r]ename" },
            f = { "<cmd>Format<cr>", ":[f]ormat" },
            u = { telescope.extensions.undo.undo, "[U]ndo History" }
        },
        g = {
            name = "[G]it",
            s = { tele_builtin.git_branches, "[s]witch branches" },
            c = { "<cmd>GitConflictListQf<cr>", "List [c]onflicts" },
            n = { "<cmd>GitConflictChooseNone<cr>", "(Conflict) Choose [n]one" },
            y = { "<cmd>GitConflictChooseOurs<cr>", "(Conflict) Choose [y]ours" },
            t = { "<cmd>GitConflictChooseTheirs<cr>", "(Conflict) Choose [t]heirs" },
            b = { "<cmd>GitConflictChooseBoth<cr>", "(Conflict) Choose [b]oth" },
            h = { "<cmd>GitConflictPrevConflict<cr>", "(Conflict) Prev conflict" },
            l = { "<cmd>GitConflictNextConflict<cr>", "(Conflict) Next Conflict" },
        },
        d = {
            name = "[D]ebug",
            r = { projLoader.build_and_run, "Build and [r]un" },
            b = { dap.toggle_breakpoint, "Toggle [b]reakpoint" },
            l = { dap.list_breakpoints, "[l]ist Breakpoints" },
            c = { dap.clear_breakpoints, "[c]lear breakpoints" },
            t = { dapui.toggle, "[t]oggle DAP UI" }
        },
        t = {
            name = "[T]ests",
            n = { neotest.run.run, "Run the [n]earest test" },
            d = { function() neotest.run.run({ strategy = "dap" }) end, "[d]ebug the nearest test" },
            f = { function() neotest.run.run(vim.fn.expand("%")) end, "Test the entire [f]ile" }
        }
    }

    local visualMode = {
        c = {
            name = "[C]onsole",
            e = { tmux_sender.send_selected, "[e]xecute selection" }
        },
    }

    require('which-key').register(normalMode, {
        prefix = "<leader>",
        mode = "n"
    })
    require('which-key').register(visualMode, {
        prefix = "<leader>",
        mode = "v"
    })
end

return M
