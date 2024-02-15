local M = {}

function M.setup()
    local neotest = require("neotest")

    neotest.setup({
        adapters = {
            require("neotest-dotnet")({
                dap = { justMyCode = true },
                discovery_root = "solution"
            })
        }
    })
end

return M
