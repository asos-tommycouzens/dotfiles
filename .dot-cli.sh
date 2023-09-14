#!/bin/zsh

function dot_help() {
    echo "Usage: dot [subcommand] [options]"
    echo "Subcommands:"
    echo "h    help    Show this help message"
    echo "ls    ls      See a list of your configured dotfiles"
    echo "s    source  Source your dotfiles"
    echo "o    open    Open dotfiles in your editor"
    echo "u    update  Execute the update subcommand"
}

function dot_ls() {
    ls -a1 ~/code/dotfiles | grep '^\.'
}

function dot_open() {
    dot_path=~/code/dotfiles

    if [ -n "$1" ]; then
        dot_path="$dot_path/.$1"
    fi

    echo "Opening $dot_path..."
    code "$dot_path"
}

function dot_source() {
    echo "Sourcing dotfiles..."
    source ~/.zshrc
}

function dot_update() {
    echo "Executing 'dot update'..."
    cd ~/code/mac-dev-playbook
    ansible-playbook main.yml --tags dotfiles
    cd -
    source ~/.zshrc
}

# main
function dot() {
    if [ -z "$1" ]; then
        echo "Error: No subcommand provided."
        help
        exit 0
    fi

    subcommand=$1
    shift

    case $subcommand in
        help || h)
            dot_help
            ;;
        ls)
            dot_ls
            ;;
        source || s)
            dot_source
            ;;
        open || o)
            dot_open $1
            ;;
        update || u)
            dot_update
            ;;
        *)
            echo "Error: Unknown subcommand '$subcommand'"
            dot_help
            exit 0
            ;;
    esac

}