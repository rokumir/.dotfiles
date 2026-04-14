#!/usr/bin/env bash

# shellcheck disable=SC2155,SC1090

### XDG ENV
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

### MISC
if command -v gsettings >/dev/null; then
	export TERMINAL=$(gsettings get org.gnome.desktop.default-applications.terminal exec | tr -d "'")
fi
