#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
DRY_RUN=false

source "$ROOT_DIR/bootstrap/lib.sh"

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

zsh_xdg_ready() {
    local zshenv_source
    local zsh_config_source

    zshenv_source=$(resolve_path "$ROOT_DIR/zsh/.zshenv")
    zsh_config_source=$(resolve_path "$ROOT_DIR/zsh")
    link_resolves_to "$zshenv_source" "$HOME/.zshenv" \
        && link_resolves_to "$zsh_config_source" "$HOME/.config/zsh"
}

retire_legacy_zshrc() {
    local target="$HOME/.zshrc"
    local backup

    log '==> Migrating legacy Zsh entrypoint'
    if ! zsh_xdg_ready; then
        if "$DRY_RUN"; then
            log '[dry-run] would verify XDG Zsh links before retiring ~/.zshrc.'
        else
            warn 'XDG Zsh links are not ready; preserving ~/.zshrc.'
            return
        fi
    fi

    if [[ ! -e $target && ! -L $target ]]; then
        log 'No legacy ~/.zshrc remains.'
        return
    fi

    backup="$target.backup-$(date +%Y%m%d%H%M%S)"
    if [[ -e $backup || -L $backup ]]; then
        warn "Backup path already exists: $backup"
        return
    fi

    if confirm "Back up legacy $target to $backup now that XDG Zsh is configured?"; then
        log "Backing up $target to $backup"
        run mv -- "$target" "$backup"
    else
        log "Leaving legacy Zsh entrypoint unchanged: $target"
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
    local line
    local marker
    local path
    local found_uninitialized=false

    log '==> Initializing submodules'
    if ! command -v git >/dev/null 2>&1; then
        warn 'Git is unavailable; submodules were not initialized.'
        return
    fi

    while IFS= read -r line; do
        marker=${line:0:1}
        read -r _ path _ <<<"${line:1}"
        case $marker in
            -)
                found_uninitialized=true
                run git -C "$ROOT_DIR" submodule update --init --recursive -- "$path"
                ;;
            +|U)
                warn "Preserving user-managed submodule state: ${line:1}"
                ;;
        esac
    done < <(git -C "$ROOT_DIR" submodule status --recursive)

    if ! "$found_uninitialized"; then
        log 'All submodules are already initialized or user-managed.'
    fi
}

link_config() {
    local source=$1
    local target=$2
    local source_path
    local backup

    source_path=$(resolve_path "$source")
    if [[ ! -e $source_path ]]; then
        warn "Source does not exist: $source"
        return
    fi

    if [[ ! -e $target && ! -L $target ]]; then
        log "Linking $target -> $source_path"
        run ln -s "$source_path" "$target"
        return
    fi

    if link_resolves_to "$source" "$target"; then
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
    link_config "$ROOT_DIR/git" "$HOME/.config/git"
    link_config "$ROOT_DIR/fzf" "$HOME/.config/fzf"
    link_config "$ROOT_DIR/zsh" "$HOME/.config/zsh"
    link_config "$ROOT_DIR/zsh/.zshenv" "$HOME/.zshenv"
}

migrate_local_git_config() {
    local target="$HOME/.gitconfig"
    local backup
    local temporary
    local key
    local has_shared_settings=false
    local -a shared_keys=(
        core.pager
        interactive.difffilter
        delta.navigate
        delta.syntax-theme
        merge.tool
        merge.conflictstyle
        init.defaultbranch
        pull.rebase
    )

    log '==> Removing duplicated shared Git settings from local config'
    if [[ ! -f $target ]]; then
        log 'No machine-local ~/.gitconfig requires migration.'
        return
    fi

    for key in "${shared_keys[@]}"; do
        if git config --file "$target" --get-all "$key" >/dev/null 2>&1; then
            has_shared_settings=true
            break
        fi
    done

    if ! "$has_shared_settings"; then
        log 'No duplicated shared Git settings found in ~/.gitconfig.'
        return
    fi

    backup="$target.backup-$(date +%Y%m%d%H%M%S)"
    if [[ -e $backup || -L $backup ]]; then
        warn "Backup path already exists: $backup"
        return
    fi

    if "$DRY_RUN"; then
        log "[dry-run] would back up $target to $backup"
        log '[dry-run] would remove shared pager, Delta, merge, init, and pull settings from ~/.gitconfig'
        return
    fi

    if ! confirm "Back up $target and remove duplicated shared Git settings?"; then
        log 'Leaving duplicated local Git settings unchanged.'
        return
    fi

    temporary=$(mktemp "${target}.tmp.XXXXXX")
    trap 'rm -f -- "$temporary"' RETURN
    cp -p -- "$target" "$backup"
    cp -p -- "$target" "$temporary"
    for key in "${shared_keys[@]}"; do
        git config --file "$temporary" --unset-all "$key" >/dev/null 2>&1 || true
    done
    mv -- "$temporary" "$target"
    trap - RETURN
    log "Backed up local Git configuration to $backup"
}

initialize_theme() {
    local theme

    log '==> Initializing theme indirection'
    if [[ ! -x $ROOT_DIR/bin/theme-set ]]; then
        warn 'theme-set is unavailable; skipping theme initialization.'
        return
    fi

    if theme=$("$ROOT_DIR/bin/theme-set" status 2>/dev/null); then
        log "Theme already initialized: $theme"
    else
        log 'No theme is selected; defaulting to dark.'
        run "$ROOT_DIR/bin/theme-set" dark
    fi
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

run_doctor() {
    log '==> Running doctor'
    if [[ ! -x $ROOT_DIR/bin/doctor ]]; then
        warn 'doctor is unavailable; skipping validation.'
        return
    fi

    if "$DRY_RUN"; then
        run "$ROOT_DIR/bin/doctor"
    elif ! "$ROOT_DIR/bin/doctor"; then
        warn 'doctor reported required issues; review its output above.'
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
    migrate_local_git_config
    initialize_theme
    retire_legacy_zshrc
    build_caches_and_verify_assets
    run_doctor
    log '==> Bootstrap complete'
}

main "$@"
