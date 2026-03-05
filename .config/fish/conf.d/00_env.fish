type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source

set -gx GIT_EDITOR nvim
set -gx GIT_CONFIG_GLOBAL ~/.config/git/config
set -gx EDITOR nvim
set -gx PAGER bat

## ---------------------------------------
set -l MY_SCRIPT_DIR ~/.scripts
fish_add_path -g $MY_SCRIPT_DIR

# Rokumir Vault Directories
set -gx RH_VAULT \
    $XDG_CONFIG_HOME \
    $MY_SCRIPT_DIR \
    ~/Documents \
    ~/Documents/works \
    ~/Documents/projects \
    ~/Documents/throwaways
