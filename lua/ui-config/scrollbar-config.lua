local M = {}

function M.setup()
    -- Handles the scrollbar hiding the last char of a line
    --vim.opt.virtualedit = "onemore"
    
    require("scrollbar").setup({
        handle = {
            text = "┃",
            blend = 100,          -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
            color = "White",
            color_nr = nil,       -- cterm
            highlight = "White",
            hide_if_all_visible = true, -- Hides handle if all lines are visible
        },
        marks = {
            Cursor = {
                text = "█",
                priority = 0,
                gui = nil,
                color = "Cyan",
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "Cyan",
            },
            Search = {
                text = { "▌", "▌" },
                priority = 1,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "Search",
            },
            Error = {
                text = { "▌", "▌" },
                priority = 2,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "DiagnosticVirtualTextError",
            },
            Warn = {
                text = { "▌", "▌" },
                priority = 3,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "DiagnosticVirtualTextWarn",
            },
            Info = {
                text = { "▌", "▌" },
                priority = 4,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "DiagnosticVirtualTextInfo",
            },
            Hint = {
                text = { "▌", "▌" },
                priority = 5,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "DiagnosticVirtualTextHint",
            },
            Misc = {
                text = { "▌", "▌" },
                priority = 6,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "Normal",
            },
            GitAdd = {
                text = "▌",
                priority = 7,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "GitSignsAdd",
            },
            GitChange = {
                text = "▌",
                priority = 7,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "GitSignsChange",
            },
            GitDelete = {
                text = "▁",
                priority = 7,
                gui = nil,
                color = nil,
                cterm = nil,
                color_nr = nil, -- cterm
                highlight = "GitSignsDelete",
            },
        },
    })
end

return M
