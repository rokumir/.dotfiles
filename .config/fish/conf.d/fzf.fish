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

# --------------------------------------------------------------------------

function fzf-files -d 'Search files and directories interactively'
    set token (commandline -t | string unescape) # expand & unescape tokens cleanly

    set fd_cmd fd --follow --hidden --ignore --no-require-git
    set fzf_cmd fzf \
        --bind "alt-i:reload:eval $fd_cmd --unrestricted" \
        --bind 'alt-i:+change-header:'

    # Separate logic based on whether token is an active directory
    begin
        if test -d "$token"; and string match -q '*/' $token
            $fd_cmd --base-directory $token \
                | $fzf_cmd --border-label " $token " \
                | awk "{print \"$token\$1\"}"
        else
            $fd_cmd \
                | $fzf_cmd --query "$token" --border-label " $(pwd | sed "s|^$HOME|~|")/ "
        end
    end | read -f result
    or return 1

    __fzf-exec $result
end

function __fzf-exec -d "My fzf internal unified execution logic"
    set input_path $argv[1]
    set real_path (eval echo -- $input_path)
    set token

    ## Handlers
    [ -f "$real_path" -a -w "$real_path" ]; and set token $EDITOR # file
    [ -d "$real_path" ]; and set token cd # dir

    ## Prettify path
    set -a token (string escape -n $real_path | sed "s:^$HOME:~:")

    # Update history (if not in private mode)
    if [ -z "$fish_private_mode" ]
        begin
            echo '- cmd:' (string unescape -n $token)
            echo '  when:' (date '+%s')
            echo '  path:'
            echo '    -' $input_path
        end >>~/.local/share/fish/fish_history

        builtin history --merge # merge history file with (empty) internal history
    end

    # execute command
    eval $token
    set fish_bind_mode insert
    commandline -f repaint-mode
end

function fzf-vault -d 'Search and navigate vault directories'
    argparse title=? print=? absolute=? -- $argv
    or return 1

    set title ' Home '
    set -q _flag_title; and set title $_flag_title

    # Generate vault list cleanly
    begin
        printf '%s\n' $RH_VAULT
        fd --follow --hidden --ignore --no-require-git \
            --type directory --max-depth 1 --absolute-path --color never \
            -- . $RH_VAULT
    end \
        | sed "s:^$HOME/::; s:/\$::" \
        | sort -ur \
        | fzf --border-label " $title " \
        | read -l result
    or return 1

    # Reconstruct path based on absolute flag
    set prefix '~'
    set -q _flag_absolute; and set prefix $HOME
    set final_path $prefix/$result

    if set -q _flag_print
        echo $final_path
    else
        __fzf-exec $final_path
    end
end
