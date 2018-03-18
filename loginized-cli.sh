#!/bin/bash

# Core functionalities to alter login theme
# This application provides easy access api to install specific theme as login theme for GNOME desktop 
# environment. 

# Global variables
# defaultBackground=noise-texture.png
gs=gnome-shell-theme.gresource
executionPath=`pwd`
workDir=/tmp/shell
gdm3=/etc/alternatives/gdm3.css

# Determine this dynamically later
installPath=""

function notRecognized {
    echo "action $1 was not recogninzed, use ?, -h, --help flags for help" && exit 1
}

function help {
    echo "Usage: loginized-cli.sh [-h | --help | ?] | [action] [theme] [image]
Provides functionality to alternate login gnome shell theme. Theme must be found under /usr/share/themes in order to
list as option.
Definition of arguments.
 -h | --help | ? Shows help
 install ....... Install action. This needs two additional parameters such as theme and image
 list .......... Lists themes available in /usr/share/themes folder
 start ......... This is startup action, usually there is no need to call this manually
 reboot ........ Reboots system no questions asked, there is no need to call this manually
 
Examples.
 loginized-cli.sh list    This example will list available themes
 
 loginized-cli.sh install Adapta my-background.png    This example will install Adapta theme from /usr/share/themes with 
                                                      my-bakcground.png as background image
 
 loginized-cli.sh install Default    This example will install default theme as login theme
 
 loginized-cli.sh install Adapta    This example will install Adapta theme as login theme without any modifications"
}

function extract {
    theme=$1
    if [ "$theme" == "Default" ]; then
        location=$installPath/default
    else
        location=/usr/share/themes/$theme/gnome-shell
    fi;
    gsl=$location/$gs
    
    test ! -d $workDir/theme/assets/dot && mkdir -p $workDir/theme/assets/dot
    test ! -d $workDir/theme/icons && mkdir -p $workDir/theme/icons
    for r in $(gresource list $gsl); do
        gresource extract $gsl $r > $workDir${r/#\/org\/gnome\/shell}
    done
}

# Install gdm3 css file if it is being used by the operating system. Ubuntu newer than 16.10 uses it.
function installGdm3Css {
    from=$1
    if [ -f $gdm3 ]; then 
        cp $from $gdm3
    fi;
}

# Install specific theme with defaults as login theme
function installThemeWithDefaults {
    theme=$1
    test ! -d /usr/share/themes/$theme && echo "Theme not found (/usr/share/themes/$theme), cannot perform install" && exit 1;
    cp /usr/share/themes/$theme/gnome-shell/$gs /usr/share/gnome-shell/$gs
    installGdm3Css /usr/share/themes/$theme/gnome-shell/gnome-shell.css
}

# Install default theme what has been backed up during initial startup
function installDefault {
    test ! -f $installPath/default/$gs && echo "Default theme not found ($installPath/default/$gs), cannot perform install" && exit 1;
    cp $installPath/default/$gs /usr/share/gnome-shell/$gs
    installGdm3Css $installPath/default/gdm3.css
}

# Install theme $1=theme, $2=image
function install {
    theme=$1
    image=$2
    if [[ "$theme" == "Default" && "$image" == "" ]]; then 
        installDefault
    
    elif [ "$image" == "" ]; then 
        installThemeWithDefaults $theme
    
    else 
        test ${#theme} -eq 0 && echo "Theme is not defined $theme, cannot continue installation" && exit 1;
        test ${#image} -eq 0 && echo "Image is not defined $image, cannot continue installation" && exit 1;
        extract $theme

        dialogCss="#lockDialogGroup { background: #2e3436 url(\"resource:\/\/\/org\/gnome\/shell\/theme\/$image\"); background-repeat: none; background-size: cover; }"

        location=/usr/share/gnome-shell
        workLocation=$workDir/theme
        
        cp $installPath/$image $workLocation/.

        sed -i "/#lockDialogGroup/,/}/ { /#lockDialogGroup/ { s/.*// }; /}/ ! { s/.*// }; /}/ { s/.*/$dialogCss/ }; }" $workLocation/gnome-shell.css
        
        #Generate gresource xml file for current theme
        resourceFiles=$(for file in $(find $workLocation -type f | sed "s|$workLocation||" | cut -c 2-); do echo "<file>$file</file>"; done)
        gresourceXml="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<gresources>
  <gresource prefix=\"/org/gnome/shell/theme\">
    $resourceFiles
  </gresource>
</gresources>"
        echo $gresourceXml > $workLocation/$gs.xml

        glib-compile-resources --sourcedir=$workLocation $workLocation/$gs.xml
        
        cp $workLocation/$gs "$location/$gs"
        installGdm3Css $workLocation/gnome-shell.css
        
        #rm $gs
        # rm -r $workDir
    fi
}

# List themes available
function list {
    ls /usr/share/themes
}

function updateDefaultTheme {
    extract Default
    # Basically update gdm3 css if needed
    if [[ -f $gdm3 &&  ! -f $installPath/default/gdm3.css ]]; then
        cp $workDir/theme/gnome-shell.css installPath/default/gdm3.css
    fi;
    rm $workDir
}

# On start functionality
function onStart {
    installPath=${HOME}/.config/loginized
    test ! -d $installPath && mkdir -p $installPath
    # Take a backup at the beginning if back up does not exists
    if [ ! -f $installPath/default/$gs ]; then
        test ! -d $installPath/default && mkdir -p $installPath/default
        cp /usr/share/gnome-shell/$gs $installPath/default/$gs
    fi

    if [[ -f $gdm3 &&  ! -f $installPath/default/gdm3.css ]]; then
        cp $gdm3 $installPath/default/gdm3.css
    fi;

    echo $installPath
}

# Reboots system no questions asked
function fastReboot {
    rebootBin=$(which reboot)
    $rebootBin now
}

function reboot {
    read -p "Changes will take affect after reboot, Reboot now? [Y/n]: " decision
    echo $decision
    if [[ "$decision" == "" || "$decision" == "y" || "$decision" == "Y" ]]; then 
        fastReboot
    fi;
}

function setupApplication {
    cli=$(echo $1 | cut -d ',' -f 1)
    desktop=$(echo $1 | cut -d ',' -f 2)
    appFolder=$(echo $1 | cut -d ',' -f 3)

    if [ "$cli" != "" ]; then
        cp $cli /usr/bin/loginized-cli    
    fi;

    # TODO missing icon

    if [ "$desktop" != "" ]; then
        cp $desktop /usr/share/applications/loginized.desktop
        cp -r $appFolder /usr/lib/loginized
        ln -s /usr/bin/loginized /usr/lib/loginized/loginized
    fi;
}

# Determine whether we need help
if [[  "$1" == "" || "$1" == "-h" || "$1" == "--help" || "$1" == "?" ]]; then help && exit 0; fi

# Main functions
# $1 = option, $2 = gui, $3 = installPath, $4 = theme, $5 = image
case $1 in
    extract)
        extract $2
    ;;
    reboot)
        fastReboot
    ;;
    install)
        if [ "$2" == "gui" ]; then
            installPath=$3
            install $4 $5
        else
            installPath=$2
            install $3 $4
            # Only offer reboot option if this was executed non GUI
            reboot
        fi;
    ;;
    list)
        list
    ;;
    start)
        onStart
    ;;
    updateDefault)
        installPath=$2
        updateDefaultTheme
    ;;
    setupApp)
        setupApplication $2
    ;;
    *)
        notRecognized $1
    ;;
esac

# If we are not in execution path, return to execution path
if [ "$executionPath" != "$(pwd)" ]; then cd $executionPath; fi;
