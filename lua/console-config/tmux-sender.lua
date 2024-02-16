local M = {}

local function normalize(str)
    return string.gsub(str, "\n", "")
end

function M.ensure_pane()
    -- Check if the panel was closed by something else
    -- if so, set our stored id back to null
    if (vim.g.tmux_id ~= nil) then
        local exists = normalize(vim.fn.system(
            'tmux has-session -t ' .. vim.g.tmux_id .. ' 2> /dev/null && echo 1'
        ))
        if (exists ~= '1') then
            vim.g.tmux_id = nil
        end
    end
    -- If our stored id is null, it means we dont have a pane yet
    if (vim.g.tmux_id == nil) then
        vim.g.tmux_id = normalize(vim.fn.system(
            'tmux split-window -l 15% -P -F "#{pane_id}"'
        ))
        return
    end
end

function M.send_lines()
    vim.cmd('normal! V')
    M.send_selected()
end

function M.send_selected()
    if not (vim.fn.mode() == "v" or vim.fn.mode() == "V") then
        vim.notify(
            "Use this on visual mode",
            "warn",
            { title = "Tmux Sender" }
        )
        return
    end

    vim.cmd('normal! "ty')
    local cmd = vim.fn.getreg("t")

    M.send(cmd)
end

function M.send(cmd)
    M.ensure_pane()

    vim.fn.system(
        'tmux send-keys -t ' .. vim.g.tmux_id .. ' "' .. cmd .. '" Enter'
    )
end

return M
