#!/bin/bash

# attempts to gain sudo access if not already accquired

sudo -v

# exits the script if sudo access is not granted
sudo -n true 2>/dev/null || {
  echo "You must have the ability to run sudo commands to execute this script"
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# File Locations
CONFIG_DIR="$HOME/.config/tmux"
TMUX_CONF="$CONFIG_DIR/tmux.conf"
TPM_DIR="$CONFIG_DIR/plugins/tpm"

# Config Files
FILE_DIR="$SCRIPT_DIR/.config/tmux"
CONFIG_FILE="$FILE_DIR/tmux.conf"
RELOAD_FILE="$FILE_DIR/reload-tmux.conf"

sudo apt update && sudo apt install tmux git -y

mkdir -p "$CONFIGDIR"

if [ ! -d "$TPM_DIR"]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

rm -rf "$CONFIG_DIR"
mkdir "$CONFIG_DIR"

cp "$CONFIG_FILE" "$TMUX_CONF"
cp "$RELOAD_FILE" "$CONFIG_DIR/reload-tmux.conf"

tmux -f "$TMUX_CONF" new-session -d -s bootstrap 'sleep 1'
tmux -f "$TMUX_CONF" run-shell "$TPM_DIR/bin/install_plugins"
tmux kill-session -t bootstrap
