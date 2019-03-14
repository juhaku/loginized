#!/bin/bash

args="$@"
user="$(whoami)"

function extractGui() {
    cmd="$@"
    gui=""
    for arg in $(echo $cmd); do
        [ "$arg" == "--gui" ] && gui=$arg && break;
    done

    echo $gui
}

function runAsRoot() {
    cmd="$@"
    if [ "$user" != "root" ]; then 
        if [ "$(extractGui $cmd)" == '--gui' ]; then
            exec pkexec bash -c "$cmd"
        else 
            exec sudo bash -c "$cmd"
        fi;
    fi;
}

function notRecognized {
    echo "action $1 was not recogninzed" && exit 1
}

function open {
    xdg-open $1
}

cliBin=/usr/bin/loginized-cli
completion=/etc/bash_completion.d
cliCompletion=$completion/loginized-cli-prompt

function installCli {
    basePath=$(echo $1 | cut -d ',' -f 1)
    cli=$(echo $1 | cut -d ',' -f 2)
    cliPrompt=$(echo $1 | cut -d ',' -f 3)

    #echo "$cli $cliPrompt"

    if [[ "$cli" != "" && "$cliPrompt" != "" ]]; then
        test ! -d $completion && mkdir -p $completion

        appName=$(basename $basePath)
        sed -i "s|appName=\".*\"|appName="\"$appName\""|" $basePath/$cli
        sed -i "s|basePath=\".*\"|basePath="\"$basePath\""|" $basePath/$cli

        ln -s $basePath/$cli $cliBin
        ln -s $basePath/$cliPrompt $cliCompletion
    fi
}

function installZshCompletion {
    # Install for zsh if zsh is installed and configured
    basePath=$(echo $1 | cut -d ',' -f 1)
    if [[ -f ${HOME}/.zshrc && "$(which zsh)" != "" && "$(cat ${HOME}/.zshrc | grep -o $basePath/completion)" == "" ]]; then
        # If auto load is added then then update fpath and rebuild the completion
        if [ "$(grep "autoload -U compinit \&\& compinit" ${HOME}/.zshrc)" != "" ]; then
            sed -i "s|autoload -U compinit \&\& compinit|# Automatic fpath update for loginized\nfpath=($basePath/completion \$fpath)\n\nautoload -U compinit \&\& compinit|" ${HOME}/.zshrc
            rm -f ${HOME}/.zcompdump
        fi
    fi
}

function removeCli {
    unlink $cliBin
    unlink $cliCompletion
}

function main {
    case $1 in
        open)
            open $2
        ;;
        install-cli)
            installZshCompletion $2
            # Install for bash
            runAsRoot $0 $args
            if [ "$user" == "root" ]; then
                installCli $2
            fi
        ;;
        remove-cli)
            runAsRoot $0 $args
            if [ "$user" == "root" ]; then
                removeCli $2
            fi;
        ;;
        *)
            notRecognized $1
        ;;
    esac
}

# extract gui from args
argList=""
for arg in $(echo $args); do
    [ $arg != "--gui" ] && argList="$argList $arg"
done

main $argList
