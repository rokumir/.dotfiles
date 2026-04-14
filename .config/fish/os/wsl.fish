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

set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_STATE_HOME ~/.local/state
set -gx XDG_RUNTIME_DIR /run/user/1000

set -ga RH_VAULT $XDG_CONFIG_HOME

# Paths
fish_add_path -g ~/.local/bin # third parties' scripts
fish_add_path -g ~/.bun/bin ~/.cache/.bun/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.deno/bin
fish_add_path -g $XDG_DATA_HOME/bob/nvim-bin
fish_add_path -g $XDG_DATA_HOME/fnm
fish_add_path -g ~/go/bin

# ----------------------------------
# Aliases & functions
function wezterm-config
    set -l win_path (win-home)
    set -gx WEZTERM_CONFIG_DIR $win_path/.config/wezterm
    set -gx WEZTERM_CONFIG $WEZTERM_CONFIG_DIR/wezterm.lua
    printf $WEZTERM_CONFIG
end

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
