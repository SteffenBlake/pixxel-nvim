local M = {}

function M.setup(ctx)
    table.insert(ctx.lazy,
        {
            'Issafalcon/lsp-overloads.nvim'
        })
end

local function on_attach(client, _)
    local wk = require('which-key')

    if client.server_capabilities.signatureHelpProvider then
        local lspOverloads = require('lsp-overloads');
        wk.add({
            { "<c-s>", ":LspOverloadsSignature<CR>", desc = "Show [C-S]ignatures", mode = { 'n', 'i' } },
        })

        lspOverloads.setup(client, {
            -- UI options are mostly the same as those passed to vim.lsp.util.open_floating_preview
            ui = {
                border = "single", -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
                height = nil,      -- Height of the signature popup window (nil allows dynamic sizing based on content of the help)
                width = nil,       -- Width of the signature popup window (nil allows dynamic sizing based on content of the help)
                wrap = true,       -- Wrap long lines
                wrap_at = nil,     -- Character to wrap at for computing height when wrap enabled
                max_width = nil,   -- Maximum signature popup width
                max_height = nil,  -- Maximum signature popup height
                -- Events that will close the signature popup window: use {"CursorMoved", "CursorMovedI", "InsertCharPre"} to hide the window when typing
                close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
                focusable = true,                       -- Make the popup float focusable
                focus = false,                          -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
                offset_x = 0,                           -- Horizontal offset of the floating window relative to the cursor position
                offset_y = 0,                           -- Vertical offset of the floating window relative to the cursor position
                floating_window_above_cur_line = false, -- Attempt to float the popup above the cursor position
                -- (note, if the height of the float would be greater than the space left above the cursor, it will default
                -- to placing the float below the cursor. The max_height option allows for finer tuning of this)
                silent = true -- Prevents noisy notifications (make false to help debug why signature isn't working)
            },
            keymaps = {
                next_signature = "<C-j>",
                previous_signature = "<C-k>",
                next_parameter = "<C-l>",
                previous_parameter = "<C-h>",
                close_signature = "<A-s>"
            },
            display_automatically = true -- Uses trigger characters to automatically display the signature overloads when typing a method signature
        })
    end
end

function M.run(_)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf
            on_attach(client, bufnr);
        end
    })
end

return M
