local neotest = require("neotest")
local utils = require("utils")

neotest.setup({
  adapters = {
    require("neotest-dotnet")({
      dap = { justMyCode = true }
    })
  }
})

utils.nmap('tn', function() neotest.run.run() end, "[t]est the [n]earest test")
utils.nmap('tf', function() neotest.run.run(vim.fn.expand("%")) end, "[t]est the entire [f]ile")
