#!/usr/bin/env bash

# shellcheck disable=SC2155,SC1090

### XDG ENV
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

### MISC
export TERMINAL=$(gsettings get org.gnome.desktop.default-applications.terminal exec | tr -d "'")

### Paths
addpath() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		export PATH="$1${PATH:+":$PATH"}"
	fi
}

addpath "$HOME/.local/bin"
addpath "$HOME/.scripts"
addpath "$HOME/.local/scripts"
addpath "$HOME/.bun/bin"
addpath "$HOME/.cache.bun/bin"
addpath "$HOME/.cargo/bin"
addpath "$HOME/.deno/bin"
addpath "$HOME/go/bin"
addpath "$XDG_DATA_HOME/bob/nvim-bin"
addpath "$XDG_DATA_HOME/fnm"
