local utils = {}


function utils.nmap(keys, func, desc, mode, bfr)
    mode = mode or 'n'
    local opts = {desc = desc}
    if bfr then
        opts.buffer = bfr
    end
    vim.keymap.set(mode, keys, func, opts)
    vim.keymap.set(mode, '<leader>' .. keys, func, opts)
end

return utils
