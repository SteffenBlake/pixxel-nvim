# pixxel-nvim
My personal Neovim configuration

# Installation Requirements:

### Requires Nightly latest neovim (pre-release)
Last tested working on `v0.10.0-dev-*`

https://github.com/neovim/neovim/releases

### NerdFonts
Requires you to have a Nerdfont installed, and your terminal configured to use it
https://www.nerdfonts.com/font-downloads

### treesitter
#### Chocolate
https://chocolatey.org/
#### c/cpp
```
choco install mingw
choco install llvm
```

### Omnisharp
https://github.com/OmniSharp/omnisharp-roslyn
Once downloaded and installed, must also be added to PATH
Can validate it works via executing `omnisharp` within a C# project and verify output

### netcoredbg
https://github.com/Samsung/netcoredbg/releases
Same as omnisharp, once downloaded and installed, must be added to PATH
Can validate it works via executing `netcoredbg --version` in your terminal

### html LSP
`npm i -g vscode-langservers-extracted`

### tsserver LSP
`npm install -g typescript typescript-language-server`

## emmit LSP (mostly uised for css/sass/scss)
`npm install -g emmet-ls`

# Supports Build and Run for dotnet projects

First you must have a launch.json configured in your project root. proj-loader will automatically detect the path `.vs/launch.json` in the root of your project, and it assumes the project root based off the presence of a greedy depth first search of a .csproj file.

Example `launch.json` file:
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "cs",
            "name": "netcoredbg",
            "request": "launch",
            "program": "Your.Project.Name.dll",
            "cwd": "${workspaceFolder}/bin/Debug/net8.0/"
        }
    ]

}
```

proj-loader is configured by to use the found project root (where your .csproj file is) as its relative cwd for the launch.json, so you very likely willl always want your `cwd` entry to be similiar to the one above.

# List of plugins included in this setup

# ToDo:

[ ] - https://github.com/aca/emmet-ls  
[x] - https://github.com/numToStr/Comment.nvim
[ ] - Add support for changing build configs with proj-loader
