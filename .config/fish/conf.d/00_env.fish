set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_STATE_HOME ~/.local/state

set -gx TERMINAL (gsettings get org.gnome.desktop.default-applications.terminal exec | tr -d "'")

set -gx GIT_EDITOR nvim
set -gx GIT_CONFIG_GLOBAL ~/.config/git/config
set -gx EDITOR nvim
set -gx PAGER bat

set -gx CLIPHIST_MAX_ITEMS 500

## ---------------------------------------
# Rokumir Vault Directories
set -gx RH_VAULT \
    $XDG_CONFIG_HOME \
    ~/.scripts \
    ~/Documents \
    ~/Documents/notes \
    ~/Documents/works \
    ~/Documents/projects \
    ~/Downloads/throwaways

## ---------------------------------------
# Paths
fish_add_path ~/.local/bin
fish_add_path ~/.scripts
fish_add_path ~/.local/scripts
fish_add_path ~/.bun/bin
fish_add_path ~/.cache/.bun/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.deno/bin
fish_add_path ~/go/bin
fish_add_path $XDG_DATA_HOME/bob/nvim-bin
fish_add_path $XDG_DATA_HOME/fnm

## ---------------------------------------
# User Directories "user-dirs.dirs"
set file ~/.config/user-dirs.dirs
if [ -f $file ]
    for var_line in (string match -r '^\s*XDG_[A-Z_]+_DIR\s*=\s*"[^"]+"' -- (string trim -- (cat $file)))
        eval "export $var_line"
    end
end
