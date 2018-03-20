#!/bin/bash

# Core functionalities to alter login theme
# This application provides easy access api to install specific theme as login theme for GNOME desktop 
# environment. 

# Global variables
# defaultBackground=noise-texture.png
gs=gnome-shell-theme.gresource
executionPath=$(pwd)
workDir=/tmp/shell
gdm3=/etc/alternatives/gdm3.css

# Determine this dynamically later
installPath=""

function notRecognized {
    echo "action $1 was not recogninzed, use ?, -h, --help flags for help" && exit 1
}

function help {
    echo "Usage: loginized-cli.sh [-h | --help | ?] | [action] [theme] [image]
Provides functionality to alternate login gnome shell theme. Theme must be found under 
/usr/share/themes in order to list as option.
Definition of arguments.
 -h | --help | ? .... Shows help
 install ............ Install theme. First parameter is the theme itself that is being installed and
                      the second and parameter is additional background image with path to it
                      if installed via cli. 
 list ............... Lists themes available in /usr/share/themes folder. Note all themes that are 
                      located there is not available this is due missing gnome-shell-theme.gresource
                      for one reason or another. In such scenario you could manually compile the theme
                      using compile option of this tool and place it under gnome-shell folder of
                      the theme. This would make the theme available for this tool.
 start .............. This is startup action, usually there is no need to call this manually
 reboot ............. Reboots system no questions asked, there is no need to call this manually
 extract ............ Extracts theme to /tmp/shell/theme folder. Additionally target folder 
                      may be provided where to extract content.
 compile ............ Compiles theme and places it to provided folder.
 
Examples.
 loginized-cli.sh list    This will list available themes. These themes are available for this tool.
 
 loginized-cli.sh install /home/user/.config/loginized Adapta my-background.png    
    This example will install Adapta theme from /usr/share/themes with my-bakcground.png as 
    background image
 
 loginized-cli.sh install /home/user/.config/loginized Default
    This example will install default theme as login theme
 
 loginized-cli.sh install /home/user/.config/loginized Adapta
    This example will install Adapta theme as login theme without any modifications
        
 loginized-cli.sh extract Adapta-Eta
    This will extract Adata-Eta theme from /usr/share/themes to extract folder. If folder is not 
    found it will be created
 
 loginized-cli.sh extract Adapta-Nokto /path/to/my/custom/location
    This will extract Adapta-Nokto theme from /usr/share/themes place extracted content to provided
    custom location. Custom location must be a folder. This will also create a folder like name of 
    the theme + extracted e.g Adapta-Nokto-extracted to provided custom location

 loginized-cli.sh compile /path/to/theme/root/folder /path/to/target/folder
    This will compile theme sources to .gresource file in given source path. Theme root folder
    must containt the gnome-shell.css file and rest of sources accordingly. Target folder must be a 
    valid location and it is used to place the compiled .gresource file.
    
Copyright (C) 2018 Juha Kukkonen - Licensed under <https://www.gnu.org/licenses/gpl-3.0.txt>
This program is provided AS IS and comes with ABSOLUTELY NO WARRANTY"
}

# Extracts theme (.gresource)
function extract {
    theme=$1
    
    # Clear existing theme content from work dir so there wont be any funny collisions
    test -d $workDir/theme && rm -r $workDir/theme
    
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

    if [ -d "$2" ]; then
        mkdir $2/"$theme"-extracted
        cp -r /tmp/shell/theme $2/"$theme"-extracted 
    fi;
}

trimmed=""
# Trims last slash from provider parameter
function trimLastSlash {
    if [ "$(echo $1 | rev | cut -c 1)" == "/" ]; then
        trimmed=$(echo $1 | rev | cut -c 2- | rev)
    else 
        trimmed=$1
    fi;
}

# Compiles theme in source location and places compiled theme to target location
function compile {
    trimLastSlash $1
    source=$trimmed
    trimLastSlash $2
    target=$trimmed

    #Generate gresource xml file for current theme
    resourceFiles=$(for file in $(find $source -type f | sed "s|$source||" | cut -c 2-); do echo "<file>$file</file>"; done)
    gresourceXml="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<gresources>
  <gresource prefix=\"/org/gnome/shell/theme\">
    $resourceFiles
  </gresource>
</gresources>"
    echo $gresourceXml > $source/$gs.xml

    glib-compile-resources --sourcedir=$source $source/$gs.xml
    
    cp $source/$gs "$target/$gs"
}

