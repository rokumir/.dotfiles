set -gx FZF_DEFAULT_OPTS \
    --padding 0,1 \
    --cycle --reverse \
    --scrollbar │ --marker │ --pointer ┃ --gutter '\ ' \
    --ansi --inline-info \
    --tmux --border rounded \
    ### keymaps
    --bind ctrl-l:accept,ctrl-q:abort,ctrl-s:toggle \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    --bind alt-a:toggle-all,ctrl-space:toggle \
    ### theme
    --color header:italic,header:#3E8FB0 \
    --color fg:#908CAA,fg+:#E6E6E6,bg+:#1F1F24 \
    --color hl:#EA9A97,hl+:#EA9A97,border:#44415A \
    --color spinner:#F6C177,info:#9CCFD8,separator:#44415A \
    --color pointer:#C4A7E7,marker:#EB6F92,prompt:#908CAA
