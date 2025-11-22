local M = {}

function M.setup()
    local onedark = require('onedark')
    onedark.setup({
        style = 'cool'
    })
    onedark.load()

    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerSolution", { link = "Question" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerProject", { link = "Character" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerTest", { link = "Normal" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerSubcase", { link = "Conceal" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerDir", { link = "Directory" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerPackage", { link = "Include" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerPassed", { link = "DiagnosticOk" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerFailed", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "EasyDotnetTestRunnerRunning", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "EasyDotnetDebuggerFloatVariable", { link = "Question" })
    vim.api.nvim_set_hl(0, "EasyDotnetDebuggerVirtualVariable", { link = "Question" })
    vim.api.nvim_set_hl(0, "EasyDotnetDebuggerVirtualException", { link = "DiagnosticError" })
end

return M
