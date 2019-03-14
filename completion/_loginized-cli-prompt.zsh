#compdef loginized-cli

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
    local -a themes
    for theme in $($(which loginized-cli) list); do
        themes+=("$theme")
    done

    _describe 'theme' themes
}

_loginized-cli() {
    local context state state_descr line
    typeset -A opt_args

    _arguments -C \
        '--gui[Run with GUI applications]' \
        '(-h --help)'{-h,--help}'[Show usage information]:_guard "[^.+]"' \
        '1: :_loginized-cli_cmds' \
        '*:: :->args'
    case $state in
        args)
            case $words[1] in
                install)
                    _arguments \
                        '1: :_loginized-cli_themes' \
                        '2:: :_files'
                ;;
                extract)
                    _arguments \
                        '1: :_loginized-cli_themes' \
                        '2:: :_directories'
                ;;
                compile)
                    _arguments \
                        '1: :_directories' \
                        '2:: :_directories'
                ;;
                set)
                    _arguments \
                        '1: :(user-list shield)' \
                        '*:: :->config_args'
                ;;
            esac
        ;;
    esac

    case $state in
        config_args)
            case $words[1] in
                shield)
                    _arguments \
                        '1:: :_files'
                ;;
                user-list)
                    _arguments \
                        '1: :(true false)'
                ;;
            esac
        ;;
    esac

    return 0
}

_loginized-cli "$@"
