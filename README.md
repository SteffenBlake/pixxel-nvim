# pixxel-nvim
My personal Neovim configuration, primarly focused on dotnet web dev

# Installation Requirements:

### Requires Nightly latest neovim (pre-release)
Last tested working on `v0.10.0-dev-*`

https://github.com/neovim/neovim/releases

### NerdFonts
Requires you to have a Nerdfont installed, and your terminal configured to use it
https://www.nerdfonts.com/font-downloads

### Treesitter: Chocolate + c/cpp Make
#### Chocolate
https://chocolatey.org/
#### c/cpp
```
choco install mingw
choco install llvm
```
### Telescope grep: ripgrep
#### ripgrep
https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation

### netcoredbg
https://github.com/Samsung/netcoredbg/releases
Same as omnisharp, once downloaded and installed, must be added to PATH
Can validate it works via executing `netcoredbg --version` in your terminal

Also, and very importantly, I have a configuration setup to remote debug with netcoredbg **over ssh targeting windows**, for more info see below

### msbuild LSP (.sln, .csproj, etc)
Download the latest copy of msbuild-project-tools-server here: https://github.com/tintoy/msbuild-project-tools-server/releases/latest

Unzip it to the following locations:
* **Windows:** C:\Program Files\msbuild-project-tools-server\
* **Linux:** /usr/local/lib/msbuild-project-tools-server/

(Note that the file `MSBuildProjectTools.LanguageServer.Host.dll` should exist in this directory if you did it right, IE the file `/usr/local/lib/msbuild-project-tools-server/MSBuildProjectTools.LanguageServer.Host.dll` should exist now)

### Roslyn LSP (C#, .NET)
1. Download the latest copy of `Microsoft.CodeAnalysis.LanguageServer`

* Linux x64: https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.linux-x64

* Windows x64: https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.win-x64

(Note other architectures are supported but I just linked the two most obvious ones)

2. It will be a .nupkg file, just rename it to a .zip and unzip it.

3. You will find the actual LSP folder at `./content/LanguageServer/<YourArch>/` in the zip

4. Copy that folder to the following:

* Linux: `/usr/local/lib/roslyn/`

* Windows: `C:\Program Files\Roslyn\` 

(Note that the file `Microsoft.CodeAnalysis.LanguageServer.dll` should exist in this directory if you did it right, IE the file `/usr/local/lib/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll` should exist now)

#### .editorconfig
Here is my recommended .editorconfig file to go in `~`
```
root = true

[*.{cs,vb}]
csharp_style_namespace_declarations = file_scoped
csharp_style_var_for_built_in_types = true
csharp_style_var_when_type_is_apparent = true
csharp_style_var_elsewhere = true
dotnet_style_prefer_conditional_expression_over_return = false
```

#### rpc.lua fix (Might not be relevant for Roslyn)
If opening .cs files triggers this error:
`attempt to index local 'decoded' (a nil value)`
Then perform this fix:
https://github.com/OmniSharp/omnisharp-roslyn/issues/2574#issuecomment-2045096730

(Note the path to rpc.lua may differ from that comment, use the same path your specific error is giving)

### html LSP
`npm i -g vscode-langservers-extracted`

### ts_ls LSP (Typescript / Json)
`npm install -g typescript typescript-language-server`

### svelte LSP
`npm install -g svelte-language-server`

### Pi Pico C++ LSP
https://clangd.llvm.org/installation

Clangd is configured to utilize the pi pico g++ installer. I could probably add configuration to switch which query engine to use but pretty much the only time I use C++ nowadays is for compiling to arm SBCs so...

### Python LSPs
1. Install uv: https://docs.astral.sh/uv/getting-started/installation/#installation-methods
2. Install ruff LSP: `uv tool install ruff@latest`
3. Install pyright typechecker LSP: `uv tool install pyright` 

### XML LSP (lemminx vscode)
Download the latest binary from here: https://github.com/redhat-developer/vscode-xml/releases/latest
Ensure it is on PATH, and has been named `lemminx`

### Avalonia axaml LSP
1. Checkout Avalonia.Ide here https://github.com/kekekeks/Avalonia.Ide to `~/.local/lib/Avalonia.Ide`
2. Replace the pngcs submodule with this one: https://github.com/leonbloy/pngcs
3. Checkout and update all submodules
4. Build `./src/Avalonia.Ide.LanguageServer` via `dotnet publish -c Release`
5. If all went well, the output should be `~/.local/lib/Avalonia.Ide/src/Avalonia.Ide.LanguageServer/bin/Release/netcoreapp2.1/Avalonia.Ide.LanguageServer.dll`

# How to install this configuration
## Windows
nvim folder location should be `%LocalAppData%/nvim`, checkout the git repo to that location with that name.
If done correctly the file `%LocalAppData%/nvim/README.md` should exist.

## Linux
nvim folder location should be `~/.config/nvim`, checkout the git repo to that location with that name.
If done correctly the file `~/.config/nvim/README.md` should exist.


# Supports Build and Run for dotnet projects

First you must have a launch.json configured in your project root. proj-loader will automatically detect the path `.vs/launch.json` in the root of your project, and it assumes the project root based off the presence of a greedy depth first search of a .sln file.

Configuration is also setup to have pid-attach work for a running instance of a dotnet app via dap-pid-picker, but it will make your life a lot easier if the below is done:

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
            "cwd": "${workspaceFolder}/Your.Project.Name/bin/Debug/net8.0/"
        }
    ]

}
```

