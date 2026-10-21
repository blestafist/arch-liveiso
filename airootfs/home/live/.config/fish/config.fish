# Desktop autostart is handled by /etc/fish/conf.d/20-live-session.fish.

alias sl="ls"
alias sls="sl"
alias v="nvim"

alias c="clear"
alias cls="clear && fastfetch --config terminal-open"

alias gc="git commit -m"
alias gps="git push"
alias gpl="git pull"
alias ga="git add ."
alias gi="git init"

alias fuck="sudo"
alias sv="sudo nvim"

alias pf="loginctl poweroff"
alias rb="loginctl reboot"

if status is-interactive
    fastfetch --config terminal-open
end
