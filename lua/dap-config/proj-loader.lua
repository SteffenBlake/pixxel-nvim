--
-- dotnet-loader.lua
--
local dap = require('dap')
local vscode = require('dap.ext.vscode')

local function log(msg)
    vim.schedule(function()
        vim.cmd("redraw")
        print(msg)
    end)
end
local function log_error(msg)
    vim.schedule(function()
        vim.cmd("redraw")
        error(msg)
    end)
end

local M = {}

function M.setup(opts)
    M.opts = opts
end

function OnProjRootSelect(selectedProj, callback)
    vim.g['dap_proj'] = selectedProj
    log("Using proj root: '" .. selectedProj .. "'")
    -- SelectDotnetRuntime(callback);
    callback(vim.g['dap_proj'])
end

local rootMappings = {
    csproj = "*.sln",
    cs = "*.sln",
    sln = "*.sln",
    js = "project.json",
    ts = "project.json",
    dart = "pubspec.yaml",
    flutter = "pubspec.yaml"
}

function GetRootGlob()
    local bufExt = vim.fn.expand('%:e')
    local rootGlob = rootMappings[bufExt]
    if (rootGlob == nil) then
        log("Unknown root mapping for file ext: '" .. bufExt .. "'")
        return
    end
    return rootGlob
end

function SelectProjRoot(callback)
    local rootGlob = GetRootGlob()
    local last = "";
    local current = vim.fn.expand('%:p');

    -- Recursive loop up parent dirs til we find a .csproj file
    while (last ~= current) do
        last = current
        current = vim.fn.fnamemodify(current, ':h')

        local projsRaw = vim.fn.globpath(current, rootGlob)
        if string.len(projsRaw) > 0 then
            if string.find(projsRaw, '\n') then
                local projs = vim.fn.split(projsRaw, "\n")
                vim.ui.select(projs,
                    {
                        prompt = "Multiple root globs detected, please select one\n"
                    },
                    function(selected) OnProjRootSelect(selected, callback) end
                )
                return
            else
                OnProjRootSelect(projsRaw, callback)
                return
            end
        end
    end

    vim.g['dap_proj'] = nil;
    log("Could not find a parent rootmatch for glob '" ..
        rootGlob .. "' from dir '" .. vim.fn.expand('%:p:h') .. "' or up")
end

--- Async loads the dll for a dotnet proj, prompting the user if multiple valid files exists
--- After success, the value of the path can be pulled from vim.g['dotnet_dll']
--- @param callback function (string) callback that gets called if a dll was found
function M.reloadProj(callback)
    SelectProjRoot(callback)
end

--- Async ensures vim.g['dotnet_dll'] is set, then invokes callback once it is set. If it is already set, callback will be invoked asap
--- @param onProjDirCallback function (string) callback that gets called once vim.g['dotnet_dll] is set
function M.getProj(onProjDirCallback)
    if vim.g['dap_proj'] == nil then
        SelectProjRoot(onProjDirCallback)
    else
        log("Using proj: '" .. vim.g['dap_proj'] .. "'")
        onProjDirCallback(vim.g['dap_proj']);
    end
end

function M.getProjDir(onProjDirCallback)
    M.getProj(function(projFile) onProjDirCallback(vim.fn.fnamemodify(projFile, ':h') .. "/") end)
end

function M.getProjLaunchJson(onLaunchJsonCallback)
    M.getProjDir(function(projDir) onLaunchJsonCallback(projDir, projDir .. '.vscode/launch.json') end)
end

function run_builder(builder)
    local cmd = builder.cmd(vim.g['dap_proj'])
    local shellOpts = {}
    if (builder.verbose) then
        shellOpts.stdout = function(err, data)
            if (err) then log_error(err) end
            if (data) then log(data) end
        end
    end

    local buildResult = vim.system(cmd, shellOpts):wait()
    if buildResult.code == 0 then
        log('Build: ✔️ ')
    else
        log('Build: ❌ (code: ' .. buildResult.code .. ')')
    end
end

function OnLaunchJson(projDir, jsonPath)
    if (not vim.fn.filereadable(jsonPath)) then
        log("No launch.json file found at path '" .. jsonPath .. "'")
        return
    end
    log("Loading '" .. jsonPath .. "'")
    vscode.load_launchjs(jsonPath)

    local rootGlob = GetRootGlob()
    local builder = M.opts.builders[rootGlob]
    if (M.opts.setCwd) then
        vim.api.nvim_set_current_dir(projDir)
    end
    if (builder == nil) then
        log("No registered builder for glob: '" .. rootGlob .. "', skipping straight to callback")
    else
        run_builder(builder)
    end

    dap.continue()
end

function M.build_and_run()
    M.getProjLaunchJson(OnLaunchJson)
end

return M
