--
-- dotnet-loader.lua
--

local dotnetDllLoader = {}

function OnDotnetDllSelect(selectedDll, callback)
  vim.g['dotnet_dll'] = vim.fn.fnamemodify(selectedDll, ":p")
  callback()
end

function SelectDotnetRuntime(callback)
  local projPath = vim.g['dotnet_proj']
  local projDir = vim.fn.fnamemodify(projPath, ':h') .. "/bin/Debug/"
  local fileName = vim.fn.fnamemodify(projPath, ':t:r') .. ".dll"

  local runtimes = vim.fn.findfile(fileName, projDir .. "**", -1)

  if (#runtimes == 0) then
    vim.g['dotnet_dll'] = nil
    print("File '" .. fileName .. "' not found within expected path: '" .. projDir .. "'")
    return

  elseif (#runtimes == 1) then
    OnDotnetDllSelect(runtimes[0], callback)
    return

  else
    vim.ui.select(
      runtimes,
      {
        prompt = "Multiple .dll runtime files detected, please select one"
      },
      function (selected) OnDotnetDllSelect(selected, callback) end
    )
  end
end

function GetDotnetRuntime(callback)
  if vim.g['dotnet_dll'] == nil then
    SelectDotnetRuntime(callback)
  else
    callback()
  end
end

function OnProjSelect(selectedProj, callback)
  vim.g['dotnet_proj'] = selectedProj
  SelectDotnetRuntime(callback);
end

function SelectDotnetProj(callback)
  local last = "";
  local current = vim.fn.expand('%:p');
  local projs = {};
  vim.api.nvim_echo({{'last: ' .. last}}, false, {})
  vim.api.nvim_echo({{'current: ' .. current}}, false, {})

  -- Recursive loop up parent dirs til we find a .csproj file
  while (last ~= current and #projs == 0) do
    last = current;
    current = vim.fn.fnamemodify(current, ':h');
    projs = vim.fn.split(vim.fn.globpath(current, "*.csproj"), "\n");
  end

  if #projs == 0 then
    vim.g['dotnet_proj'] = nil;
    print("No .csproj file found within buffer dir or any parent dir")

  elseif #projs == 1 then
    OnProjSelect(projs[0], callback)
    return

  else
    vim.ui.select(projs,
      {
        prompt = "Multiple .csproj files detected, please select one"
      },
      function (selected) OnProjSelect(selected, callback) end
    )

  end
end

--- Async loads the dll for a dotnet proj, prompting the user if multiple valid files exists
--- After success, the value of the path can be pulled from vim.g['dotnet_dll']
--- @param callback function (string) callback that gets called if a dll was found
function dotnetDllLoader.reloadPath(callback)
   SelectDotnetProj(callback)
end

--- Async ensures vim.g['dotnet_dll'] is set, then invokes callback once it is set. If it is already set, callback will be invoked asap
--- @param callback function (string) callback that gets called once vim.g['dotnet_dll] is set
function dotnetDllLoader.getPath(callback)
  if vim.g['dotnet_proj'] == nil or vim.g['dotnet_dll'] == nil then
    SelectDotnetProj(callback)
  else
    callback();
  end
end

return dotnetDllLoader

