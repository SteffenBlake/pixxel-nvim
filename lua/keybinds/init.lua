local layout = os.getenv("NVIM_LAYOUT") or "default"

local M = require('keybinds.' .. layout)

return M
