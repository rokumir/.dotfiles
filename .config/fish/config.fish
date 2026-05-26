set -g fish_greeting ''
set -g fish_vi_force_cursor true
set -g fish_cursor_insert line blink
set -g fish_cursor_default block blink
set -g fish_prompt_pwd_dir_length 1
set -g fish_prompt_pwd_full_dirs 3
set -p fish_function_path ~/.config/fish/func.d

## --------------------------------------------------
## aliases/functions
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias vi nvim
alias ls 'eza -laU --icons --no-user --group-directories-first --color always'
alias l ls
alias g git
alias gd 'git --git-dir $HOME/.dotfiles -C $HOME --work-tree $HOME'
alias trash gtrash
alias warp warp-cli

alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias hardware 'hwinfo --short | bat' # Hardware Info
alias big "expac -H M '%m\t%n' | sort -rh | nl | bat" # Sort installed packages according to size in MB
alias rip "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl | bat" # Recent installed packages
alias jctl 'journalctl -p 3 -xb' # Get the error messages from journalctl
alias cleanup 'sudo pacman -Rns (pacman -Qtdq)' # Cleanup orphaned packages
alias mirror 'sudo cachyos-rate-mirrors' # Get fastest mirrors

## --------------------------------------------------
## keymaps
function fish_user_key_bindings
    fish_vi_key_bindings

    # unbind keys (run in fish_user_key_bindings to ensure it works)
    for mode in (bind -L)
        for key in ctrl-d ctrl-s
            bind --erase --preset -M $mode $key
        end
    end

    # actions
    bind --preset ctrl-q exit
    bind --preset -Minsert -m default 'j,j' ''
    bind --preset -Minsert -m default 'j,k' ''
    bind --preset -Minsert ctrl-y forward-char # accept inline suggestion
    bind --preset L end-of-line
    bind --preset H beginning-of-line
    bind --preset -Mvisual L end-of-line
    bind --preset -Mvisual H beginning-of-line

    set _sc '; echo; commandline -t ""; commandline -f repaint-mode; set fish_bind_mode insert;'

    bind --preset -Minsert ctrl-p '[ -z "$fish_private_mode" ] && fish --private || echo -e \n(set_color yellow)Private mode is active!!'$_sc

    bind --preset -Minsert ctrl-e fzf-files
    bind --preset -Minsert ctrl-d fzf-vault

    if not set -q TMUX
        bind --preset -Minsert 'alt-;,alt-n' 'tmuxizer'$_sc
        bind --preset -Minsert 'alt-;,alt-;' 'tmux attach-session'$_sc
    end
end
