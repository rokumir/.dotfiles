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
