not string match 'Linux*WSL*' "$(uname -sr)" >/dev/null; and return

# ----------------------------------
# Helpers
function win-home
    if not set -q WIN_HOME
        set path (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null) # still in Windows path format (forward slashes)
        set -gx WIN_HOME (wslpath -u $path)
    end
    printf $WIN_HOME
end

# ----------------------------------
# ENV

# ----------------------------------
# Aliases & functions
alias nvi 'neovide.exe'
alias btop-win 'btop.exe'

function wezterm-config
    set -l win_path (win-home)
    set -gx WEZTERM_CONFIG_DIR $win_path/.config/wezterm
    set -gx WEZTERM_CONFIG $WEZTERM_CONFIG_DIR/wezterm.lua
    printf $WEZTERM_CONFIG
end

if type -q pwsh.exe
    alias pwsh_win 'pwsh.exe -wd "~"'
    alias pwshw pwsh_win
    alias pwshw_clean 'pwsh_win -NoProfile'

    function scoop.update
        pwshw_clean -c "scoop update | scoop list | foreach { scoop update \$_.Name }"
    end
    function scoop.clean
        pwshw_clean -c "scoop cleanup *; scoop cache rm *"
    end
    function cargo.windows.update
        pwshw_clean -c "rustup update; cargo install-update -a; cargo cache -a"
    end
end