proj-loader is configured to use the found project root (where your .sln file is) as its relative cwd for the launch.json, so you very likely wwill always want your `cwd` entry to be similiar to the one above.

Note that nvim-dap supports multiple matching configs for the same build out of the box, and if multiple matches are found it will just prompt you with which one you want to use, allowing you to define multiple build configs in your `launch.json` file

# Connect to an already running process

If you want something a bit faster and more ad-hoc, you can just use the "Build and Run" shortcut instead and select "Connect to a process", it'll then give you a fuzzy searchab;e process list to pick from and connect to.

To be honest this has now started to become my preferred approach, once you know what to search for it becomes pretty fast to quickly connect.

# Remote debugging over SSH targeting a Windows OpenSSH Server

# List of major plugins included in this setup and a quick blurb about them, and relevant keybinds for them
## [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
Debugger and interface. Currently just setup with `netcoredbg` to debug dotnet applications

- [ ] TODO: Add node/npm support for web dev

`F9` - Toggle Breakpoint  
`F5` - Build and run  

All other keybinds are largely the same

## [lsp-config](https://github.com/neovim/nvim-lspconfig) + [cmp](https://github.com/hrsh7th/nvim-cmp)
Autocomplete/code suggestions/etc

Currently using the following LSPs:
* Dotnet: Roslyn
* html: vscode-langservers-extracted
* TS/JS/Node/NPM/Json: typescript-language-server
* Lua: lua_ls
- [ ] TODO: Figure out the best LSP for CSS/SASS/SCSS  

## [lualine](https://github.com/nvim-lualine/lualine.nvim)
Adds a nice status line at the bottom of the editor with tonnes of meta info like git, line ending type, character format, filetype, line number and char pos, etc etc.

## [nvim-comment](https://github.com/terrortylor/nvim-comment)
Toggling code comments on/off

`Ctrl + /` - Comments out a selected block of lines, if you have a block selected  
`Ctrl + / Ctrl + /` - Comments out the current line the cursor is on, if no selection is made  

## [gitsigns](https://github.com/lewis6991/gitsigns.nvim)
Git integration for multiple other plugins, primarily used to show del/add/modify status of files, folders, individual lines of code, etc

## [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) 
VSCode style File browser on lefthand side + tabs on the top. nvim-tree supports a bunch of commands for adding/removing/changing files and directories

## [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
Navigation tool for quickly "remembering" the last place you were in a buffer when you change buffers, providing a "history" style functionality to quickly hop back to the last place you were in the prior buffer. Has "hot" memory for quick swapping between 4 buffers

## [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)
Pretty but minimalist scrollbar on buffers. Has both `lsp-config` integration to show potential code warnings/errors/suggestions, as well as git integration to show status of individual lines

- [ ] TODO: Modify the icons and highlighting to make more sense and be less messy. We have nerdfont capability and can definitely improve the UX here

## [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
Mandatory treesitter as every vim config has. Code highlighting / coloring / etc. You'd be a madlad to not have this plugin

## [nvim-telescope](https://github.com/nvim-telescope/telescope.nvim)
Another mandatory plugin everyone uses. Searching, Grepping, but also a handy tool for pickers and floating selectors and whatnot, many other plugins depend on this

## [telescope-ui-select](https://github.com/nvim-telescope/telescope-ui-select.nvim)
Replaces vim's default select picker with above aformentioned telescope's much fancier and prettier picker, which includes filtering options by text input

