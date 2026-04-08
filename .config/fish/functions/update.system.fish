function update.system
    if type -q yay
        yay
    else if type -q paru
        paru
    else
        sudo pacman -Syu
    end

    if type -q cargo rustup
        rustup update
        cargo install-update -a
        cargo cache -a
    end

    if type -q bob
        bob update -a
        or with-gh-token bob update -a
    end
end
