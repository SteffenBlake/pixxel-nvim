# pixxel-nvim
My personal Neovim configuration

# Installation Requirements:

### Requires Nightly latest neovim (pre-release)
Last tested working on `v0.10.0-dev-*`

https://github.com/neovim/neovim/releases

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
Can validate it works via executing `omnisharp` and verify output

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

# ToDo:

[ ] - https://github.com/aca/emmet-ls  
[ ] - https://github.com/terrortylor/nvim-comment