## [new-file-template](https://github.com/SteffenBlake/new-file-template.nvim) (custom fork)
Templating for new files created if they match specific filename matches. Custom fork of the original plugin that switches the API to a callback system to support pickers/inputs with callback patterns

## git-conflict
Handy tool for detecting git conflict `>...` + `..<` in files. Disables code suggestions until git conflicts are resolved, and enables a handful of handy commands for resolving conflicts and navigating them.

#### cs
Prompts for templates for the following currently supported types:
* class
* struct
* enum
* interface
#### lua
Defaults, built in
#### Ruby
Defaults, built in, I dunno how these work tbh they came with the plugin and I dont use ruby so /shrug
#### Javascript
WIP, TODO
#### Typescript
WIP, TODO

## [lsp-overloads](https://github.com/Issafalcon/lsp-overloads.nvim)
Extremely handy plugin for toggling visibility of the signature of methods, as well as browsing the method's overloads
#### keybinds
`ctrl-s` - Force show overloads popup, for the method currently selected in the buffer  
`alt-s` - Hide the overloads popup  
`ctrl-h/l` - browse the paramaters and their definitions of the current signature  
`ctrl-j/k` - browse the list of overloads  

## [Neorg](https://github.com/nvim-neorg/neorg)
Pretty powerful and handy note taking, journal, calender, to-do list, etc AIO for neovim. Lets you designate predifined "workspace" folders your notes/journals etc get saved in.
My preferred use case is journal+todo lists to have tracked to-do items day by day for work.

There's a solid youtube series on how to use it here:
https://www.youtube.com/watch?v=NnmRVY22Lq8

Keybinds:
WIP

Default workspace config:
* Notes: `~/Documents/notes/` (default workspace)
* Journal: `~/Documents/journal/`(default journal workspace)
Note: the above folders will need to exist prior to using any of the Neorg commands, or you'll get some errors

## [llm.nvim](https://github.com/huggingface/llm.nvim)

