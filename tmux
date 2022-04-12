#!/usr/bin/env bash

CONFIG="~/.config/nvim"

createWindow() {
    session=$1
    window=$2
    shift
    shift
    hasWindow=$(tmux list-windows -t $session | grep "$window")
    if [ -z "$hasWindow" ]; then
        cmd="tmux -f ~/.config/nvim/tmux.conf neww -t $session: -n $window -d"
        if [ $# -gt 0 ]; then
            cmd="$cmd $@"
        fi
        echo "Creating Window(\"$hasWindow\"): $cmd"
        eval $cmd
    fi
}

createSession() {
    session=$1
    window=$2
    shift
    shift
    cmd="tmux new -f ~/.config/nvim/tmux.conf -s $session -d -n $window $@ > /dev/null 2>&1"

    echo "Creating Session: $cmd"
    eval $cmd
}

while [ "$#" -gt 0 ]; do
    curr=$1
    shift

    case "$curr" in
    "-config")
        createSession config primary
        createWindow config vim -c $CONFIG "~/nvim-osx64/bin/nvim ."
        ;;

    # Work in progress
    *) echo "Unavailable command... $curr"
    esac
done

