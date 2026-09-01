#!/usr/bin/env bash

set -euo pipefail

extract_filename() {
  local line="$1"
  local clean_line
  local filename

  clean_line=$(printf '%s' "$line" | perl -pe 's/\e\[[0-9;]*[a-zA-Z]//g')

  filename=$(printf '%s' "$clean_line" | awk '{for(i=2;i<=NF;i++) printf "%s%s", $i, (i<NF ? " " : "")}')

  filename="${filename%% ->*}"

  echo "$filename"
}

preview() {
    (($# == 1)) || {
        printf 'fzf-navigator-tools: preview expects one selected line\n' >&2
        return 2
    }

    local cwd
    local filename
    local resulting_path
    cwd=$(< /tmp/fzf-navigator/cwd)
    filename=$(extract_filename "$1")
    resulting_path="${cwd%/}/$filename"
    preview-dispatcher "$resulting_path"
}

prompt_path() {
    local path=$1

    if [[ -n ${HOME:-} && ($path == "$HOME" || $path == "$HOME"/*) ]]; then
        printf '~%s' "${path#"$HOME"}"
    else
        printf '%s' "$path"
    fi
}

render_navigation_actions() {
    local path=$1
    local display_path
    display_path=$(prompt_path "$path")

    printf 'change-prompt(%s > )+clear-query+reload(eza --oneline --icons always --color always --no-quotes -- %q)+first\n' \
        "$display_path" "$path"
}

navigate() {
    (($# == 1)) || {
        printf 'fzf-navigator-tools: navigate expects one path\n' >&2
        return 2
    }

    local cwd
    local filename
    local resulting_path
    cwd=$(< /tmp/fzf-navigator/cwd)
    filename=$(extract_filename "$1")
    resulting_path="${cwd%/}/$filename"
    [[ -d $resulting_path ]] || {
        printf 'fzf-navigator-tools: not a directory: %s\n' "$resulting_path" >&2
        return 1
    }

    printf '%s\n' "$resulting_path" > /tmp/fzf-navigator/cwd
    render_navigation_actions "$resulting_path"
}

parent() {
    (($# == 0)) || {
        printf 'fzf-navigator-tools: parent expects no arguments\n' >&2
        return 2
    }

    local cwd
    local resulting_path
    cwd=$(< /tmp/fzf-navigator/cwd)
    if [[ $cwd == / ]]; then
        resulting_path=/
    else
        resulting_path=${cwd%/*}
        [[ -n $resulting_path ]] || resulting_path=/
    fi

    [[ -d $resulting_path ]] || {
        printf 'fzf-navigator-tools: not a directory: %s\n' "$resulting_path" >&2
        return 1
    }

    printf '%s\n' "$resulting_path" > /tmp/fzf-navigator/cwd
    render_navigation_actions "$resulting_path"
}

start() {
    (($# == 0)) || {
        printf 'fzf-navigator-tools: start expects no arguments\n' >&2
        return 2
    }

    local resulting_path
    resulting_path=$(< /tmp/fzf-navigator/start-cwd)
    [[ -d $resulting_path ]] || {
        printf 'fzf-navigator-tools: not a directory: %s\n' "$resulting_path" >&2
        return 1
    }

    printf '%s\n' "$resulting_path" > /tmp/fzf-navigator/cwd
    render_navigation_actions "$resulting_path"
}

usage() {
    printf 'Usage: %s <command> [arguments...]\n' "${0##*/}"
    printf '\nCommands:\n'
    printf '  preview <selected-line>  Preview an fzf selection\n'
    printf '  navigate <selected-line> Navigate into a selected directory\n'
    printf '  parent                    Navigate to the parent directory\n'
    printf '  start                     Return to the starting directory\n'
}

main() {
    (($# > 0)) || {
        usage >&2
        return 2
    }

    local command=$1
    shift

    case "$command" in
        -h|--help)
            (($# == 0)) || {
                usage >&2
                return 2
            }
            usage
            ;;
        preview)
            preview "$@"
            ;;
        navigate)
            navigate "$@"
            ;;
        parent)
            parent "$@"
            ;;
        start)
            start "$@"
            ;;
        *)
            printf 'fzf-navigator-tools: unknown command: %s\n' "$command" >&2
            usage >&2
            return 2
            ;;
    esac
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    main "$@"
fi
