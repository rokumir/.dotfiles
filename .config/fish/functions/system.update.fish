function __system.update.notice
    set sep (set_color -o brgreen)(string repeat -n (math $COLUMNS/2) '')
    set indent (string repeat -n 2 '    ')
    echo $sep
    echo (set_color -o green)$indent$argv
    echo $sep(set_color normal)
end

function system.update
    __system.update.notice 'UPDATING SYSTEM PACKAGES'
    yay; or sudo pacman -Syu

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
