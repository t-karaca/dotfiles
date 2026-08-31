# export FZF_DEFAULT_OPTS=" \
#     --color=dark,bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
#     --color=dark,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
#     --color=dark,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
#     --color=dark,selected-bg:#45475A \
#     --color=dark,border:#6C7086,label:#CDD6F4 \
#     --color=light,bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
#     --color=light,fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
#     --color=light,marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
#     --color=light,selected-bg:#BCC0CC \
#     --color=light,border:#9CA0B0,label:#4C4F69 \
#     --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'"

# export FZF_DEFAULT_OPTS=" \
#     --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
#     --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
#     --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
#     --color=selected-bg:#BCC0CC \
#     --color=border:#9CA0B0,label:#4C4F69"

# export FZF_DEFAULT_OPTS=" \
#     --color=base16 \
#     --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'"

export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export LESS="-j.5 --mouse"

export PATH="$(cd "${ZSH}/../bin" && pwd):$PATH"
