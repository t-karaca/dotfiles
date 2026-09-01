#!/usr/bin/env zsh

fs_path_display() {
    local path=$1

    if [[ -n ${HOME:-} && ($path == "$HOME" || $path == "$HOME"/*) ]]; then
        print -r -- "~${path#"$HOME"}"
    else
        print -r -- "$path"
    fi
}
