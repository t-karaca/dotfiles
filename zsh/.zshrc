#!/usr/bin/env zsh

export ZSH_TMUX_AUTO_TITLE_IDLE_DELAY=0
export ZSH_TMUX_AUTO_TITLE_IDLE_TEXT=%pwd

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
# setopt appendhistory
# setopt SHARE_HISTORY
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt INC_APPEND_HISTORY_TIME
setopt globdots
unsetopt BEEP

bindkey -v
bindkey '\ej' history-search-forward
bindkey '\ek' history-search-backward

if command -v brew &> /dev/null; then
    brew_prefix=$(brew --prefix)

    export PATH="$brew_prefix/opt/libpq/bin:$PATH"
    export PATH="$brew_prefix/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$brew_prefix/opt/gnu-sed/libexec/gnubin:$PATH"

    fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
fi

[[ -z "$ZSH" ]] && export ZSH="${${(%):-%x}:a:h}"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="${ZSH}/bin:$PATH"

fpath=("$ZSH/completions" $fpath)

autoload -U add-zsh-hook
autoload -U colors && colors
autoload -U compaudit compinit zrecompile
autoload -U +X bashcompinit && bashcompinit

zmodload -i zsh/complist
zmodload -F zsh/files b:zf_ln b:zf_mkdir b:zf_rm

source "${ZSH}/plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "${ZSH}/.p10k.zsh"

source "${ZSH}/plugins/colored-man-pages/colored-man-pages.plugin.zsh"
source "${ZSH}/plugins/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh"
source "${ZSH}/plugins/zsh-tmux-auto-title/zsh-tmux-auto-title.plugin.zsh"
source "${ZSH}/plugins/yq-repl/yq.plugin.zsh"
# source "${ZSH}/plugins/jq-zsh-plugin/jq.plugin.zsh"
source "${ZSH}/plugins/zsh-z/zsh-z.plugin.zsh"

if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)" 
fi

if [[ -f "${ZSH}/cache/.zcompdump" ]]; then
  compinit -C -i -d "${ZSH}/cache/.zcompdump"
else
  compinit -i -d "${ZSH}/cache/.zcompdump"
  zcompile "${ZSH}/cache/.zcompdump"
fi

source "${ZSH}/plugins/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh"

source "${ZSH}/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "${ZSH}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${ZSH}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

zstyle ':completion:*' matcher-list 'r:|?=**'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:zshz:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

source "${ZSH}/plugins/gradle/gradle.plugin.zsh"
source "${ZSH}/aliases.zsh"
source "${ZSH}/functions.zsh"

    # --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'"

export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"

list_files() {
    la
}

add-zsh-hook chpwd list_files

# eval "$(fzf --zsh)"
