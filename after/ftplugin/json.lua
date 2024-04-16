-- Json LSP doesnt like conceal level
vim.o.conceallevel=0

-- Specific overrides to use jsonc settings for certain .json files
local filename = string.lower(vim.fn.expand('%"t'))

local jsonc_exceptions = {
    ["secrets.json"] = true, -- dotnet 
    ["appsettings.json"] = true, -- dotnet
    [".eslintrc.json"] = true, -- eslint ES6
    [".mocharc.json"] = true, -- Mocha ES6
    ["tsconfig.json"] = true -- typescript
}

if (jsonc_exceptions[filename]) then
    vim.opt.filetype = "jsonc"
end
