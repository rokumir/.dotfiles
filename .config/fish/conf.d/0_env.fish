set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_STATE_HOME ~/.local/state
set -gx XDG_RUNTIME_DIR /run/user/1000

fish_add_path -g ~/.local/bin # third parties' scripts
fish_add_path -g ~/go/bin
fish_add_path -g ~/.bun/bin ~/.cache/.bun/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.deno/bin
fish_add_path -g $XDG_DATA_HOME/bob/nvim-bin

fish_add_path -g $XDG_DATA_HOME/fnm
type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source

# Configs
set -gx TERMINFO $XDG_CONFIG_HOME/terminfo
set -gx TERM wezterm # enable undercurl ~/.terminfo/w/wezterm
set -gx GIT_EDITOR nvim # nvim cus git uses sh internally
set -gx EDITOR vi
set -gx PAGER bat

## ---------------------------------------

set -gx MY_NOTE_HOME ~/documents/notes
set -gx MY_PROJECT_HOME ~/documents/projects
set -gx MY_WORK_HOME ~/documents/works
set -gx MY_THROWAWAY_HOME ~/documents/throwaways
set -gx MY_SCRIPT_HOME ~/.scripts

fish_add_path -g $MY_SCRIPT_HOME

set -gx PG_TTY (tty)
