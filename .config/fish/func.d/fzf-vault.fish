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
        | sort -fbu \
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
        _fzf-exec $final_path
    end
end
