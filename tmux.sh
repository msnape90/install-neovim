#!/bin/bash

# attempts to gain sudo access if not already accquired

sudo -v

# exits the script if sudo access is not granted
sudo -n true 2>/dev/null || {
  echo "You must have the ability to run sudo commands to execute this script"
  exit 1
}

# base dirs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/tmux"

# config dirs
TMUX_DIR="$SCRIPT_DIR/.config/tmux"
TPM_DIR="$CONFIG_DIR/plugins/tpm"
RESURRECT_DIR="$HOME/.local/.tmux/resurrect"

# File Locations
LOC_TMUX_FILE="$CONFIG_DIR/tmux.conf"
LOC_RELOAD_FILE="$CONFIG_DIR/reload-tmux.conf"

# Config Files
CONFIG_FILE="$TMUX_DIR/tmux.conf"
RELOAD_FILE="$TMUX_DIR/reload-tmux.conf"

rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$RESURRECT_DIR"

sudo apt update && sudo apt install fzf tmux git -y

if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

cp "$CONFIG_FILE" "$LOC_TMUX_FILE"
cp "$RELOAD_FILE" "$LOC_RELOAD_FILE"

tmux -f "$LOC_TMUX_FILE" new-session -d -s bootstrap &&
  tmux send-keys 'sleep 1' C-m &&
  sleep 1 &&
  tmux -f "$LOC_TMUX_FILE" run-shell "$TPM_DIR/bin/plugins" &&
  sleep 3 &&
  tmux kill-session -t bootstrap
