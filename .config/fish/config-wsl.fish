alias pwsh 'pwsh.exe -WorkingDirectory "~"'

function get-window-home
    # flag_u: unix  |  flag_m: windows
    argparse -n get-window-home u m -- $argv; or return
    set path (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null) # still in Windows path (forward slashes)

    if set -q _flag_m
        echo $path
        return
    end

    wslpath -u $path
end

set -gx WIN_HOME (get-window-home)
set -gx WEZTERM_CONFIG_DIR $WIN_HOME/.config/wezterm
set -gx WEZTERM_CONFIG $WEZTERM_CONFIG_DIR/wezterm.lua