Inline autocomplete support for a locally run, self hosted llm API
Full configuration is in [./lua/lsp-config/llm-config.lua](https://github.com/SteffenBlake/pixxel-nvim/blob/main/lua/lsp-config/llm-config.lua)

See documentation here on configuring the values: https://github.com/gnanakeethan/llm.nvim?tab=readme-ov-file#adaptors

Requires, by default, the installation of [ollama](https://github.com/ollama/ollama) (running on server mode), as well as [llm-ls](https://github.com/huggingface/llm-ls)

By default I have the configuration expecting ollama to have [stable-code-3b](https://huggingface.co/stabilityai/stable-code-3b) installed, which is one of the faster and better performing "in the middle" trained llms I have tested so far. Its fast and light enough it can run off CPU and still have decent response speed, especially if you keep the max tokens config low, as well as the max context low.

**Step 0 (optional):** If you dont have them already and want to use your gpu, ensure you have your cuda drivers installed (varies by OS and GPU a lot so you'll have to do some googling to figure this one out)  
**Step 1:** install Cargo: https://doc.rust-lang.org/cargo/getting-started/installation.html  
**Step 2:** Install llm-ls: `cargo install --branch main --git https://github.com/huggingface/llm-ls llm-ls`  
**Step 3:** install [ollama](https://github.com/ollama/ollama)  
**Step 4:** download the stable-code-3b .guff file [here](https://huggingface.co/stabilityai/stable-code-3b/tree/main) (I recommend the basic stable-code-3b.gguf file, its the largest but still wicked fast and has best accuracy/quality)  
**Step 5:** in the same directory as the .guff file you just downloaded, create `stable-code-3b.modelfile` with the following contents: `FROM <absolute path to your .gguf file you just downloaded>`  
**Step 6:** `ollama create stable-code-3b -f ./stable-code-3b.modelfile`  
**Step 7:** `ollama serve` (this might error saying the port is already in use, thats fine it means ollama is just already running)  
**Step 8:** if you open up a fresh instance of neovim, the autocomplete should start showing up while in edit mode!  
**Step 9:** feel free to configure `llm-config.lua` as needed if you want to lower/increase memory usage.  

# Keybinds

Keybinds are setup (aside from the handful that need to work in insert mode) to follow three steps to their chords.
1. `<leader>`, which is by default set to be Spacebar
2. Category key, which is a key for each category of commands.
3. Command key, which is the final key for the actual command itself.

For example, for the command "Format" below, the chord would be: 
* `<Spacebar>rf` for Leader -> [R]efactor -> [F]ormat

## [C]onsole
### (Normal Mode) [E]xecute current line
### (Visual Mode) [E]xecute current selection
For both of the above, requires tmux to be installed and neovim to be running inside a tmux session.

Will open up a new tmux panel (if one hasnt been opened yet) and pipe the current line (normal mode) or selected text (visual mode) into the tmux panel, executing it.

## [D]ebug
This section deals with all keybinds for interacting with the debugger
### Toggle [B]reakpoint
Toggles a breakpoint being set on the given line for nvim-dap debugger

### [C]lear Breakpoints
Clears all stored breakpoints in the current session for nvim-dap debugger

### [L]ist Breakpoints
Opens up a Telescope Picker for all existing breakpoints

### Build and [R]un
Starts nvim-dap, running the debugger for given configurations

## [F]iles
This section deals with all navigation to change files/buffers
### Search Current [B]uffers
Opens a Telescope Picker for all currently opened buffers

### Search [C]hanged Files
Opens a Telescope file picker, pulled from git history to list all modified files both from uncommitted changes, stashed changes, and unpushed changes

### Search [G]it Files
Opens a Telescope file picker for all files except for those ignored by .gitignore

### Search File [H]istory
Opens a Telescope file picker based on recently opened files in all neovim sessions

### Search files by g[r]ep
Opens a Grep fuzzy finder, that will find files with text that matches the grep fuzzy find.

## [G]it
This section deals with all registered hotkeys to help with git functionality

### [S]witch branches
Opens a Telescope picker to switch Git branches

### (Conflict) [H] - Prev conflict
Jumps to the previous detected merge conflict in the buffer

### (Conflict) [L] - Next conflict
Jumps to the next detected merge conflict in the buffer

### (Conflict) List [C]onflicts
Opens up a list of navigable detected merge conflicts in the buffer

### (Conflict) Choose [N]one
Chooses neither of the options for a merge conflict

### (Conflict) Choose [Y]ours
Chooses Your (Local/Current) changes in the merge conflict (Option A)

### (Conflict) Choose [T]heirs
Chooses Their (Remote/Incoming) changes in the merge conflict (Option B)

### (Conflict) choose [B]oth
Chooses both Local + Remote changes in the merge conflict (Options A+B)

## [H]arpoon
Keybinds related to Harpoon

### [H]arpoon!
Tags the given line as a Harpoon'd mark

### j/k
Navigate back/forward Harpoon marks

### a/e/i/o/u (respectively)
Jump to Harpoon marks 1 through 5

## [R]efactor
All keybinds related to modifying the buffer

### [A]ction Menu
Opens up the LSP's Action Menu at the given cursor

### [F]ormat
Formats the buffer's code

### [R]ename
Opens a prompt to rename the selected symbol (most LSPs will propogate this rename across all files, mileage will vary)

### [U]ndo History
Brings up a Telescope picker for all Undo history, including with a diff display for the changes! Uses the following default keybinds:

* `<CR>` - Yanks the specific discrete `++` changes into default register
* `<S-CR>` - Yanks the specific discrete `--` changes into default register
* `<C-CR>` - Reverts the buffer back to the selected point in History

## [S]earch
Handles keybinds involved in navigating based on the current buffer

### [D]efinitions
Opens a telescope picker to show all definitions of selected symbol. Will jump straight to the definition if only one exists.

### [F]ind
Opens up a fuzzy Grep for within the current buffer

### [I]mplementations
Opens up a telescope list for Implementations of the selected symbol. Will jump directly to the result if only one exists.

### [R]eferences
Opens up a telescope picker for all references of the selected symbol

### [S]ymbols
Opens up a telescope picker showing for declared symbols in the current buffer

### Diagnostic [W]arnings
Opens up a telescope picker for all diagnostic warnings of the current buffer

## [T]ests
Category for all keybinds regarding tests

### [D]ebug the nearest test
Triggers a debug session with nvim-dap of the nearest declared test to the cursor

### Test the nearest [F]ile
Runs the full test suite for the opened file

### Run the [N]earest test
Runs the nearest declared test to the cursor

### [S]ummarize test coverage
Shows a popup browseable test report coverage summary, based on a loaded in Test Coverage Report (loaded in via the above command)

# Examples
### Editting
![Example pic one of neovim setup](assets/Example1.png)
### LSP Integration and suggestions
![Example pic setup used in dotnet](assets/Example2.png)
### Dap UI running interactive debugger
![Example pic of setup running the dap ui](assets/Example3.png)
### Locally hosted LLM integration
![Example pic of setup integrating locally with an LLM](assets/Example4.png)
