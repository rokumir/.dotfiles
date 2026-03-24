#!/usr/bin/env bash

# XDG ENV
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Scripts
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:$HOME/.local/scripts
export PATH=$PATH:$HOME/.bun/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.deno/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$XDG_DATA_HOME/bob/nvim-bin
export PATH=$PATH:$XDG_DATA_HOME/fnm
