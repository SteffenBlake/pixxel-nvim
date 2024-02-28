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
    local harpoon = require('harpoon')
    local dap = require('dap')
    local dapui = require('dapui')
    local projLoader = require('dap-config.proj-loader')
    local neotest = require('neotest')

    local normalMode = {
        c = {
            name = "[C]onsole",
            e = { tmux_sender.send_lines, "[E]xecute current line" }
        },
        f = {
            name = "[F]iles",
            g = { tele_builtin.git_files, "Search [G]it files" },
            h = { tele_builtin.oldfiles, "Search file [H]istory" },
            r = { tele_builtin.live_grep, "Search files by g[r]ep" },
            b = { tele_builtin.buffers, "Search current [B]uffers" },
            c = { require('git-config.git-dirty-picker').git_dirty_picker, "Search [C]hanged files" },
            t = { require('nvim-tree.api').tree.toggle, "[T]oggle file tree" }
        },
        h = {
            name = "[H]arpoon",
            a = { function() harpoon:list():select(1) end, "Jump to harpoon 1" },
            e = { function() harpoon:list():select(2) end, "Jump to harpoon 2" },
            i = { function() harpoon:list():select(3) end, "Jump to harpoon 3" },
            o = { function() harpoon:list():select(4) end, "Jump to harpoon 4" },
            u = { function() harpoon:list():select(5) end, "Jump to harpoon 5" },
            h = { function() harpoon:list():append() end, "[H]arpoon! " },
            j = { function() harpoon:list():prev() end, "Prev" },
            k = { function() harpoon:list():next() end, "Next" },
            l = { require('nav-config.harpoon-config').harpoon_picker, "[L]ist harpoons" }
        },
        s = {
            name = "[S]earch",
            r = { tele_builtin.lsp_references, "[R]eferences" },
            d = { tele_builtin.lsp_definitions, "[D]efinitions" },
            i = { tele_builtin.lsp_implementations, "[I]mplementations" },
            s = { tele_builtin.lsp_document_symbols, "[S]ymbols" },
            f = { tele_builtin.current_buffer_fuzzy_find, "[F]ind" },
            w = { tele_builtin.diagnostics, "Diagnostic [W]arnings" }
        },
        r = {
            name = "[R]efactor",
            a = { "<cmd>CodeActionMenu<cr>", "[A]ction menu" },
            r = { vim.lsp.buf.rename, "[R]ename" },
            f = { "<cmd>Format<cr>", ":[F]ormat" },
            u = { telescope.extensions.undo.undo, "[U]ndo History" }
        },
        g = {
            name = "[G]it",
            b = { tele_builtin.git_branches, "[B]ranches" },

        },
        d = {
            name = "[D]ebug",
            r = { projLoader.build_and_run, "Build and [R]un" },
            b = { dap.toggle_breakpoint, "Toggle [B]reakpoint" },
            l = { dap.list_breakpoints, "[L]ist Breakpoints" },
            c = { dap.clear_breakpoints, "[C]lear breakpoints" },
            t = { dapui.toggle, "[T]oggle DAP UI" }
        },
        t = {
            name = "[T]ests",
            n = { neotest.run.run, "Run the [N]earest test" },
            d = { function() neotest.run.run({ strategy = "dap" }) end, "[D]ebug the nearest test" },
            f = { function() neotest.run.run(vim.fn.expand("%")) end, "Test the entire [F]ile" }
        }
    }

    local visualMode = {
        c = {
            name = "[C]onsole",
            e = { tmux_sender.send_selected, "[E]xecute selection" }
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
