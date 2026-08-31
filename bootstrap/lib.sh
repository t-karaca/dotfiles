resolve_path() {
    readlink -f -- "$1"
}

link_resolves_to() {
    local source=$1
    local target=$2

    [[ -L $target ]] \
        && [[ $(resolve_path "$target") == "$(resolve_path "$source")" ]]
}
