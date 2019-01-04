#!/bin/bash

args="$@"

function notRecognized {
    echo "action $1 was not recogninzed" && exit 1
}

function open {
    xdg-open $1
}

function main {
case $1 in
        open)
            open $2
        ;;
        *)
            notRecognized $1
        ;;
    esac
}

main $args
