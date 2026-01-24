local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
        {
            'lewis6991/gitsigns.nvim',
        })
end

local base_mode = 'MERGE_BASE' -- Track current mode

local function get_default_branch()
    local default_branch = vim.fn.systemlist(
        'git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null'
    )[1]

    if default_branch and default_branch ~= '' then
        return default_branch:match('refs/remotes/origin/(.+)')
    end

    return nil
end

local function get_merge_base(default_branch)
    local merge_base = vim.fn.systemlist(
        string.format('git merge-base HEAD %s 2>/dev/null', default_branch)
    )[1]

    if merge_base and merge_base ~= '' then
        return merge_base
    end

    return nil
end

local function switch_to_merge_base()
    local gitsigns = require('gitsigns')
    local default_branch = get_default_branch()
    if not default_branch then return end

    local merge_base = get_merge_base(default_branch)
    if not merge_base then return end

    gitsigns.change_base(merge_base, true)
    base_mode = 'MERGE_BASE'
    print('GitSigns: comparing against merge-base (' .. merge_base:sub(1, 7) .. ')')
end

local function switch_to_head()
    local gitsigns = require('gitsigns')
    gitsigns.reset_base(true)
    base_mode = 'HEAD'
    print('GitSigns: comparing against HEAD')
end

local function toggle_base()
    if base_mode == 'HEAD' then
        switch_to_merge_base()
    else
        switch_to_head()
    end
end

local function on_attach()
    -- Auto-switch to merge-base on attach
    vim.defer_fn(switch_to_merge_base, 100)
end

function M.run(_)
    require('gitsigns').setup(
        {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = on_attach,
        })

    local wk = require('which-key')
    wk.add({
        { "<leader>gg", toggle_base, desc = "Toggle [g]it compare mode", mode = { "n" } }
    })
end

return M
