# CLAUDE.md -- dotfiles repo context

## Repo Overview

Cross-platform dotfiles for Arch Linux (Hyprland/Omarchy) and macOS, managed with GNU Stow. The `run` script is the main interactive installer (requires `gum`).

## Architecture

Each top-level directory is a **stow package** that maps directly to `$HOME`:
- `bash/` -> shell config (modular: envs, aliases, init, shell, personal, inputrc, completions)
- `bin/` -> custom scripts (`~/.local/bin/`) and install helpers (`bin/core/`)
- `tmux/` -> tmux config with tpm plugins
- `nvim/` -> neovim config (git submodule -> LeWawan/nvim, DO NOT edit inline)
- `macos/` -> macOS only: Alacritty, AeroSpace, Sketchybar
- `omarchy/` -> Linux only: Hyprland, Waybar, Walker, Alacritty, Btop, Fastfetch, Starship
- `coolercontrol/` -> CoolerControl fan profiles (Arch) -- **stowed to `/` not `$HOME`** (uses `sudo stow -t /`)

Platform detection: `bin/core/env` sets `STOW_FOLDERS` based on `uname -s` (Darwin -> macos, Linux -> omarchy). Note: `coolercontrol` is NOT in `STOW_FOLDERS` -- it's handled separately in `setup-env` with `sudo stow -t /` because its files go to `/etc/coolercontrol/`.

## Key Conventions

- **Stow structure**: files inside a package mirror `$HOME`. Example: `bash/.bashrc` -> `~/.bashrc`, `tmux/.config/tmux/tmux.conf` -> `~/.config/tmux/tmux.conf`. Exception: `coolercontrol/` targets `/` (system-level).
- **XDG compliance**: configs go under `.config/` inside stow packages.
- **Neovim is a submodule**: always use `git submodule update` to sync, never edit files in `nvim/.config/nvim/` directly from this repo.
- **Shell is bash** (not zsh). Prompt is Starship. Tool versions managed by mise.
- **Commit style**: conventional commits with scope -- `feat(omarchy):`, `fix(bash):`, `chore(nvim):`, `refactor:`.

## Working with this repo

```bash
# Stow a single package
stow bash

# Unstow
stow -D bash

# Full setup (interactive)
./run

# Snapshot current Hyprland/Waybar/etc configs into omarchy/
bash bin/.local/scripts/omarchy-snapshot
```

## Platform-specific notes

### Linux (Arch + Hyprland)
- Hyprland config is modular: `omarchy/.config/hypr/` has separate files for bindings, monitors, input, looknfeel, autostart.
- The base Hyprland/Omarchy defaults are sourced first, then user overrides are applied.
- After stowing omarchy, run `hyprctl reload` to apply changes.
- Custom scripts in `omarchy/.local/bin/`: gaming launchers (omarchy-gaming-install, omarchy-gaming-launch, omarchy-gaming-launch-opentrack), brightness toggle, opentrack-launcher (Python), vpns (WireGuard management).

### macOS
- AeroSpace for tiling WM, Sketchybar for status bar.
- Alacritty uses `/opt/homebrew/bin/bash` as shell.
- Sketchybar has its own items/ and plugins/ directories with shell scripts.

## Install scripts (bin/core/deps-scripts/)

Each script auto-detects the package manager (pacman/apt/brew) and installs accordingly:
- `install-deps` -- system tools (ripgrep, fd, eza, stow, direnv, bash-completion, etc.). Note: `bat`, `fzf`, and `gum` are NOT included -- they must be installed separately.
- `install-nvim` -- neovim (pacman on Arch, build from source elsewhere)
- `install-tmux` -- tmux + tpm
- `install-node-env`, `install-go`, `install-rust`, `install-lua` -- dev runtimes via mise

## Do NOT

- Edit files inside `nvim/.config/nvim/` from this repo (it's a submodule).
- Use zsh syntax in bash configs.
- Hardcode paths that differ between macOS and Linux without platform checks.
- Add secrets, credentials, or `.env` files.
