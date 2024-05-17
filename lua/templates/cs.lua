local utils = require("new-file-template.utils")
local nvimTreeApi = require('nvim-tree.api')


local function record_symbol(obj_name)
    return "public record " .. obj_name .. "(|cursor|);"
end

local function general_symbol(obj_type, obj_name)
    return
[[
public ]] .. obj_type .. ' ' .. obj_name .. [[ 
{
    |cursor|
}]]

end

local function on_obj_select(obj_type, relative_path, filename, callback)
    if (obj_type == 'none') then
        return
    end
    local namespace = relative_path:gsub("/", ".")
    local obj_name = vim.fn.fnamemodify(filename, ':r')

    local symbol_text = ''
    if (obj_type == 'record') then
        symbol_text = record_symbol(obj_name)
    else
        symbol_text = general_symbol(obj_type, obj_name)
    end
    callback([[namespace ]] .. namespace .. [[;

]] .. symbol_text)

    -- Show the tree again after write is complete
    nvimTreeApi.tree.toggle({ focus = false, find_file = true, })
end


local function base_template(relative_path, filename, callback)
    -- Telescope during bufEnter seems to really not play nice the nvim-tree
    -- So if we hide it before triggering telescope pickers, then show it only
    -- after the dust settles, everything seems to work fine
    nvimTreeApi.tree.close()

    vim.ui.select(
        { 'class', 'struct', 'enum', 'interface', 'record' },
        {
            prompt = "Please select an object template to use"
        },
        function(obj_type) on_obj_select(obj_type, relative_path, filename, callback) end
    )
end

--- @param opts table
---   A table containing the following fields:
---   - `full_path` (string): The full path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `relative_path` (string): The relative path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `filename` (string): The filename of the new file, e.g., "init.lua".
return function(opts, callback)
    local template = {
        { pattern = ".*", content = base_template },
    }

    return utils.find_entry(template, opts, callback)
end
