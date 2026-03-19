#!/bin/bash

# attempts to gain sudo access if not already accquired

sudo -v

# exits the script if sudo access is not granted
sudo -n true 2>/dev/null || {
  echo "You must have the ability to run sudo commands to execute this script"
  exit 1
}

CONFIG_DIR="$HOME/.config/tmux"
TMUX_CONF="$CONFIG_DIR/tmux.conf"
TPM_DIR="$CONFIG_DIR/plugins/tpm"

sudo apt update && sudo apt install tmux git

mkdir -p "$CONFIGDIR"

if [ ! -d "$TPM_DIR"]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

mv ./.config/tmux/reload-tmux.conf "$CONFIG_DIR/reload-tmux.conf"
mv ./.config/tmux/tmux.conf "$TMUX_CONF"

tmux -f "$TMUX_CONF" new-session -d -s bootstrap 'sleep 1'
tmux -f "$TMUX_CONF" run-shell "$TPM_DIR/bin/install_plugins"
tmux kill-session -t bootstrap
