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

open() {
    (($# == 1)) || {
        printf 'fzf-navigator-tools: open expects one selected line\n' >&2
        return 2
    }

    local cwd
    local filename
    local resulting_path
    cwd=$(< /tmp/fzf-navigator/cwd)
    filename=$(extract_filename "$1")
    resulting_path="${cwd%/}/$filename"
    if [[ -d "$resulting_path" ]]; then
        nohup xdg-open "$resulting_path" >/dev/null 2>&1 & disown
    else
        cmd="xdg-open '$resulting_path'"
        echo "execute(printf '\\033[2J\\033[H' > /dev/tty; $cmd < /dev/tty > /dev/tty)+refresh-preview"
    fi
}

prompt_path() {
    local path=$1

    if [[ -n ${HOME:-} && ($path == "$HOME" || $path == "$HOME"/*) ]]; then
        printf '~%s' "${path#"$HOME"}"
    else
        printf '%s' "$path"
    fi
}

sort_options() {
    case $(< /tmp/fzf-navigator/sort-mode) in
        recent) printf '%s' '--sort=modified --group-directories-last' ;;
        ascending) printf '%s' '--sort=name --group-directories-first' ;;
        descending) printf '%s' '--sort=name --reverse --group-directories-last' ;;
        *)
            printf 'fzf-navigator-tools: invalid sort mode\n' >&2
            return 1
            ;;
    esac
}

sort_label() {
    case $(< /tmp/fzf-navigator/sort-mode) in
        recent) printf '%s' 'Recent' ;;
        ascending) printf '%s' 'A-Z' ;;
        descending) printf '%s' 'Z-A' ;;
        *)
            printf 'fzf-navigator-tools: invalid sort mode\n' >&2
            return 1
            ;;
    esac
}

render_navigation_actions() {
    local path=$1
    local display_path
    local label
    local query_action=''
    local sort_flags
    display_path=$(prompt_path "$path")
    label=$(sort_label)
    sort_flags=$(sort_options)
    [[ ${2:-true} == true ]] && query_action='+clear-query'

    printf 'change-header(Sort: %s)+change-prompt(%s > )%s+reload(eza --oneline --icons always --color always --no-quotes %s -- %q)+first\n' \
        "$label" "$display_path" "$query_action" "$sort_flags" "$path"
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

git_root() {
    (($# == 0)) || {
        printf 'fzf-navigator-tools: git-root expects no arguments\n' >&2
        return 2
    }

    local resulting_path
    resulting_path=$(< /tmp/fzf-navigator/git-root)
    [[ -n $resulting_path ]] || {
        printf 'fzf-navigator-tools: no git root for the starting directory\n' >&2
        return 1
    }
    [[ -d $resulting_path ]] || {
        printf 'fzf-navigator-tools: not a directory: %s\n' "$resulting_path" >&2
        return 1
    }

    printf '%s\n' "$resulting_path" > /tmp/fzf-navigator/cwd
    render_navigation_actions "$resulting_path"
}

toggle_sort() {
    (($# == 0)) || {
        printf 'fzf-navigator-tools: toggle-sort expects no arguments\n' >&2
        return 2
    }

    local current_mode
    local next_mode
    local cwd
    current_mode=$(< /tmp/fzf-navigator/sort-mode)
    case $current_mode in
        ascending) next_mode=recent ;;
        recent) next_mode=descending ;;
        descending) next_mode=ascending ;;
        *)
            printf 'fzf-navigator-tools: invalid sort mode: %s\n' "$current_mode" >&2
            return 1
            ;;
    esac

    printf '%s\n' "$next_mode" > /tmp/fzf-navigator/sort-mode
    cwd=$(< /tmp/fzf-navigator/cwd)
    render_navigation_actions "$cwd" false
}

usage() {
    printf 'Usage: %s <command> [arguments...]\n' "${0##*/}"
    printf '\nCommands:\n'
    printf '  preview <selected-line>  Preview an fzf selection\n'
    printf '  open <selected-line>     Open an fzf selection\n'
    printf '  navigate <selected-line> Navigate into a selected directory\n'
    printf '  parent                    Navigate to the parent directory\n'
    printf '  start                     Return to the starting directory\n'
    printf '  git-root                  Return to the launch Git root\n'
    printf '  toggle-sort               Cycle the directory sort mode\n'
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
        open)
            open "$@"
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
        git-root)
            git_root "$@"
            ;;
        toggle-sort)
            toggle_sort "$@"
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
