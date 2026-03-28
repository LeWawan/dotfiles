Snapshot current system configs into the omarchy stow package.

This captures the live configs from ~/.config/ into the repo's omarchy/ directory so they can be version-controlled and stowed on other machines.

Steps:
1. Confirm we're on Linux: `uname -s` must be "Linux".
2. Run the snapshot script: `bash /home/wawan/.dotfiles/bin/.local/scripts/omarchy-snapshot`
3. Show `git status` and `git diff --stat` so the user can see what changed.
4. Ask if the user wants to commit the snapshot.
