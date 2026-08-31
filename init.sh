#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
DRY_RUN=false

usage() {
    printf 'Usage: %s [--dry-run]\n' "${0##*/}"
}

log() {
    printf '%s\n' "$*"
}

warn() {
    printf 'WARN: %s\n' "$*" >&2
}

run() {
    if "$DRY_RUN"; then
        printf '[dry-run]'
        printf ' %q' "$@"
        printf '\n'
        return
    fi

    "$@"
}

confirm() {
    local prompt=$1
    local answer

    if "$DRY_RUN"; then
        log "[dry-run] would ask: $prompt [y/N]"
        return 1
    fi

    read -r -p "$prompt [y/N] " answer
    [[ $answer =~ ^[Yy]([Ee][Ss])?$ ]]
}

ensure_directories() {
    log '==> Creating required directories'
    run mkdir -p "$HOME/.config"
}

append_legacy_zsh_entrypoint() {
    local target=$1

    if "$DRY_RUN"; then
        log "[dry-run] would append the dotfiles Zsh entrypoint to $target"
        return
    fi

    {
        printf '\n### Added by dotfiles\n'
        printf 'source "%s/zsh/main.zsh"\n\n' "$ROOT_DIR"
    } >>"$target"
}

ensure_legacy_zsh_entrypoint() {
    local target="$HOME/.zshrc"

    log '==> Preserving legacy Zsh entrypoint'
    if [[ -L $target && ! -e $target ]]; then
        warn "Cannot update dangling Zsh entrypoint: $target"
        return
    fi

    if [[ -d $target ]]; then
        warn "Cannot update Zsh entrypoint because it is a directory: $target"
        return
    fi

    if [[ ! -e $target ]]; then
        log "Creating $target"
        run touch "$target"
        append_legacy_zsh_entrypoint "$target"
        return
    fi

    if grep -Fxq '### Added by dotfiles' "$target"; then
        log "Legacy Zsh entrypoint already present: $target"
        return
    fi

    if confirm "Append the dotfiles Zsh entrypoint to $target?"; then
        append_legacy_zsh_entrypoint "$target"
    else
        log "Leaving Zsh entrypoint unchanged: $target"
    fi
}

read_packages() {
    local package
    local manifest="$ROOT_DIR/bootstrap/packages.pacman"

    PACKAGES=()
    while IFS= read -r package || [[ -n $package ]]; do
        [[ -z $package || ${package:0:1} == '#' ]] && continue
        PACKAGES+=("$package")
    done <"$manifest"
}

install_packages() {
    local package
    local -a missing=()
    local -a pacman_command=(pacman)

    log '==> Checking Pacman packages'
    if ! command -v pacman >/dev/null 2>&1; then
        warn 'Pacman is unavailable; only Pacman installation is implemented.'
        return
    fi

    read_packages
    for package in "${PACKAGES[@]}"; do
        pacman -Qq "$package" >/dev/null 2>&1 || missing+=("$package")
    done

    if ((${#missing[@]} == 0)); then
        log 'All required Pacman packages are installed.'
        return
    fi

    log "Missing packages: ${missing[*]}"
    if ! confirm 'Install missing packages with pacman?'; then
        log 'Package installation skipped.'
        return
    fi

    if ((EUID != 0)); then
        if ! command -v sudo >/dev/null 2>&1; then
            warn 'Cannot install packages without root privileges or sudo.'
            return
        fi
        pacman_command=(sudo pacman)
    fi

    run "${pacman_command[@]}" -S --needed "${missing[@]}"
}

initialize_submodules() {
    log '==> Initializing submodules'
    if ! command -v git >/dev/null 2>&1; then
        warn 'Git is unavailable; submodules were not initialized.'
        return
    fi

    run git -C "$ROOT_DIR" submodule update --init --recursive
}

link_config() {
    local source=$1
    local target=$2
    local source_path
    local backup

    source_path=$(readlink -f -- "$source")
    if [[ ! -e $source_path ]]; then
        warn "Source does not exist: $source"
        return
    fi

    if [[ ! -e $target && ! -L $target ]]; then
        log "Linking $target -> $source_path"
        run ln -s "$source_path" "$target"
        return
    fi

    if [[ -L $target ]] && [[ $(readlink -f -- "$target") == "$source_path" ]]; then
        log "Link already correct: $target"
        return
    fi

    if [[ -L $target ]]; then
        if confirm "Replace wrong symlink at $target?"; then
            log "Replacing symlink $target -> $source_path"
            run rm -- "$target"
            run ln -s "$source_path" "$target"
        else
            log "Leaving symlink unchanged: $target"
        fi
        return
    fi

    backup="$target.backup-$(date +%Y%m%d%H%M%S)"
    if [[ -e $backup || -L $backup ]]; then
        warn "Backup path already exists: $backup"
        return
    fi

    if confirm "Back up $target to $backup and replace it?"; then
        log "Backing up $target to $backup"
        run mv -- "$target" "$backup"
        run ln -s "$source_path" "$target"
    else
        log "Leaving existing path unchanged: $target"
    fi
}

link_configs() {
    log '==> Linking configuration directories'
    link_config "$ROOT_DIR/bat" "$HOME/.config/bat"
    link_config "$ROOT_DIR/bottom" "$HOME/.config/bottom"
    link_config "$ROOT_DIR/k9s" "$HOME/.config/k9s"
    link_config "$ROOT_DIR/lazygit" "$HOME/.config/lazygit"
    link_config "$ROOT_DIR/lazydocker" "$HOME/.config/lazydocker"
    link_config "$ROOT_DIR/nvim" "$HOME/.config/nvim"
    link_config "$ROOT_DIR/tmux" "$HOME/.config/tmux"
}

build_caches_and_verify_assets() {
    local asset
    local -a required_assets=(
        "$ROOT_DIR/bat/themes/Catppuccin Mocha.tmTheme"
        "$ROOT_DIR/bat/themes/Catppuccin Latte.tmTheme"
        "$ROOT_DIR/k9s/skins/catppuccin-mocha-transparent.yaml"
    )

    log '==> Verifying committed theme assets'
    for asset in "${required_assets[@]}"; do
        [[ -f $asset ]] || warn "Expected theme asset is missing: $asset"
    done

    if command -v bat >/dev/null 2>&1; then
        log '==> Building bat cache'
        run bat cache --build
    else
        warn 'bat is unavailable; skipping bat cache build.'
    fi
}

main() {
    case ${1:-} in
        '') ;;
        --dry-run) DRY_RUN=true ;;
        -h|--help)
            usage
            return
            ;;
        *)
            usage >&2
            return 2
            ;;
    esac

    log "==> Dotfiles bootstrap: $ROOT_DIR"
    ensure_directories
    install_packages
    initialize_submodules
    link_configs
    ensure_legacy_zsh_entrypoint
    build_caches_and_verify_assets
    log '==> Bootstrap complete'
}

main "$@"
