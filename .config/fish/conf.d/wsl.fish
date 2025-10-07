not string match 'Linux*WSL*' "$(uname -sr)" >/dev/null; and return

function win-home
    if not set -q WIN_HOME
        set path (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null) # still in Windows path format (forward slashes)
        set -gx WIN_HOME (wslpath -u $path)
    end

    printf $WIN_HOME
end
function wezterm-config
    set -l win_path (win-home)
    set -gx WEZTERM_CONFIG_DIR $win_path/.config/wezterm
    set -gx WEZTERM_CONFIG $WEZTERM_CONFIG_DIR/wezterm.lua
    printf $WEZTERM_CONFIG
end

alias pwsh 'pwsh.exe -WorkingDirectory "~"'
type -q 'neovide.exe' && alias nvi 'neovide.exe'
type -q 'btop.exe' && alias btop-win 'btop.exe'
