function fuzzy.find -d 'Search Files'
    set token (eval echo -- (commandline -t)) # expand vars & tidle
    set token (string unescape -- $token) # unescape to void compromise the path

    set fd_cmd fd \
        --follow \
        --hidden \
        --ignore \
        --no-require-git

    set fzf_cmd fzf \
        --bind "alt-i:reload:eval $fd_cmd --unrestricted" \
        --bind 'alt-i:+change-header:'

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    begin
        if [ -d "$token" ] && string match -q -- '*/' $token
            $fd_cmd --base-directory $token \
                | $fzf_cmd --border-label " $token " \
                | awk "{print $token\$1}"
        else
            $fd_cmd \
                | $fzf_cmd --query "$token" --border-label " $(pwd | sed "s|^$HOME|~|")/ "
        end
    end \
        | read -f result
    or return 1

    source (type --path helper.open-path) $result
end
