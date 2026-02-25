function cargo.update
    not type -q rustup; and return
    not type -q cargo; and return

    rustup update; or return
    cargo install-update -a; or return
    cargo cache -a
end
