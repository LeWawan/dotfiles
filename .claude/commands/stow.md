Stow or unstow a dotfiles package.

Usage: /stow [package] or /stow -D [package]

Arguments: $ARGUMENTS

Steps:
1. Parse the arguments. If `-D` flag is present, this is an unstow operation. The package name is the remaining argument.
2. Valid packages are the top-level directories that are stow packages: bash, bin, nvim, tmux, macos, omarchy, coolercontrol. If no package is given, list all available packages and ask which one(s) to stow.
3. Check platform compatibility: `macos` only on Darwin, `omarchy`/`coolercontrol` only on Linux.
4. Run the appropriate stow command from the repo root (`/home/wawan/.dotfiles`):
   - **coolercontrol** is special -- it targets `/` not `$HOME`:
     - Stow: `sudo stow -t / --adopt coolercontrol` then `git checkout -- coolercontrol`
     - Unstow: `sudo stow -t / -D coolercontrol`
   - All other packages target `$HOME` (default):
     - Stow: `stow --adopt <package>` then `git checkout -- <package>` to restore repo versions
     - Unstow: `stow -D <package>`
5. If the package is `omarchy`, remind the user to run `hyprctl reload`.
6. Show which symlinks were created/removed.
