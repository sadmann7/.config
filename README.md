# .config

Personal configuration files and dotfiles.

## Structure

```text
.config/
├── powershell/          # PowerShell configuration
│   └── Microsoft.PowerShell_profile.ps1
├── themes/              # Terminal themes
│   └── ohmyposh/        # Oh My Posh themes
│       ├── blush.omp.json   # Soft pink/purple palette
│       └── cobalt.omp.json  # Blue dev theme (active)
├── windowsterminal/     # Windows Terminal configuration
│   └── settings.json
├── .vscode/             # VS Code + Cursor configuration (shared)
│   └── settings.json
└── zsh/                 # Zsh shell configuration
    ├── .zshenv          # Env for every shell: PATH, CODE_HOME, nvm node
    └── .zshrc           # Interactive shell: prompt, aliases, lazy loaders
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

### PowerShell Configuration

- **oh-my-posh** with `cobalt` theme (async prompt for fast startup)
- **zoxide** for smart directory jumping (`z`)
- **fnm** for Node.js version management (guarded to skip re-init)
- **PSFzf + Terminal-Icons** deferred so the prompt appears first
- **`which` utility** for resolving command paths

### Oh My Posh Themes

- **`blush`** — soft pink/purple palette, clock on the right
- **`cobalt`** — blue dev theme with exit code and command timing (active)

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

- [nvm](https://github.com/nvm-sh/nvm)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
- OpenJDK 21 and the Android SDK (optional, for Android work)
