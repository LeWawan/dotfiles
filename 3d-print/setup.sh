#!/usr/bin/env bash
# Setup symlinks for 3D printing configs (BambuStudio, OrcaSlicer)
# - Detects platform and uses correct target path
# - Only adds missing files (never deletes)
# - Symlinks point from target -> dotfiles (modifications sync back)

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Platform-specific paths
# macOS: ~/Library/Application Support/<app>/
# Linux: ~/.config/<app>/
get_target_dir() {
    local app="$1"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "$HOME/Library/Application Support/$app"
    else
        echo "$HOME/.config/$app"
    fi
}

# Get source dir in dotfiles (platform-aware)
get_source_dir() {
    local app="$1"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "$SCRIPT_DIR/Library/Application Support/$app"
    else
        echo "$SCRIPT_DIR/.config/$app"
    fi
}

# Symlink files from source to target, only if missing
link_app() {
    local app="$1"
    local source_dir target_dir

    source_dir="$(get_source_dir "$app")"
    target_dir="$(get_target_dir "$app")"

    if [[ ! -d "$source_dir" ]]; then
        if [[ "$(uname -s)" != "Darwin" ]]; then
            echo "[3d-print] WARNING: $app Linux config missing!"
            echo "  Expected: $source_dir"
            echo "  TODO: Create .config/$app/ in 3d-print/ with your Linux configs"
        else
            echo "[3d-print] $app: no config in dotfiles for this platform, skipping"
        fi
        return
    fi

    echo "[3d-print] $app: $source_dir -> $target_dir"

    # Find all files in source and create symlinks
    while IFS= read -r -d '' src_file; do
        # Get relative path from source_dir
        rel_path="${src_file#$source_dir/}"
        target_file="$target_dir/$rel_path"
        target_parent="$(dirname "$target_file")"

        # Create parent dirs if needed
        if [[ ! -d "$target_parent" ]]; then
            mkdir -p "$target_parent"
            echo "  [mkdir] $target_parent"
        fi

        # Skip if target already exists (file, symlink, or dir)
        if [[ -e "$target_file" || -L "$target_file" ]]; then
            # Check if it's already a symlink to our source
            if [[ -L "$target_file" && "$(readlink "$target_file")" == "$src_file" ]]; then
                echo "  [ok] $rel_path"
            else
                echo "  [skip] $rel_path (exists)"
            fi
            continue
        fi

        # Create symlink
        ln -s "$src_file" "$target_file"
        echo "  [link] $rel_path"
    done < <(find "$source_dir" -type f -print0)
}

# Main
echo "=== 3D Print Config Setup ==="
echo "Platform: $(uname -s)"
echo ""

link_app "BambuStudio"
# link_app "OrcaSlicer"  # Uncomment when added

echo ""
echo "Done!"
