# wawan's dotfiles

Cross-platform dotfiles for **Arch Linux (Hyprland/Omarchy)** and **macOS**, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone --recursive git@github.com:LeWawan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./run
```

The interactive installer (powered by [gum](https://github.com/charmbracelet/gum)) lets you pick what to set up:

- **Stow dotfiles** -- symlink all configs to `~`
- **Install dev tools** -- Node, pnpm, ni, Rust, Lua (via [mise](https://mise.jdx.dev/))
- **Install system deps** -- ripgrep, fd, eza, stow, direnv, etc.
- **Install neovim / tmux**
- **Snapshot omarchy** -- backup current Hyprland/Waybar configs into the repo
- **Install CoolerControl** -- fan control (Arch only)

## Structure

```
.dotfiles/
├── bash/          # Shell config (bashrc, aliases, completions, env) + mise config
├── bin/           # Custom scripts & install helpers
│   ├── core/      #   Setup/clean env, dependency installers
│   │   └── deps-scripts/
│   │       ├── _helpers.sh        # Shared helpers (install_pkg, log_*, platform detection)
│   │       ├── install-deps       # System tools
│   │       ├── install-dev-env    # Dev runtimes (node, pnpm, ni, rust, lua)
│   │       ├── install-nvim       # Neovim
│   │       ├── install-tmux       # Tmux + tpm
│   │       └── install-coolercontrol  # CoolerControl (Arch only)
│   └── .local/    #   tmux-sessionizer, omarchy-snapshot, wawan-config
├── macos/         # macOS-only: Alacritty, AeroSpace, Sketchybar
├── nvim/          # Neovim (git submodule) + related tool configs (lazygit, copilot)
├── omarchy/       # Linux-only: Hyprland, Waybar, Walker, Alacritty, Btop
├── tmux/          # Tmux config with tpm plugins
├── coolercontrol/ # CoolerControl fan profiles (Arch, stowed to / not $HOME)
├── run            # Main interactive installer
└── wall.{jpg,png} # Wallpapers
```

Each top-level directory is a **stow package** -- `stow bash` symlinks `bash/.bashrc` to `~/.bashrc`, etc.

### Platform-specific packages

| Package | Linux | macOS | Target |
|---------|:-----:|:-----:|--------|
| bash, bin, nvim, tmux | x | x | `$HOME` |
| omarchy | x | | `$HOME` |
| macos | | x | `$HOME` |
| coolercontrol | x | | `/` (system, see [README](coolercontrol/README.md)) |

## Install Scripts

All install scripts live in `bin/core/deps-scripts/` and source a shared `_helpers.sh` that provides:

- **`install_pkg`** -- cross-platform package install (pacman/apt/brew)
- **`install_dev_runtime`** -- install via omarchy-install-dev-env or mise fallback
- **`require_cmd`** -- assert a command exists before proceeding
- **`log_info`**, **`log_warn`**, **`log_error`** -- consistent `[install]` prefixed logging
- **`is_linux`**, **`is_macos`**, **`is_arch`** -- platform detection

Dev runtimes are installed through a single unified script:

```bash
# Install individual runtimes
bash bin/core/deps-scripts/install-dev-env node
bash bin/core/deps-scripts/install-dev-env pnpm
bash bin/core/deps-scripts/install-dev-env ni
bash bin/core/deps-scripts/install-dev-env rust
bash bin/core/deps-scripts/install-dev-env lua
```

## Shell (Bash)

Modular config split into:

| File | Role |
|------|------|
| `.bashrc` | Entry point, sources everything, binds Ctrl+F to tmux-sessionizer |
| `.bash_envs` | `EDITOR=nvim`, `BAT_THEME`, `XDG_CONFIG_HOME` |
| `.bash_init` | Homebrew, mise, Starship prompt, fzf |
| `.bash_aliases` | Git shortcuts (`g/ga/gs/gc/gp/gl/nah`), eza (`ls/lt`), nav (`../...`) |
| `.bash_shell` | History (32K), completions, hashing off for mise |
| `.bash_personal` | Locale, fortune/cowsay on startup |
| `.bash_inputrc` | Readline: case-insensitive, arrow history search, menu-complete |

Runtime versions managed by [mise](https://mise.jdx.dev/) -- global config in `bash/.config/mise/config.toml`.

## Neovim

Managed as a separate repo ([LeWawan/nvim](https://github.com/LeWawan/nvim)) via git submodule.

Plugin manager: **lazy.nvim**. Includes LSP, Telescope, Treesitter, Oil, Git integration, AI, and more.

## Tmux

- Prefix: `Ctrl+B`
- Vi-mode copy with platform clipboard (`xclip`/`pbcopy`)
- Vim-like navigation: `hjkl` for panes, `s`/`v` for splits
- `Ctrl+F` -> tmux-sessionizer (fuzzy project switcher)
- Status bar: hostname, kernel, CPU/RAM, battery, time
- Plugins via tpm: tmux-sensible, tmux-battery, tmux-mem-cpu-load

## Linux Desktop (Omarchy/Hyprland)

- **WM**: Hyprland with custom bindings (`Super+Shift` for apps, `Ctrl+Super+hjkl` for workspaces)
- **Bar**: Waybar
- **Launcher**: Walker
- **Terminal**: Alacritty (JetBrainsMono Nerd Font, theme imported from Omarchy)
- **Monitor**: DP-1 @ 2560x1440 180Hz

## macOS

- **WM**: AeroSpace (tiling, `Ctrl+Alt+hjkl` workspaces)
- **Bar**: Sketchybar (Kanagawa colors)
- **Terminal**: Alacritty (Kanagawa theme, GeistMono Nerd Font)

## Key Utilities

| Tool | Purpose |
|------|---------|
| `tmux-sessionizer` | Fuzzy-find projects in `~/Lab/` and switch tmux sessions |
| `wawan-config` | Shortcut to run the dotfiles installer |
| `omarchy-snapshot` | Copy current desktop configs into the stow package |
| `omarchy-toggle-brightness` | Night mode brightness toggle |
| `vpns` | WireGuard VPN management |
| `opentrack-launcher` | Head tracking for gaming (OpenTrack) |

## Dependencies

Core tools installed by `./run` -> "Install system deps":

`stow` `ripgrep` `fd` `eza` `direnv` `fortune` `cowsay` `bash-completion`

Prerequisites (install manually before running):

`gum` (required by `./run`), `fzf`, `bat`

Runtime versions managed by [mise](https://mise.jdx.dev/).
