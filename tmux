#!/usr/bin/env bash

API="~/Lab/erwan/private"
APP="~/Lab/erwan/www/app"
BACKOFFICE="~/Lab/erwan/www/backoffice"
SUBMARY="~/Lab/erwan/www/submary"
CONFIG="~/.config/nvim"
PLAYGROUND="~/"

createWindow() {
    session=$1
    window=$2
    shift
    shift
    hasWindow=$(tmux list-windows -t $session | grep "$window")
    if [ -z "$hasWindow" ]; then
        cmd="tmux neww -f ~/.config/tmux/tmux.conf -t $session: -n $window -d"
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
    cmd="tmux new -f ~/.config/tmux/tmux.conf -s $session -d -n $window $@ > /dev/null 2>&1"

    echo "Creating Session: $cmd"
    eval $cmd
}

while [ "$#" -gt 0 ]; do
    curr=$1
    shift

    case "$curr" in
    "-api")
        createSession api primary
        createWindow api vim -c $API "~/nvim-osx64/bin/nvim ."
        ;;

    "-app")
        createSession app primary
        createWindow app vim -c $APP "~/nvim-osx64/bin/nvim ."
        ;;

    "-backoffice")
        createSession backoffice primary
        createWindow backoffice vim -c $BACKOFFICE "~/nvim-osx64/bin/nvim ."
        ;;

    "-submary")
        createSession submary primary
        createWindow submary vim -c $SUBMARY "~/nvim-osx64/bin/nvim ."
        ;;

    "-playground")
        createSession playground primary
        createWindow playground vim -c $PLAYGROUND "~/nvim-osx64/bin/nvim ."
        ;;

    "-config")
        createSession config primary
        createWindow config vim -c $CONFIG "~/nvim-osx64/bin/nvim ."
        ;;

    # Work in progress
    *) echo "Unavailable command... $curr"
    esac
done

