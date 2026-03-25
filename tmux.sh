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
sys_dir_config="$HOME/.config"
script_dir_config="$SCRIPT_DIR/.config"

# script dirs
TMUX_DIR="$SCRIPT_DIR/.config/tmux"
script_dir_tmux="$script_dir_config/tmux"

# system dirs
TPM_DIR="$CONFIG_DIR/plugins/tpm"
sys_dir_tpm="$sys_dir_config/tmux/plugins/tpm"
sys_dir_tmux="$sys_dir_config/tmux"
# RESURRECT_DIR="$HOME/.local/.tmux/resurrect"

# script file locations
CONFIG_FILE="$TMUX_DIR/tmux.conf"
RELOAD_FILE="$TMUX_DIR/reload-tmux.conf"
script_file_tmux_conf="$script_dir_tmux/tmux.conf"
script_file_reload_tmux_conf="$script_dir_tmux/reload-tmux.conf"

# system file locations
LOC_TMUX_FILE="$CONFIG_DIR/tmux.conf"
LOC_RELOAD_FILE="$CONFIG_DIR/reload-tmux.conf"
sys_file_tmux_conf="$sys_dir_tmux/tmux.conf"
sys_file_reload_tmux_conf="$sys_dir_tmux/reload-tmux.conf"
sys_file_tpm_install_plugins="$sys_dir_tpm/bin/install_plugins"

rm -rf "$sys_dir_tmux"
mkdir -p "$sys_dir_tmux"
# mkdir -p "$RESURRECT_DIR"

sudo apt update && sudo apt install fzf tmux git -y

if [ ! -d "$sys_dir_tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

cp "$script_file_tmux_conf" "$sys_file_tmux_conf"
cp "$script_file_reload_tmux_conf" "$sys_file_reload_tmux_conf"

tmux -f "$sys_file_tmux_conf" new-session -d -s bootstrap
tmux send-keys 'sleep 1' C-m &&
  sleep 1
tmux -f "$sys_file_tmux_conf" run-shell "$sys_file_tpm_install_plugins" &&
  sleep 3
tmux kill-session -t bootstrap
