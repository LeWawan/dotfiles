# dotfiles

Arch Linux (Hyprland) + macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

```bash
git clone --recursive git@github.com:LeWawan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./run
```

`./run` is an interactive installer powered by [gum](https://github.com/charmbracelet/gum).

## Packages

Each directory is a stow package that symlinks into `$HOME`.

| Package | Description | Platforms |
|---------|-------------|-----------|
| `bash` | Shell config, aliases, completions, [mise](https://mise.jdx.dev/) config | all |
| `bin` | Scripts, install helpers, deps-scripts | all |
| `nvim` | Neovim ([submodule](https://github.com/LeWawan/nvim)), lazygit, copilot | all |
| `tmux` | Tmux + tpm plugins | all |
| `omarchy` | Hyprland, Waybar, Walker, Alacritty, Btop, Starship | Linux |
| `macos` | AeroSpace, Sketchybar, Alacritty | macOS |
| `coolercontrol` | Fan profiles (stowed to `/`, see [README](coolercontrol/README.md)) | Arch |

## Install Scripts

All in `bin/core/deps-scripts/`, built on a shared [`_helpers.sh`](bin/core/deps-scripts/_helpers.sh):

| Script | What it does |
|--------|-------------|
| `install-deps` | System tools: ripgrep, fd, eza, stow, direnv, bash-completion |
| `install-dev-env <rt>` | Dev runtimes via mise: `node`, `pnpm`, `ni`, `rust`, `lua` |
| `install-nvim` | Neovim (pacman on Arch, source build elsewhere) |
| `install-tmux` | Tmux + tpm |
| `install-coolercontrol` | CoolerControl + cctv (Arch only) |

## Shell

Bash with [Starship](https://starship.rs/) prompt. Config is modular:

`bashrc` > `bash_envs` > `bash_init` > `bash_aliases` > `bash_shell` > `bash_personal` > `bash_inputrc`

## Prerequisites

Install before running: `gum`, `fzf`, `bat`.
