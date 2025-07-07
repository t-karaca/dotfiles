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

if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)" 
fi

if [[ -f "${ZSH}/cache/.zcompdump" ]]; then
  compinit -C -i -d "${ZSH}/cache/.zcompdump"
else
  compinit -i -d "${ZSH}/cache/.zcompdump"
  zcompile "${ZSH}/cache/.zcompdump"
fi

source "${ZSH}/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "${ZSH}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${ZSH}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

zstyle ':completion:*' matcher-list 'r:|?=**'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:zshz:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons=always --color=always $realpath'
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

source "${ZSH}/plugins/gradle/gradle.plugin.zsh"
source "${ZSH}/env.zsh"
source "${ZSH}/aliases.zsh"
source "${ZSH}/functions.zsh"

list_files() {
    la
}

add-zsh-hook chpwd list_files

