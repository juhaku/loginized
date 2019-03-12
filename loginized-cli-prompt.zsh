#compdef loginized-cli

_array_contains() {
    retval=false
    for el in $1; do
        [ "$el" == "$2" ] && retval=true && break;
    done;
    echo $retval
}

_loginized-cli() {
    echo "how about here...."
    if [ CURRENT -lt 2 ]; then
        local default_opts=(
            'install:Install theme'
            'list:List available themese'
            'extract:Extract theme to folder'
            'compile:Compile theme to .gresource file'
            'set:Set settings like user list or shield'
            '-h:Help'
            '--help:Help alias'
            '--gui:Use GUI applications on process'
        )
        _describe "Default set of commands" default_opts
    else if [ CURRENT -gt 2 ]; then
        themes=$($(which loginized-cli) list)
        local previous=${words[CURRENT-1]}

        case $previous in
            --gui)
                local default_commands=(
                    'install:Install theme'
                    'list:List available themese'
                    'extract:Extract theme to folder'
                    'compile:Compile theme to .gresource file'
                    'set:Set settings like user list or shield'
                )
                _describe "Default set of commands" default_commands
            ;;
            install)
                compadd $themes
            ;;
            extract)
                compadd $themes
            ;;
            set)
                compadd shield user-list
            ;;
            shield)
                _arguments '*:filename:_files'
            ;;
            user-list)
                compadd true false
            ;;
        esac

        # Define when to use default completion.
        # After theme is complete provide one default completion
        if [ $(_array_contains "$themes" $previous) == true ]; then
            _arguments '*:filename:_files'
        
        # If completion contains compile provide 2 default completions
        elif [[ $(_array_contains "${words}" "compile") == true && ${#words[@]} -lt 5 ]]; then
            _arguments '*:filename:_files'
        fi;
    fi
}

_loginized-cli "$@"
