local M = {}

function M.git_dirty_picker()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local sorters = require "telescope.sorters"
    local commitList = vim.fn.systemlist('git whatchanged --name-only --pretty="" origin..HEAD')
    local changeList = vim.fn.systemlist('git diff --name-only')

    local pickerList = {}
    local hash = {}
    -- First add uncommited files to the list
    for _, v in ipairs(changeList) do
        pickerList[#pickerList + 1] = v
        hash[v] = true
    end
    -- Then add on unpushed files (checking for distinct)
    for _, v in ipairs(commitList) do
        if (hash[v] ~= nil) then
            pickerList[#pickerList + 1] = v
            hash[v] = true
        end
    end

    pickers.new({}, {
        prompt_title = "Git Dirty",
        finder = finders.new_table { results = pickerList },
        sorter = sorters.fuzzy_with_index_bias()
    }):find()
end

return M
