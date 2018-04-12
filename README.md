# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

### Features
* Change login wallpaper
* Change login theme (global system theme) from themes located in __/usr/share/themes__
* Change login screen shield. (Login screen's lockscreen image)
* Enable / disable user list at login. 

As a cherry on top of the cake Loginized comes also with command line application __(loginized-cli)__ and it can be installed if wanted. It is highly recommended as it comes with many useful and awesome features that are not available via the GUI.

__Note!__ If you are not seeing any themes via the application or you cannot see the theme you want to see. It might be because of that theme or those themes does not have gnome-shell theme available as compilied resource. In such case see the wiki for more details [WIKI](https://github.com/juhaku/loginized/wiki/Help).

__Note!__ In Ubuntu you should take a backup from /usr/share/gnome-shell/theme folder as it contains ubuntu specific gnome-shell.css file which is named as ubuntu.css. This is actually will override the gnome-shell theme if it is not changed. So if you 
wish to revert back to original ubuntu theme then you should backup this folder. As Default in Loginized points to gnome-shell default which is the blue theme.

More features are planned in further releases.

## Installation
Download package that suits most for you. Software has built in quick installer for fast setup. Just tick 
options you want to include and press OK. Installation needs sudo access and it will be asked from you at the installation.

In Debian and RPM based installations you may choose whether you want to install loginized-cli application as well.

### Pre-requirements
This application uses `glib-compile-resources` command, make sure it is available in your system.
In Ubuntu it is found from `libglib2.0-bin` package and in OpenSUSE it is found under `glib2-devel` package.

### Downloads
Debian Based | RPM Based | All Distributions
-------------|-----------|------------------
[Loginized_0.2.3_x64.deb](https://github.com/juhaku/loginized/releases/download/v0.2.3/Loginized_0.2.3_x64.deb)|[Loginized_0.2.3_x64.rpm](https://github.com/juhaku/loginized/releases/download/v0.2.3/Loginized_0.2.3_x64.rpm)|[Loginized_0.2.3_x64_all.zip](https://github.com/juhaku/loginized/releases/download/v0.2.3/Loginized_0.2.3_x64_all.zip)

### All distributions
Download zip archive and extract it where ever. After first run you don't need downloaded content as 
content will be installed by the installer within the application.

For a first run try to run it via terminal and see if any dependency is missing. Like fresh install of Ubuntu nees following package before the application may run `libgconf-2-4`. Other distros might need other package.

## Things to consider
Login theme is kind of global theme for the desktop, so you should use same or similar theme as login theme and shell theme since login theme affects to shell as well. If different theme is being used as shell theme and login theme then there might be funny outcomes and some things won't necessarily render correctly.

## Screenshots
![Main screen with selections](https://github.com/juhaku/loginized/blob/master/screenshots/screen_3.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screenshots/screen_2.png)

# License

This project is lincensed under GPL-3.0 license. See more details at [LICENSE](https://github.com/juhaku/loginized/blob/master/LICENSE)
