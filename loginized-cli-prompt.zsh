#compdef loginized-cli

# _array_contains() {
#     retval=false
#     for el in $1; do
#         [ "$el" == "$2" ] && retval=true && break;
#     done;
#     echo $retval
# }

_loginized-cli_cmds() {
    local -a cmds
    cmds=(
        'install:Install theme as login theme'
        'list:List available themes'
        'extract:Extract theme to folder'
        'compile:Compile theme to .gresource file'
        'set:Set settings like user list or shield'
    )
    _describe 'command' cmds
}

_loginized-cli_themes() {
    echo $($(which loginized-cli) list)
}

_loginized-cli() {
    local context state state_descr line
    local -a cmds
    typeset -A opt_args

    

    
    # if [ CURRENT -lt 2 ]; then
    
    # echo "fooooooo"
    #     local default_opts=(
    #         'install:Install theme'
    #         'list:List available themese'
    #         'extract:Extract theme to folder'
    #         'compile:Compile theme to .gresource file'
    #         'set:Set settings like user list or shield'
    #         '-h:Help'
    #         '--help:Help alias'
    #         '--gui:Use GUI applications on process'
    #     )
    #     _describe -t default_opts "Default set of commands" default_opts

        # _arguments \
        #     ': :->commands' \
        #     '(-h --help)'{-h,--help}'[Help]'
        # echo "fooooooo ${#words[@]}"
        # length=${#words[@]}
        # current=${words[$length]}
        # themes=$($(which loginized-cli) list)
        # echo $current length $length
        # commands=(
        #     'install:Install theme'
        #     'list:List available themese'
        #     'extract:Extract theme to folder'
        #     'compile:Compile theme to .gresource file'
        #     'set:Set settings like user list or shield'
        #     # '-h:Help'
        #     # '--help:Help alias'
        #     # '--gui:Use GUI applications on process'
        # )
        # _describe -t commands 'commands' commands
        _arguments -C \
            '1: :_loginized-cli_cmds' \
            '*::arg:->args'
        case $state in
            args)
                case $words[1] in
                    install)
                        compadd $($(which loginized-cli) list)
                        # _arguments \
                        #     '1: :_loginized-cli_themes'
                    ;;
                    extract)
                        _arguments \
                            '1: :_loginized-cli_themes'
                    ;;
                esac
            ;;
        esac
        
    # else if [ CURRENT -gt 2 ]; then
    #     themes=$($(which loginized-cli) list)
    #     local previous=${words[CURRENT-1]}

    #     case $previous in
    #         --gui)
    #             local default_commands=(
    #                 'install:Install theme'
    #                 'list:List available themese'
    #                 'extract:Extract theme to folder'
    #                 'compile:Compile theme to .gresource file'
    #                 'set:Set settings like user list or shield'
    #             )
    #             _describe "Default set of commands" default_commands
    #         ;;
    #         install)
    #             compadd $themes
    #         ;;
    #         extract)
    #             compadd $themes
    #         ;;
    #         set)
    #             compadd shield user-list
    #         ;;
    #         shield)
    #             _arguments '*:filename:_files'
    #         ;;
    #         user-list)
    #             compadd true false
    #         ;;
    #     esac

    #     # Define when to use default completion.
    #     # After theme is complete provide one default completion
    #     if [ $(_array_contains "$themes" $previous) == true ]; then
    #         _arguments '*:filename:_files'
        
    #     # If completion contains compile provide 2 default completions
    #     elif [[ $(_array_contains "${words}" "compile") == true && ${#words[@]} -lt 5 ]]; then
    #         _arguments '*:filename:_files'
    #     fi
    # fi

    return 0
}

_loginized-cli "$@"
