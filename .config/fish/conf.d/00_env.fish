set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_STATE_HOME ~/.local/state
set -gx XDG_RUNTIME_DIR /run/user/1000

fish_add_path -g ~/.local/bin # third parties' scripts
fish_add_path -g ~/.bun/bin ~/.cache/.bun/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.deno/bin
fish_add_path -g $XDG_DATA_HOME/bob/nvim-bin

fish_add_path -g $XDG_DATA_HOME/fnm
type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source

if type -q go
    set -gx GOPATH ~/go
    fish_add_path -g $GOPATH/bin
end

set -gx TERMINFO $XDG_CONFIG_HOME/terminfo
set -gx TERM wezterm # enable undercurl .terminfo/w/wezterm
set -gx GIT_EDITOR nvim
set -gx EDITOR vi
set -gx PAGER bat

## ---------------------------------------

# Rokumir Home
set -gx RH_NOTE ~/documents/nihil
set -gx RH_PROJECT ~/documents/projects
set -gx RH_WORK ~/documents/works
set -gx RH_THROWAWAY ~/documents/throwaways
set -gx RH_SCRIPT ~/.scripts

fish_add_path -g $RH_SCRIPT

set -gx RH_VAULT \
    $RH_WORK \
    $RH_PROJECT \
    $RH_THROWAWAY \
    $RH_SCRIPT \
    $XDG_CONFIG_HOME \
    ~/documents

set -gx GTRASH_HOME_TRASH_DIR "$XDG_DATA_HOME/trash"

# FX - JSON viewer
set -gx FX_SHOW_SIZE true
set -gx FX_LINE_NUMBERS true
set -gx FX_THEME 2

# GEMINI CLI
set -gx GEMINI_CLI_SYSTEM_SETTINGS_PATH ~/.config/gemini/settings.json

set -gx DISPLAY ':0.0'
