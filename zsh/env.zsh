export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'"

export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export LESS="-j.5 --mouse"

export PATH="$(cd "${ZSH}/../bin" && pwd):$PATH"
