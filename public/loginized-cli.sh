#!/bin/bash

# Core functionalities to alter login theme
# This application provides easy access api to install specific theme as login theme for GNOME desktop 
# environment. 

# Global variables
# defaultBackground=noise-texture.png
gs=gnome-shell-theme.gresource
workDir=/tmp/shell
gdm3=/etc/alternatives/gdm3.css
gdmConf=/etc/dconf/db/gdm.d
runtimeConf=/tmp/loginized-conf.tmp
imagesPath=/usr/share/Loginized/images

# Determine this dynamically later
installPath=""

function notRecognized {
    echo "action $1 was not recogninzed, use ?, -h, --help flags for help" && exit 1
}

function help {
    echo "Usage: loginized-cli.sh [-h | --help | ?] | [--gui] [action] [theme] [image] | [--gui] set [config] [arg]
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
 extract ............ Extracts theme to /tmp/shell/theme folder. Additionally target folder 
                      may be provided where to extract content.
 compile ............ Compiles theme and places it to provided folder.
 set ................ Set is configuration command to change GDM configurations. Set can change 
                      login screen user list configuration or default shield picture for login screen. 
 
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

 loginized-cli.sh set shield
    This will set the default shield in use for login screen. 

 loginized-cli.sh set shield /usr/share/mypic.jpg 
    This will set mypic.jpg as default shield for login screen.

 loginized-cli.sh set user-list true
    This will set user list enabled in login screen. This is by default true.

 loginized-cli.sh set user-list false
    This will set user list disabled in login screen.
    
Copyright (C) 2019 Juha Kukkonen - Licensed under <https://www.gnu.org/licenses/gpl-3.0.txt>
This program is provided AS IS and comes with ABSOLUTELY NO WARRANTY"
}

# Simple function to extract gui attribute from cmd
function extractGui() {
    cmd="$@"
    gui=""
    for arg in $(echo $cmd); do
        [ "$arg" == "--gui" ] && gui=$arg && break;
    done;

    echo $gui
}

# Determine whether we are running on gui
if [ "$(extractGui "$@")" == "--gui" ]; then
    runningOnGui=true
else 
    runningOnGui=false
fi

# Trim --gui from arguments
args="$@"
argList=""
for arg in $(echo $args); do
    [ $arg != "--gui" ] && argList="$argList $arg"
done;

function removeWorkDir {
    rm -rf $workDir
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
        test ! -d $2/"$theme"-extracted && mkdir $2/"$theme"-extracted
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
    extract Default
    installGdm3Css $workDir/theme/gnome-shell.css
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

        tempImage=$(basename $image)
        dialogCss="#lockDialogGroup { background: #2e3436 url(\"resource:\/\/\/org\/gnome\/shell\/theme\/$tempImage\"); background-repeat: none; background-size: cover; }"

        location=/usr/share/gnome-shell
        workLocation=$workDir/theme
        
        # When processed from gui image is saved to $installPath
        if [ $runningOnGui == true ]; then
            cp $installPath/$image $workLocation/.
        else 
            cp $image $workLocation/.        
        fi;

        sed -i "/#lockDialogGroup/,/}/ { /#lockDialogGroup/ { s/.*// }; /}/ ! { s/.*// }; /}/ { s/.*/$dialogCss/ }; }" $workLocation/gnome-shell.css
        
        # Compile the modified theme and install it
        compile $workLocation "$location"
        
        installGdm3Css $workLocation/gnome-shell.css
        
        # Clear work dir after installation
        removeWorkDir
    fi
}

# List themes available. Themes must have .gresource file in order it to be available for install. Default will be always available.
function list {
    echo $(for theme in $(ls /usr/share/themes); do test -f /usr/share/themes/$theme/gnome-shell/gnome-shell-theme.gresource && echo $theme; done) Default
}

# On start functionality
function onStart {
    print=$runningOnGui
    [ "$1" == "--no-print" ] && print=false

    if [ -f $runtimeConf ]; then
        installPath=$(cat $runtimeConf)
    else 
        installPath=${HOME}/.config/Loginized
    fi;

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
    [ $print == true ] && echo $installPath
    test ! -f $runtimeConf && echo $installPath > $runtimeConf
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
    cliPrompt=$(echo $1 | cut -d ',' -f 2)
    desktop=$(echo $1 | cut -d ',' -f 3)
    appFolder=$(echo $1 | cut -d ',' -f 4)
    icon=$(echo $1 | cut -d ',' -f 5)

    cliBin=/usr/bin/loginized-cli
    # Make sure completion directory exists
    completion=/etc/bash_completion.d
    test ! -d $completion && mkdir -p $completion
    cliCompletion=$completion/loginized-cli-prompt

    if [ "$cli" != "" ]; then
        # If bin and completion already exists remove them and then update new ones
        [ -f $cliBin ] && rm $cliBin
        [ -f $cliCompletion ] && rm $cliCompletion
        cp $cli $cliBin
        cp $cliPrompt $cliCompletion
    fi;

    if [ "$desktop" != "" ]; then
        appDesktop=/usr/share/applications/Loginized.desktop
        app=/usr/lib/Loginized
        pixmap=/usr/share/pixmaps/loginized.png
        appBin=/usr/bin/Loginized

        # Remove or unlink existing ones before they are created or recreated.
        [ -f $appDesktop ] && rm $appDesktop
        [ -d $app ] && rm -rf $app
        [ -f $pixmap ] && rm $pixmap
        [ -h $appBin ] && unlink $appBin

        cp $desktop $appDesktop
        cp -r $appFolder $app
        cp $icon $pixmap
        ln -s $app/Loginized $appBin
    fi;
}

