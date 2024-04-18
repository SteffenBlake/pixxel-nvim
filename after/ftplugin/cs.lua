local coverageFile = vim.fn.getcwd() .. "/.coverage/lcov.info"

if (vim.fn.filereadable(coverageFile) == 0) then
    return
end

vim.notify("Loading coverage file: '" .. coverageFile .. "'")

require("coverage").load_lcov(coverageFile, true)
