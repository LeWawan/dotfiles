#!/usr/bin/env bash
# Shared helpers for install scripts.
# Source this at the top of each install-* script:
#   source "$(dirname "$0")/_helpers.sh"

set -euo pipefail

log_info()  { echo "[install] $*"; }
log_warn()  { echo "[install] WARN: $*" >&2; }
log_error() { echo "[install] ERROR: $*" >&2; }

# Detect package manager once
if command -v pacman &>/dev/null; then
  _PKG_MGR="pacman"
elif command -v apt-get &>/dev/null; then
  _PKG_MGR="apt"
elif command -v brew &>/dev/null; then
  _PKG_MGR="brew"
else
  _PKG_MGR=""
fi

# Install system packages (cross-platform)
install_pkg() {
  if [[ -z "$_PKG_MGR" ]]; then
    log_error "No supported package manager found (pacman/apt/brew)."
    exit 1
  fi
  case "$_PKG_MGR" in
    pacman)  sudo pacman -S --noconfirm --needed "$@" ;;
    apt)     sudo apt-get install -y "$@" ;;
    brew)    brew install "$@" ;;
  esac
}

# Check if a command exists
require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    log_error "'$1' is required but not installed."
    exit 1
  fi
}

# Install a dev runtime via omarchy-install-dev-env or mise fallback
install_dev_runtime() {
  local runtime="$1"
  if command -v omarchy-install-dev-env &>/dev/null; then
    log_info "Using omarchy-install-dev-env..."
    omarchy-install-dev-env "$runtime"
  elif command -v mise &>/dev/null; then
    log_info "Using mise..."
    mise use --global "${runtime}@latest"
  else
    log_error "Neither omarchy-install-dev-env nor mise found."
    log_error "Install mise first: https://mise.jdx.dev"
    exit 1
  fi
}

is_linux() { [[ "$(uname -s)" == "Linux" ]]; }
is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_arch()  { command -v pacman &>/dev/null; }
