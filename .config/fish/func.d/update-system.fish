function update-system -d 'Update installed packages on pacman, AUR, Cargo, and Bob'
    paru; or sudo pacman -Syu

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
