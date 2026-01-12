local M = {}

function M.setup(ctx)
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    ctx.lazy = {
        -- mostly we use fzf in telescope mode for code actions
        -- Comment/uncomment commands
        'terrortylor/nvim-comment',
    }

    -- NOTE : TMUX support
    if (os.getenv("TMUX") ~= nil) then
        table.insert(ctx.lazy, "tpope/vim-obsession")
        table.insert(ctx.lazy, "jabirali/vim-tmux-yank")
    end
end

function M.run(ctx)
    require('lazy').setup(ctx.lazy)
end

return M
