set -gx GIT_EDITOR nvim
set -gx GIT_CONFIG_GLOBAL ~/.config/git/config
set -gx EDITOR nvim
set -gx PAGER bat

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
