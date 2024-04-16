local coverageFile = vim.fn.getcwd() .. "/.coverage/lcov.info"

if (not vim.fn.filereadable(coverageFile)) then
    return
end

vim.notify("Loading coverage file: '" .. coverageFile .. "'")

require("coverage").load_lcov(coverageFile, true)
