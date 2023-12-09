local nvimTree = require('nvim-tree')
local nvimTreeApi = require("nvim-tree.api")

function onAttach(bufnr)

end

nvimTree.setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    on_attach = onAttach
})

nvimTreeApi.events.subscribe(nvimTreeApi.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)

-- Auto open MiniMap sidebar for all files
vim.api.nvim_create_autocmd('vimEnter', {
    callback = function(data)
        local isDirectory = vim.fn.isdirectory(data.file) == 1
        if isDirectory then
            vim.cmd.cd(data.file)
        end
        nvimTreeApi.tree.toggle({ focus = false, find_file = true, })
    end,
    pattern = '*',
})

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#rwblokzijl
local function tab_win_closed(winnr)
    local tabnr = vim.api.nvim_win_get_tabpage(winnr)
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local buf_info = vim.fn.getbufinfo(bufnr)[1]
    local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
    local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
    if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
        -- Close all nvim tree on :q
        if not vim.tbl_isempty(tab_bufs) then    -- and was not the last window (not closed automatically by code below)
            nvimTreeApi.tree.close()
        end
    else                                                  -- else closed buffer was normal buffer
        if #tab_bufs == 1 then                            -- if there is only 1 buffer left in the tab
            local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
            if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
                vim.schedule(function()
                    if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
                        vim.cmd "quit"                    -- then close all of vim
                    else                                  -- else there are more tabs open
                        vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
                    end
                end)
            end
        end
    end
end

vim.api.nvim_create_autocmd("WinClosed", {
    callback = function()
        local winnr = tonumber(vim.fn.expand("<amatch>"))
        vim.schedule_wrap(function() tab_win_closed(winnr) end)
    end,
    nested = true
})
