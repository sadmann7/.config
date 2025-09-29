# .config

Personal configuration files and dotfiles.

## Structure

```text
.config/
├── powershell/          # PowerShell configuration
│   └── Microsoft.PowerShell_profile.ps1
├── themes/              # Terminal themes
│   └── ohmyposh/        # Oh My Posh themes
│       ├── custom-one.omp.json
│       └── custom-two.omp.json
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

- Custom PowerShell profile for Windows environments

### Oh My Posh Themes

- Custom terminal themes for enhanced prompt styling

### VS Code Settings

- Personal VS Code configuration and preferences

## Installation

To use these configurations:

1. **Zsh**: `ln -sf ~/.config/zsh/.zshrc ~/.zshrc`
2. **VS Code**: Copy settings from `vscode/settings.json` to your VS Code settings
3. **PowerShell**: Copy profile to your PowerShell profile location
4. **Oh My Posh**: Use themes with `oh-my-posh init pwsh --config ~/.config/themes/ohmyposh/custom-one.omp.json`

## Requirements

- [oh my zsh](https://ohmyz.sh/)
- [nvm](https://github.com/nvm-sh/nvm)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
