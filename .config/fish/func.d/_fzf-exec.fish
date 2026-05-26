function _fzf-exec -d "My fzf internal unified execution logic"
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
