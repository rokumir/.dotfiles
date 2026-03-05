function __system.update.notice -d "Display a stylized system update notification"
    set -l message "$argv"
    set -l cols ([ -n "$COLUMNS" ]; and echo $COLUMNS; or echo 80)
    set -l sep_char ''

    set -l indent_width (math -s0 "$cols / 8")
    set -l top_sep_width (math -s0 "$cols / 2")
    set -l bot_sep_width (math -s0 "$cols / 3")
    set -l indent (string repeat -n $indent_width ' ')

    echo -e \n(set_color -o bryellow)(string repeat -n $top_sep_width $sep_char)
    echo -e (set_color -o yellow)"$indent$message"
    echo -e (set_color -o bryellow)(string repeat -n $bot_sep_width $sep_char)\n

    set_color normal
end

function system.update
    __system.update.notice 'UPDATING SYSTEM PACKAGES'
    paru -Sy; or sudo pacman -Sy

    if type -q cargo
        __system.update.notice 'UPDATING CARGOS (LINUX)'
        cargo.update
    end

    if type -q cargo.exe
        __system.update.notice 'UPDATING CARGOS (WINDOWS)'
        cargo.windows.update
    end

    if type -q bob
        __system.update.notice 'UPDATING NEOVIM VERSION MANAGER'
        bob update nightly
        bob update stable
    end

    if type -q bun
        __system.update.notice 'UPDATING BUN'
        bun upgrade
        bun update -g --latest
    end

    if type -q scoop
        __system.update.notice 'UPDATING SCOOP'
        scoop.update
        __system.update.notice 'CLEANING SCOOP'
        scoop.clean
    end
end
