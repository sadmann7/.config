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
├── vscode/              # VS Code configuration
│   └── settings.json
└── zsh/                 # Zsh shell configuration
    └── .zshrc           # Main zsh config with nvm setup
```

## Features

### Zsh Configuration (`zsh/.zshrc`)

- **nvm integration** - Automatic Node.js version management
- **Auto .nvmrc detection** - Switches Node versions based on project `.nvmrc` files
- **tsx temp directory fix** - Resolves permission issues with tsx command
- **Oh My Zsh** with plugins: git, z, zsh-autosuggestions, brew, macos, node, npm, vscode
- **Modern aliases** - Uses `eza`, `bat`, `fd` for enhanced terminal experience
- **Database seeding alias** - `db:seed` command for easy database operations

### PowerShell Configuration

- **oh-my-posh** with `cobalt` theme (async prompt for fast startup)
- **zoxide** for smart directory jumping (`z`)
- **fnm** for Node.js version management (guarded to skip re-init)
- **PSFzf + Terminal-Icons** deferred so the prompt appears first
- **`which` utility** for resolving command paths

### Oh My Posh Themes

- **`blush`** — soft pink/purple palette, clock on the right
- **`cobalt`** — blue dev theme with exit code and command timing (active)

### VS Code Settings

- Personal VS Code configuration and preferences

## Installation

To use these configurations:

1. **Zsh**: `ln -sf ~/.config/zsh/.zshrc ~/.zshrc`
2. **VS Code**: Copy settings from `vscode/settings.json` to your VS Code settings
3. **PowerShell**: Copy profile to `$PROFILE` (usually `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`)
4. **Oh My Posh themes**: Copy `.omp.json` files to `$env:POSH_THEMES_PATH`
5. **Windows Terminal**: Copy `windowsterminal/settings.json` to `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\`

## Requirements

- [oh my zsh](https://ohmyz.sh/)
- [nvm](https://github.com/nvm-sh/nvm)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
