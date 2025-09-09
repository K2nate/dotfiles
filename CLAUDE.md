# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS/Linux dotfiles repository that automates system setup and configuration management using:
- **Homebrew** for package management
- **GNU Stow** for dotfile symlinking
- **mise** for development tool version management
- **Shell scripts** for system configuration

## Key Commands

### Initial Setup
```bash
# One-line install (runs full setup)
curl -L https://raw.githubusercontent.com/K2nate/dotfiles/main/install.sh | sh

# Or clone and run locally
./install.sh
```

### Makefile Commands
```bash
# Install/update Homebrew packages
make homebrew

# Apply macOS system preferences
make macos

# Re-link dotfiles with stow
make link
```

### Manual Operations
```bash
# Install packages from Brewfile
brew bundle --verbose --cleanup --file="./Brewfile"

# Re-stow dotfiles (handles conflicts)
stow --verbose --restow --adopt --target="$HOME" home

# Run macOS configuration
bash ./scripts/setup-macos.sh
```

## Architecture & Structure

### Installation Flow
1. **install.sh**: Main entry point that orchestrates the entire setup
   - Detects OS (macOS/Linux)
   - Requests admin privileges (macOS)
   - Installs Xcode CLI tools (macOS)
   - Sets up Homebrew
   - Clones this repository via `ghq`
   - Runs `brew bundle` from Brewfile
   - Symlinks dotfiles using `stow`
   - Installs dev tools via `mise`

2. **Brewfile**: Declarative package list for Homebrew
   - System utilities (stow, bat, eza, ripgrep, etc.)
   - Development tools (mise, gh, git)
   - GUI applications (Ghostty, Arc, VSCode, Zed, etc.)
   - Fonts (Hack Nerd Font)

3. **scripts/setup-macos.sh**: macOS-specific system preferences
   - Dark mode, Finder settings
   - Dock behavior
   - Keyboard repeat rates
   - Menu bar configuration

### Dotfile Management
- Uses GNU Stow for symlink management
- Dotfiles should be placed in `home/` directory structure
- Stow creates symlinks from `home/*` to `$HOME/*`
- Pre-removes known conflicting files before stowing

### Development Tools
- **mise** manages language versions (replaces asdf/nvm/rbenv)
- Tools are installed via `mise install` after Homebrew setup
- Configuration would be in `.mise.toml` or `.tool-versions` (not present yet)

## Important Notes

### Stow Behavior
- Uses `--restow` flag to cleanly recreate symlinks
- `--adopt` flag in Makefile merges existing files into repo
- Pre-removes common dotfiles (.gitconfig, .zshrc, etc.) to avoid conflicts

### macOS Settings
- Requires admin privileges for system preference changes
- Settings take effect after killing affected processes (Finder, Dock, SystemUIServer)
- Full reboot recommended after initial setup

### CI Considerations
- Script detects CI environment and skips sudo prompts
- Supports both interactive and non-interactive Homebrew installation

## Development Workflow

When modifying this repository:

1. **Adding new packages**: Edit `Brewfile` and run `make homebrew`
2. **Adding dotfiles**: Place in `home/` directory structure and run `make link`
3. **Updating macOS settings**: Edit `scripts/setup-macos.sh` and run `make macos`
4. **Testing changes**: The install script is idempotent and can be re-run safely

## Shell Environment

The repository sets up:
- **Zsh** as the default shell (with syntax highlighting)
- **Starship** prompt for cross-shell theming
- **Zellij** as terminal multiplexer
- **Ghostty** as the terminal emulator
- Various CLI improvements (bat for cat, eza for ls, ripgrep for grep)