#!/usr/bin/env zsh

typeset -g FS_NAVIGATOR_ROOT=${${(%):-%x}:A:h:h:h}
typeset -g FS_NAVIGATOR_BIN=${FS_NAVIGATOR_ROOT}/bin/fs-navigator
typeset -g FS_NAVIGATOR_POPUP=${FS_NAVIGATOR_ROOT}/tmux/scripts/popup

source "${FS_NAVIGATOR_ROOT}/zsh/lib/filesystem.zsh"

fs_navigator() {
    local action_file
    local starting_cwd=${PWD:A}
    local popup_title="Browse: $(fs_path_display "$starting_cwd")"
    local exit_status

    [[ -x $FS_NAVIGATOR_BIN ]] || {
        print -u2 "fs_navigator: navigator is unavailable: $FS_NAVIGATOR_BIN"
        return 1
    }
    action_file=$(mktemp "${TMPDIR:-/tmp}/fs-navigator-action.XXXXXX") || {
        print -u2 'fs_navigator: could not create action buffer'
        return 1
    }

    if [[ -n ${TMUX:-} ]]; then
        "$FS_NAVIGATOR_POPUP" \
            --title "$popup_title" \
            --width 90% \
            --height 85% \
            --cwd "$starting_cwd" \
            -- env FS_NAVIGATOR_ACTION_FILE="$action_file" "$FS_NAVIGATOR_BIN" "$@"
        exit_status=$?
    else
        FS_NAVIGATOR_ACTION_FILE="$action_file" "$FS_NAVIGATOR_BIN" "$@"
        exit_status=$?
    fi

    if ((exit_status == 0)) && [[ -s $action_file ]]; then
        cat -- "$action_file"
    fi
    rm -f -- "$action_file"
    return $exit_status
}
