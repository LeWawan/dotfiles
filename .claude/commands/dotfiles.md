Analyze the current state of the dotfiles repo and provide a status report.

Do the following steps:

1. Run `git status` and `git diff --stat` to see pending changes.
2. Check if the nvim submodule is up to date: `git submodule status`.
3. Verify stow package integrity: for each stow folder (bash, bin, nvim, tmux, and the platform-specific one), check that the expected symlinks exist in $HOME.
4. List any new untracked files that might need to be added or gitignored.
5. Summarize the current state concisely:
   - What's changed since last commit
   - Any broken symlinks or missing configs
   - Any untracked files to deal with
   - Platform: Linux (omarchy) or macOS

Keep the output short and actionable.
