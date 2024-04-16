local M = {}

function M.load_report()
    local path = vim.fn.input("Coverage Report Path: ", "", "file")
    require('coverage').load_lcov(path, true)
end

function M.clear()
    require('coverage').clear()
end

function M.summary()
    require('coverage').summary()
end

return M
