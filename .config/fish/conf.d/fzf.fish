set -gx FZF_DEFAULT_OPTS \
    --padding 0,1 \
    --cycle --reverse \
    --scrollbar │ --marker │ --pointer ┃ \
    --ansi --inline-info \
    ### keymaps
    --bind ctrl-l:accept,ctrl-q:abort,ctrl-s:toggle \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    --bind alt-a:toggle-all,ctrl-space:toggle \
    ### theme
    --color header:italic,header:#3E8FB0,gutter:-1 \
    --color fg:#908CAA,fg+:#E6E6E6,bg+:#1F1F24 \
    --color hl:#EA9A97,hl+:#EA9A97,border:#44415A \
    --color spinner:#F6C177,info:#9CCFD8,separator:#44415A \
    --color pointer:#C4A7E7,marker:#EB6F92,prompt:#908CAA

function fuzzyf -d 'fzf with custom arguments (separate from the FZF_DEFAULT_OPTS)'
    set fzf_cmd fzf --tmux
    test -n "$TMUX"; and set -a fzf_cmd --border rounded
    $fzf_cmd $argv
end
function searchd -d 'find with custom arguments'
    fd --follow \
        --no-hidden \
        --ignore \
        --no-require-git \
        $argv
end
