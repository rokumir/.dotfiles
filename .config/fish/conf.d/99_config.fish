source "$__fish_config_dir/os/"(begin
    switch (uname)
        case Darwin; echo darwin.fish
        case Linux; set -q WSL_DISTRO_NAME; and echo wsl.fish; or echo linux.fish
        case '*'; echo windows.fish
    end
end)
