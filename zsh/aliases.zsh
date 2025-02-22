# Aliases

alias l="eza --icons=always -la"
alias la="l"
alias ll="l -T"

alias se="sudoedit"

alias h='fc -l -r -1 -30'

alias t="tmux"
alias ta="tmux attach"
alias tm="tmux new-session -As main -c \$HOME"

# alias tree="tree -C"
# alias t="tree -C"
# alias t1="tree -C -L 1"
# alias t2="tree -C -L 2"
# alias t3="tree -C -L 3"
# alias t4="tree -C -L 4"
#
# alias ta="tree -C -a"
# alias ta1="tree -C -L 1 -a"
# alias ta2="tree -C -L 2 -a"
# alias ta3="tree -C -L 3 -a"
# alias ta4="tree -C -L 4 -a"

alias grep="grep --color=auto"

alias e="nvim"

alias zshrc="zsh -c \"cd \${ZSH} && nvim .zshrc\""
alias zshalias="zsh -c \"cd \${ZSH} && nvim aliases.zsh\""
alias zshreload="exec zsh -l"

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
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gfa="git fetch --all"
alias gl="git pull"
alias gp="git push"
alias gpt="git push --tags"
alias gt="git tag"
alias gtd="git tag -d"
alias lg="lazygit"

# docker

alias d="docker"
alias dco="docker compose"
alias drmia="docker rmi -f \$(docker images -aq)"

# nerdctl

alias n="nerdctl"
alias nk="nerdctl -n k8s.io"
alias nco="nerdctl compose"

alias rlm="go-release-manager"

# sepoctl

alias s="sepoctl"
alias sa="sepoctl argocd"
alias sab="sepoctl argocd branch"
alias sabr="sepoctl argocd branch reset"
alias sas="sepoctl argocd sync"
alias sar="sepoctl argocd refresh"
alias sal="sepoctl argocd list"
alias sad="sepoctl argocd delete"
alias sao="sepoctl argocd open"
alias sb="sepoctl build"
alias sl="sepoctl logs"
alias skc="sepoctl keycloak"
alias spg="sepoctl postgres"
alias spf="sepoctl port-forward"
alias sr="sepoctl restart"
alias ss="sepoctl shell"
alias sj="sepoctl jenkins ."

# kubectl

alias kx="kubectx"
alias kns="kubens"

alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods -A"
alias kgs="kubectl get services"
alias kgsa="kubectl get services -A"
alias kgi="kubectl get ingress"
alias kgia="kubectl get ingress -A"
alias kgc="kubectl get configmap"
alias kgca="kubectl get configmap -A"
alias kgd="kubectl get deployment"
alias kgda="kubectl get deployment -A"
alias kgn="kubectl get namespace"

alias kd="kubectl describe"

alias krm="kubectl delete"

alias klo="kubectl logs"

alias kpf="kubectl port-forward"

alias keti="kubectl exec -ti"

alias tl="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"

if command -v go-task >/dev/null 2>&1; then
    alias task="go-task"
fi

if command -v xdg-open >/dev/null 2>&1; then
    alias open="xdg-open"
fi