# Install gdm3 css file if it is being used by the operating system. Ubuntu newer than 16.10 uses it
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

# Install theme $1=theme, $2=image, $3=gui
function install {
    theme=$1
    image=$2
    gui=$3
    if [[ "$theme" == "Default" && "$image" == "" ]]; then 
        installDefault
    
    elif [ "$image" == "" ]; then 
        installThemeWithDefaults $theme
    
    else 
        test ${#theme} -eq 0 && echo "Theme is not defined $theme, cannot continue installation" && exit 1;
        test ${#image} -eq 0 && echo "Image is not defined $image, cannot continue installation" && exit 1;
        extract $theme

        tempImage=$(basename $image)
        dialogCss="#lockDialogGroup { background: #2e3436 url(\"resource:\/\/\/org\/gnome\/shell\/theme\/$tempImage\"); background-repeat: none; background-size: cover; }"

        location=/usr/share/gnome-shell
        workLocation=$workDir/theme
        
        # When processed from gui image is saved to $installPath
        if [ "$gui" == "gui" ]; then
            cp $installPath/$image $workLocation/.
        else 
            cp $image $workLocation/.        
        fi;

        sed -i "/#lockDialogGroup/,/}/ { /#lockDialogGroup/ { s/.*// }; /}/ ! { s/.*// }; /}/ { s/.*/$dialogCss/ }; }" $workLocation/gnome-shell.css
        
        # Compile the modified theme and install it
        compile $workLocation "$location"
        
        installGdm3Css $workLocation/gnome-shell.css
        
        # Clear work dir after installation
        rm -r $workDir
    fi
}

# List themes available. Themes must have .gresource file in order it to be available for install. Default will be always available.
function list {
    echo $(for theme in $(ls /usr/share/themes); do test -f /usr/share/themes/$theme/gnome-shell/gnome-shell-theme.gresource && echo $theme; done) Default
}

# Used to update default themes gdm3.css if system is using one
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
    gui=$1
    installPath=${HOME}/.config/Loginized
    test ! -d $installPath && mkdir -p $installPath
    # Take a backup at the beginning if back up does not exists
    if [ ! -f $installPath/default/$gs ]; then
        test ! -d $installPath/default && mkdir -p $installPath/default
        cp /usr/share/gnome-shell/$gs $installPath/default/$gs
    fi

    if [[ -f $gdm3 &&  ! -f $installPath/default/gdm3.css ]]; then
        cp $gdm3 $installPath/default/gdm3.css
    fi;

    # By default only gui application needs information of config path
    [ "$gui" != "" ] && echo $installPath
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
    icon=$(echo $1 | cut -d ',' -f 4)

    if [ "$cli" != "" ]; then
        cp $cli /usr/bin/loginized-cli
        loginized-cli start
    fi;

    if [ "$desktop" != "" ]; then
        cp $desktop /usr/share/applications/Loginized.desktop
        cp -r $appFolder /usr/lib/loginized
        cp $icon /usr/share/pixmaps/loginized.png
        ln -s /usr/lib/loginized/Loginized /usr/bin/loginized
    fi;
}

# Determine whether we need help
if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "?" ]]; then help && exit 0; fi

args="$@"
# Main functions
# $1 = option, $2 = gui, $3 = installPath, $4 = theme, $5 = image
case $1 in
    extract)
        extract $2 $3
    ;;
    compile)
        compile $2 $3
    ;;
    reboot)
        fastReboot
    ;;
    install)
        if [ "$2" == "gui" ]; then
            installPath=$3
            install $4 $5 $2
        else
            # Startup configuration in order to enable all functionalities correctly
            onStart
            user=$(whoami)
            # On cli version we make sure that command is executed with correct rights.
            [ "$user" == "root" ] || exec sudo bash -c "$0 $args"
            if [ "$user" == "root" ]; then
                install $2 $3
                # Only offer reboot option if this was executed non GUI
                reboot
            fi;
        fi;
    ;;
    list)
        list
    ;;
    start)
        onStart "gui"
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
