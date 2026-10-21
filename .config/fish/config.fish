zoxide init fish | source

abbr -a ff fastfetch

if test -S "$XDG_RUNTIME_DIR/keyring/ssh"
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/keyring/ssh"
end

function fish_greeting
    ~/.config/fish/torii-greeting.sh
end
