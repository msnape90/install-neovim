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
SYS_DIR_CONFIG="$HOME/.config"
SYS_LOCAL_BIN="$HOME/.local/bin"
SCRIPT_DIR_CONFIG="$SCRIPT_DIR/.config"

# script dirs
SCRIPT_DIR_TMUX="$SCRIPT_DIR_CONFIG/tmux"

# system dirs
SYS_DIR_TPM="$SYS_DIR_CONFIG/tmux/plugins/tpm"
SYS_DIR_TMUX="$SYS_DIR_CONFIG/tmux"
SYS_DIR_SESSIONIZER="$SYS_DIR_CONFIG/tmux-sessionizer"
# SYS_RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"

# script file locations
SCRIPT_FILE_TMUX_CONF="$SCRIPT_DIR_TMUX/tmux.conf"
SCRIPT_FILE_RELOAD_TMUX_CONF="$SCRIPT_DIR_TMUX/reload-tmux.conf"

# system file locations
SYS_FILE_TMUX_CONF="$SYS_DIR_TMUX/tmux.conf"
SYS_FILE_RELOAD_TMUX_CONF="$SYS_DIR_TMUX/reload-tmux.conf"
SYS_FILE_TPM_INSTALL_PLUGINS="$SYS_DIR_TPM/bin/install_plugins"
SYS_FILE_SESSIONIZER_BIN="$SYS_LOCAL_BIN/tmux-sessionizer"

# create any needed dirs
rm -rf "$SYS_DIR_TMUX"
mkdir -p "$SYS_DIR_TMUX"
# mkdir -p "$SYS_RESURRECT_DIR"
mkdir -p "$SYS_LOCAL_BIN"

# install required packages
sudo apt update && sudo apt install fzf tmux git -y

# download requied git repos
if [ ! -d "$SYS_DIR_TPM" ]; then
  git clone https://github.com/tmux-plugins/tpm "$SYS_DIR_TPM"
fi

if [ ! -d "$SYS_DIR_SESSIONIZER" ]; then
  git clone https://github.com/ThePrimeagen/tmux-sessionizer "$SYS_DIR_SESSIONIZER"
fi

# copy the config and execution files
cp "$SCRIPT_FILE_TMUX_CONF" "$SYS_FILE_TMUX_CONF"
cp "$SCRIPT_FILE_RELOAD_TMUX_CONF" "$SYS_FILE_RELOAD_TMUX_CONF"
cp "$SYS_DIR_SESSIONIZER/tmux-sessionizer" "$SYS_FILE_SESSIONIZER_BIN"

# loads tmux and installs plugins
tmux -f "$SYS_FILE_TMUX_CONF" new-session -d -s bootstrap
tmux send-keys 'sleep 1' C-m &&
  sleep 1
tmux -f "$SYS_FILE_TMUX_CONF" run-shell "$SYS_FILE_TPM_INSTALL_PLUGINS" &&
  sleep 3
tmux kill-session -t bootstrap

# creates the required keybindings and paths
LINETOADD="bind -x '\"\\C-f\": \"tmux-sessionizer\"'"
grep -qxF "$LINETOADD" "$HOME/.bashrc" || echo "$LINETOADD" >>"$HOME/.bashrc"

LINETOADD='export PATH="$PATH:$HOME/.local/bin"'
grep -qxF "$LINETOADD" "$HOME/.bashrc" || echo "$LINETOADD" >>"$HOME/.bashrc"

source "$HOME/.bashrc"
