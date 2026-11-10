# .config

Personal configuration files and dotfiles.

## Structure

```text
.config/
├── .gitignore
├── .vscode/
│   └── settings.json        # Shared by VS Code and Cursor
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
├── themes/
│   └── ohmyposh/
│       ├── blush.omp.json
│       └── cobalt.omp.json  # Active
├── windowsterminal/
│   └── settings.json
└── zsh/
    ├── .zshenv              # Every shell
    └── .zshrc               # Interactive shells
```

## Features

### Zsh Configuration (`zsh/`)

`.zshenv` (loaded by every shell, including scripts):

- **nvm node on PATH** - Resolves nvm's default version (following aliases like `lts/*`) so pnpm/tsx shims running under `/bin/sh` find `node`
- **`CODE_HOME`** - Points at `~/code`, where all git clones live
- **`~/.local/bin`** on PATH (uv and other user binaries)

`.zshrc` (interactive shells, no Oh My Zsh, targets <50ms startup):

- **Lazy-loaded nvm** with automatic `.nvmrc` switching on `cd`
- **nvm node wins** - Moved to the front of PATH last, ahead of Homebrew's `node`, with duplicate entries removed
- **Cached `compinit`** (rebuilt once a day) and a robbyrussell-style prompt with git branch
- **zsh-autosuggestions** from the Oh My Zsh plugin folder or Homebrew
- **Lazy-loaded zoxide** (`z`, `zi`) and **fzf** key bindings
- **Aliases** - `eza` for `ls`/`ll`/`la`/`tree`, `bat` for `cat`, `fd` for `find`, `repos` to jump to `$CODE_HOME`, and short git aliases (`g`, `ga`, `gc`, `gst`, `glog`, ...)
- **PATH** for bun, pnpm (`$PNPM_HOME/bin`), Java (OpenJDK 21) and the Android SDK (emulator, platform-tools, cmdline-tools)

### PowerShell Configuration (`powershell/Microsoft.PowerShell_profile.ps1`)

- **oh-my-posh** with the `cobalt` theme (async, so the prompt shows before git info loads)
- **PSReadLine** - Emacs keybindings, no bell, `Ctrl+d` deletes a character, history predictions in a list view
- **zoxide** for smart directory jumping (`z`, `zi`), replacing the old `z` module
- **fnm** for Node.js version management, switching versions on `cd` (skipped if already initialized)
- **PSFzf + Terminal-Icons** loaded after the prompt appears; `Ctrl+f` finds files, `Ctrl+r` searches history
- **`which`** - Prints the path of a command

### Oh My Posh Themes (`themes/ohmyposh/`)

- **`cobalt`** (active) - Single-line prompt: current folder in blue, git branch in orange-red, a red `✗` when the last command failed, then a green `❯`. Command duration on the right. Async rendering, and it reports the current directory to Windows Terminal so new tabs and panes open in the same folder
- **`blush`** - Soft pink/purple palette: full path, git branch in purple, a mint `❯`. Clock (`HH:MM:SS`) and command duration on the right

To switch themes, change the `--config` path in the PowerShell profile.

### Windows Terminal (`windowsterminal/settings.json`)

- **PowerShell 7** as the default profile, with **Hack Nerd Font Mono** for every profile
- **Visible profiles** - Command Prompt, Git Bash, Ubuntu (WSL, Campbell scheme, size 12) and the VS 2022 developer shells; Windows PowerShell, Azure Cloud Shell and the auto-generated Ubuntu entry are hidden
- **Copy as plain text** (no formatting), and selecting text doesn't copy it automatically
- **Keybindings** - `Ctrl+C`/`Ctrl+V` copy and paste, `Ctrl+Shift+D` or `Ctrl+Shift+T` duplicate the tab, `Alt+Shift+D` splits the pane, `Ctrl+Shift+F` finds

### VS Code / Cursor Settings (`.vscode/settings.json`)

- **One file for both editors** - VS Code and Cursor use identical settings
- **Prettier** as the default formatter, with format on save
- **Hack Nerd Font Mono**, **Vesper** theme, **Material Icon Theme**
- **Tailwind CSS** language mode for `.css` files
- **Auto-update imports** on file move (`js/ts.updateImportsOnFileMove.enabled`)
- Some keys only exist in one editor and show as unknown in the other: `workbench.agentsWindowButton.enabled` (Cursor only), `json.schemaDownload.trustedDomains` (VS Code only for now)

## Installation

To use these configurations:

1. **Zsh**: `ln -sf ~/.config/zsh/.zshenv ~/.zshenv && ln -sf ~/.config/zsh/.zshrc ~/.zshrc`
2. **VS Code / Cursor**: Copy `.vscode/settings.json` to `~/Library/Application Support/Code/User/settings.json` (VS Code) and `~/Library/Application Support/Cursor/User/settings.json` (Cursor)
3. **PowerShell**: Copy profile to `$PROFILE` (usually `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`)
4. **Oh My Posh themes**: Copy `.omp.json` files to `$env:POSH_THEMES_PATH`
5. **Windows Terminal**: Copy `windowsterminal/settings.json` to `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\`

## Requirements

Zsh (macOS):

- [nvm](https://github.com/nvm-sh/nvm)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
- [OpenJDK 21](https://formulae.brew.sh/formula/openjdk@21) (optional)
- [Android SDK](https://developer.android.com/studio) (optional)

PowerShell (Windows):

- [oh-my-posh](https://ohmyposh.dev/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fnm](https://github.com/Schniz/fnm)
- [fzf](https://github.com/junegunn/fzf)
- [PSFzf](https://github.com/kelleyma49/PSFzf)
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
