alias l="eza --icons=always -la"
alias la="l"
alias ll="l -T"

alias se="sudoedit"

alias t="tmux"
alias ta="tmux attach"

alias grep="grep --color=auto"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# git

alias git="LANG=en_US git"
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcam="git commit --amend -m"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcom="git checkout main"
alias gbd="git branch -D"
alias gbr="git branch"
alias gbrd="git branch -d"
alias gbrm="git branch -m"
alias gbrmd="git branch --merged | grep -v \"main\" | xargs git branch -d"
alias gf="git fetch"
alias gfa="git fetch --all"
alias gl="git pull"
alias gp="git push"
alias lg="lazygit"

# docker

alias d="docker"
alias dco="docker compose"
alias drmia="docker rmi -f \$(docker images -aq)"

# nerdctl

alias n="nerdctl"
alias nk="nerdctl -n k8s.io"
alias nco="nerdctl compose"

# kubectl

alias kx="kubectx"
alias kns="kubens"

alias k="kubectl"
alias kpf="kubectl port-forward"
alias keti="kubectl exec -ti"

alias tl="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"

if command -v go-task >/dev/null 2>&1; then
    alias task="go-task"
fi

if command -v xdg-open >/dev/null 2>&1; then
    alias open="xdg-open"
fi


