if status is-interactive
    set -g fish_greeting
    set -gx EDITOR nano
    set -gx VISUAL zeditor
    zoxide init fish | source
end
