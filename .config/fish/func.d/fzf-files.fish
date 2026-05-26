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

    _fzf-exec $result
end
