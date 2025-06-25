## fish options
set -U fish_greeting ''
set -U fish_vi_force_cursor true
set -U fish_cursor_insert line blink
set -U fish_cursor_default block blink
set -U fish_prompt_pwd_dir_length 1
set -U fish_prompt_pwd_full_dirs 3

## plugins
if functions -q fundle
    fundle plugin IlanCosman/tide@v6
    fundle init
else
    eval (curl -sfL https://git.io/fundle-install)
end

## aliases
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias vi nvim
alias ls 'eza -laU --icons --no-user --group-directories-first'
alias l ls
alias g git
alias gd 'git --git-dir $HOME/.dotfiles -C $HOME --work-tree $HOME'

function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

## keymaps
function fish_user_key_bindings
    fish_vi_key_bindings

    # unbind keys (run in fish_user_key_bindings to ensure it works)
    for key in \
        \cd \
        \cs
        bind --erase --preset $key
        bind --erase --preset -M insert $key
        bind --erase --preset -M visual $key
    end

    # actions
    bind --preset \cq exit
    bind --preset -M insert -m default jj ''
    bind --preset -M insert -m default jk ''
    bind --preset -M insert \cy forward-char # accept inline suggestion
    bind --preset L end-of-line
    bind --preset H beginning-of-line
    bind --preset -M visual L end-of-line
    bind --preset -M visual H beginning-of-line

    # scripts
    # script closing
    set _sc "; echo; commandline -t ''; commandline -f repaint-mode; set fish_bind_mode insert;"

    bind --preset -M insert \cp '[ -z "$fish_private_mode" ] && fish --private || echo -e \n(set_color yellow)Private mode is active!!'$_sc

    if not set -q TMUX
        bind --preset -M insert \e\;\en 'tmuxizer'$_sc
        bind --preset -M insert \e\;\e\; 'tmux attach-session'$_sc
    end

    # extenal scripts needed to be sourced, otherwise it won't work as expected
    bind --preset -M insert \ce 'source (type -p fuzzy.find)'
    bind --preset -M insert \cd 'source (type -p fuzzy.vault)'
end

## os
switch (uname -sr)
    case 'Linux*WSL*'
        source (dirname (status --current-filename))/config-wsl.fish
end
