local M = {}

function M.setup()
    local nvimTree = require('nvim-tree')
    local nvimTreeApi = require("nvim-tree.api")

    nvimTree.setup({
        sort = {
            sorter = "case_sensitive",
        },
        view = {
            width = 30,
        },
         diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = true,
        },
        -- on_attach = function(bufnr)
        --     local api = require('nvim-tree.api')
        --
        --     local function opts(desc)
        --       return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        --     end
        --
        --     vim.keymap.set('n', 'A', function()
        --       local node = api.tree.get_node_under_cursor()
        --       local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
        --       require("easy-dotnet").create_new_item(path)
        --     end, opts('Create file from dotnet template'))
        -- end
    })

    nvimTreeApi.events.subscribe(nvimTreeApi.events.Event.FileCreated, function(file)
        vim.cmd("edit " .. file.fname)
    end)

    -- Autoclose nvim-tree when when :q
    -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#beauwilliams
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
        pattern = "NvimTree_*",
        callback = function()
            local layout = vim.api.nvim_call_function("winlayout", {})
            if
                layout[1] == "leaf" and
                vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and
                layout[3] == nil
            then
                vim.cmd("confirm quit")
            end
        end
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "*.*",
        callback = function()
            nvimTreeApi.tree.find_file({ focus = false, open = false })
        end
    })
end

return M
