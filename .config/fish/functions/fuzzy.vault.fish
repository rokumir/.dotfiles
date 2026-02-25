function fuzzy.vault -d 'Home Search'
    argparse t/title= print=? absolute=? -- $argv
    or return 1

    # fuzzy title
    set title ' Home '
    if set -q _flag_title
        set title $_flag_title
    end

    # find options
    set fd_cmd fd \
        --follow \
        --hidden \
        --ignore \
        --no-require-git \
        --type directory \
        --max-depth 1 \
        --absolute-path \
        --color never

    begin
        printf '%s\n' $RH_VAULT
        $fd_cmd -- . $RH_VAULT
    end \
        | sed "s:^$HOME/::; s:/\$::" \
        | sort -ur \
        | fzf --border-label $title \
        | read -l result
    or return 1

    set result (set -q _flag_absolute && echo $HOME || echo \~)/$result

    if set -q _flag_print
        echo $result
    else
        source (type --path helper.open-path) $result
    end
end