function createGdmProfile() {
    gdmProfile=/etc/dconf/profile

    # If gdm profile is not found create one and fill with data.
    test ! -d $gdmProfile && mkdir -p $gdmProfile
    echo -e "user-db:user\nsystem-db:gdm\nfile-db:/usr/share/gdm/greeter-dconf-defaults" > $gdmProfile/gdm
}

# Sets user list in login screen either enabled or disabled
function setUserList() {
    showUserList=$1
    createGdmProfile
    
    # Invert selection for sake of api
    if [ $showUserList == true ]; then
        showUserList=false
    else 
        showUserList=true
    fi;

    # If there is no option provided show not recognized message
    [ "$showUserList" == "" ] && notRecognized

    test ! -d $gdmConf && mkdir -p $gdmConf
    # Compare status to real argument and set inverted argument to file
    if [ "$1" == "false" ]; then 
        echo -e "[org/gnome/login-screen]\ndisable-user-list=$showUserList" > $gdmConf/00-screensaver
    else 
        # Set defaults when user list is set to true
        rm -f $gdmConf/00-screensaver
    fi;
    
    dconf update
}

# Changes login screen shield picture.
function setShield() {
    createGdmProfile

    test ! -d $gdmConf && mkdir -p $gdmConf
    if [ "$1" != "" ]; then 
        # Make sure that image's path is available
        test ! -d $imagesPath && mkdir -p $imagesPath
        # Copy the actual file to images path and use that path for shield image
        shieldPath=$imagesPath/$(basename $1)
        cp $1 $shieldPath
        echo -e "[org/gnome/desktop/screensaver]\npicture-uri='file://$shieldPath'" > $gdmConf/01-screensaver
    else 
        # Set defaults when there is no image provided
        rm -f $gdmConf/01-screensaver
    fi;

    dconf update
}

function save() {
    cmd="$2"
    theme=$(echo $cmd | cut -d ',' -f 1)
    background=$(echo $cmd | cut -d ',' -f 2)
    shield=$(echo $cmd | cut -d ',' -f 3)
    userList=$(echo $cmd | cut -d ',' -f 4)

    install $theme $background
    setShield $shield
    setUserList $userList
}

# Determine whether we need help
if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "?" ]]; then help && exit 0; fi

user=$(whoami)

# Run as root if current user is not root, $1 = file, $2 = args, $3 = guil
function runAsRoot() {
    cmd="$@"
    if [ "$user" != "root" ]; then 
        if [ $runningOnGui == true ]; then
            exec pkexec bash -c "$cmd"
        else 
            exec sudo bash -c "$cmd"
        fi;
    fi;
}

#echo "debug:" $user $0 $args "|runningOnGui:" $runningOnGui "|argList:" "$argList"

function main() {
    # Main functions
    # $1 = option, $2 = installPath, 3 = theme, $4 = image
    case $1 in
        extract)
            onStart "--no-print"
            extract $2 $3
        ;;
        compile)
            onStart "--no-print"
            compile $2 $3
        ;;
        reboot)
            fastReboot
        ;;
        install)
            # Startup configuration in order to enable all functionalities correctly
            onStart "--no-print"
            # On cli version we make sure that command is executed with correct rights.
            runAsRoot $0 $args
            if [ "$user" == "root" ]; then
                install $2 $3
                # Only offer reboot option if this was executed non GUI
                [ $runningOnGui == true ] || reboot
            fi;
        ;;
        list)
            onStart "--no-print"
            list
        ;;
        start)
            onStart
        ;;
        setupApp)
            onStart "--no-print"
            runAsRoot $0 $args
            if [ "$user" == "root" ]; then
                # $2 = comman separated config list
                setupApplication $2
            fi;
        ;;
        save)
            onStart "--no-print"
            runAsRoot $0 $args
            [ "$user" == "root" ] && save $argList
        ;;
        set)
        # $2 = config, $3 = value
            case $2 in
                shield)
                    runAsRoot $0 $args
                    if [ "$user" == "root" ]; then 
                        setShield $3
                        # Only cli version is offered to reboot
                        [ $runningOnGui == true ] || reboot
                    fi;
                ;;
                user-list)
                    runAsRoot $0 $args
                    if [ "$user" == "root" ]; then 
                        setUserList $3
                        # Only cli version is offered to reboot
                        [ $runningOnGui == true ] || reboot
                    fi;
                ;;
                *)
                notRecognized $2
                ;;
            esac
        ;;
        *)
            notRecognized $1
        ;;
    esac
}

main $argList 

test -f $runtimeConf && rm -f $runtimeConf