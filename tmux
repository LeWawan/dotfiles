#!/usr/bin/env bash

NVIM="~/nvim-osx64/bin/nvim ."
DOCKER_COMPOSE_UP="docker-compose up"
CONFIG="~/.config/nvim"
LAB="~/Lab"
WEB3="~/Lab/web-3"

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
        createWindow config config -c $CONFIG "~/nvim-osx64/bin/nvim ."
        ;;
    "-nlp-marketer")
        createSession nlp-marketer primary
        createWindow nlp-marketer nlp-marketer-webapp -c "~/Lab/nlp-marketer-webapp" $NVIM
        createWindow nlp-marketer nlp-marketer-back -c "~/Lab/nlp-marketer-back" $NVIM
        ;;
    "-tada")
        createSession tada primary
        createWindow tada tada-webapp -c "~/Lab/t2e-bare" $NVIM
        createWindow tada tada-back -c "~/Lab/t2e-bare" $NVIM
        createWindow tada tada-db -c "~/Lab/t2e-bare/master" $DOCKER_COMPOSE_UP
        ;;
    "-fswa")
        createSession fswa primary
        createWindow fswa fswa-front -c "~/Lab/fswav/fswav2-front" $NVIM
        createWindow fswa fswa-back -c "~/Lab/fswav/fswav2-back" $NVIM
        createWindow fswa fswa-proxy -c "~/Lab/fswav/conan-node-proxy" $NVIM
        createWindow fswa fswa-docker -c "~/Lab/fswav" $DOCKER_COMPOSE_UP
        ;;
    "-vsdk")
        createSession vsdk primary
        createWindow vsdk vsdk-daemon-manager -c "~/Lab/fswav/vsdk-daemon/daemon-manager" $NVIM
        createWindow vsdk vsdk-proxy -c "~/Lab/fswav/vsdk-daemon/web-api" $NVIM
        ;;
    "-platform")
        createSession platform primary
        createWindow platform docs -c "~/Lab/platform/docs" $NVIM
        createWindow platform webapp -c "~/Lab/platform/webapp" $NVIM
        createWindow platform "@vivoka/vivoka-api" -c "~/Lab/platform/webapp/packages/vivoka-api" $NVIM

        ;;
    "-random")
        createSession random primary
        createWindow random vim -c $LAB "~/nvim-osx64/bin/nvim ."
        ;;
    "-web3")
        createSession web-3 primary
        createWindow web-3 vim -c $WEB3 "~/nvim-osx64/bin/nvim ."
        ;;

    # Work in progress
    *) echo "Unavailable command... $curr"
    esac
done

