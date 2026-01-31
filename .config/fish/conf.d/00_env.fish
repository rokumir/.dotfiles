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

set -gx DISPLAY ':0.0'

set -gx TERMINFO $XDG_CONFIG_HOME/terminfo
set -gx TERM wezterm # enable undercurl .terminfo/w/wezterm
set -gx GIT_EDITOR nvim
set -gx GIT_CONFIG_GLOBAL ~/.config/git/config
set -gx EDITOR nvim
set -gx PAGER bat

## ---------------------------------------
set -l DOC_DIR ~/documents

# Rokumir Home
set -gx RH_NOTE $DOC_DIR/notes
set -gx RH_BRAIN $RH_NOTE/cortex
set -gx RH_PROJECT $DOC_DIR/projects
set -gx RH_WORK $DOC_DIR/works
set -gx RH_THROWAWAY $DOC_DIR/throwaways
set -gx RH_SCRIPT ~/.scripts

fish_add_path -g $RH_SCRIPT

set -gx RH_VAULT \
    $RH_NOTE \
    $RH_WORK \
    $RH_PROJECT \
    $RH_THROWAWAY \
    $RH_SCRIPT \
    $XDG_CONFIG_HOME \
    $DOC_DIR

set -gx GTRASH_HOME_TRASH_DIR "$XDG_DATA_HOME/trash"

# FX - JSON viewer
set -gx FX_SHOW_SIZE true
set -gx FX_LINE_NUMBERS true
set -gx FX_THEME 2

# GEMINI CLI
set -gx GEMINI_CLI_SYSTEM_SETTINGS_PATH ~/.config/gemini/settings.json

# MCAT
set -gx MCAT_ENCODER sixel # Options: kitty,iterm,sixel,ascii
set -gx MCAT_THEME catppuccin # <str> possible options: catppuccin, nord, monokai, dracula, gruvbox, one_dark, solarized, tokyo_night, makurai_light, makurai_dark, ayu, ayu_mirage, github, synthwave, material, rose_pine, kanagawa, vscode, everforest, autumn
set -gx MCAT_INLINE_OPTS # <str> same as the --opts flag
# set -gx MCAT_LS_OPTS 'x_padding=4c,y_padding=2c,min_width=4c,max_width=16c,height=8%,items_per_row=12' # <str> same as the --ls-opts flag
set -gx MCAT_SILENT false # <bool> same as the --silent flag
set -gx MCAT_HYPRLINK true # <bool> same as the --hyprlink flag
set -gx MCAT_NO_LINENUMBERS true # <bool> same as the --no-linenumbers flag
# set -gx MCAT_MD_IMAGE false # <bool> same as the --no-images flag
# set -gx MCAT_PAGER # <str> the full command mcat will try to pipe into.

set -gx TAPLO_CONFIG ~/.config/taplo/config.toml
