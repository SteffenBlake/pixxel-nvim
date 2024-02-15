local M = {}

function M.setup()
    local specialKeys = {
            ["BS>"] = "󰭜",
            ["Tab>"] = "",
            ["CR>"] = "󰌑",
            ["Return>"] = "󰌑",
            ["Enter>"] = "󰌑",
            ["Esc>"] = "󱊷",
            ["space>"] = "󱁐",
            ["Bslash>"] = "\\",
            ["Bar>"] = "|",
            ["lt>"] = "<",
            ["gt>"] = ">",
            ["F1>"] = "󱊫",
            ["F2>"] = "󱊬",
            ["F3>"] = "󱊭",
            ["F4>"] = "󱊮",
            ["F5>"] = "󱊯",
            ["F6>"] = "󱊰",
            ["F7>"] = "󱊱",
            ["F8>"] = "󱊲",
            ["F9>"] = "󱊳",
            ["F10>"] = "󱊴",
            ["F11>"] = "󱊵",
            ["F12>"] = "󱊶",
        };

    local normalKeys = {
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",

        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",

        "[", "]", "\\", ";", "'", ",", ".", "/", "-", "="
    }

    local key_labels = {}
    for k, v in pairs(specialKeys) do
        key_labels["<" .. k] = v
        key_labels["<S-" .. k] = "󰘶+" .. v
        key_labels["<C-" .. k] = "󰘴+" .. v
        key_labels["<M-" .. k] = "+" .. v
        key_labels["<A-" .. k] = "+" .. v
        key_labels["<T-" .. k] = "+" .. v
        key_labels["<s-" .. k] = "󰘶+" .. v
        key_labels["<c-" .. k] = "󰘴+" .. v
        key_labels["<m-" .. k] = "+" .. v
        key_labels["<a-" .. k] = "+" .. v
        key_labels["<t-" .. k] = "+" .. v
    end
    for _, v in pairs(normalKeys) do
        key_labels["<S-" .. v .. ">"] = "󰘶+" .. v
        key_labels["<C-" .. v .. ">"] = "󰘴+" .. v
        key_labels["<M-" .. v .. ">"] = "+" .. v
        key_labels["<A-" .. v .. ">"] = "+" .. v
        key_labels["<T-" .. v .. ">"] = "+" .. v
        key_labels["<s-" .. v .. ">"] = "󰘶+" .. v
        key_labels["<c-" .. v .. ">"] = "󰘴+" .. v
        key_labels["<m-" .. v .. ">"] = "+" .. v
        key_labels["<a-" .. v .. ">"] = "+" .. v
        key_labels["<t-" .. v .. ">"] = "+" .. v
    end

    require('which-key').setup({
        key_labels = key_labels
    })
end

return M
