# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

### Features
* Change login wallpaper
* Change login theme (global system theme) from themes located in __/usr/share/themes__
* Change login screen shield. (Login screen's lockscreen image)
* Enable / disable user list at login. 

As a cherry on top of the cake Loginized comes also with command line application __(loginized-cli)__.

__Note!__ If you are not seeing any themes via the application or you cannot see the theme you want to see. It might be because of that theme or those themes does not have gnome-shell theme available as compilied resource. In such case see the wiki for more details [WIKI](https://github.com/juhaku/loginized/wiki/Help).

__Note!__ In Ubuntu you should take a backup from /usr/share/gnome-shell/theme folder as it contains ubuntu specific gnome-shell.css file which is named as ubuntu.css. This is actually will override the gnome-shell theme if it is not changed. So if you 
wish to revert back to original ubuntu theme then you should backup this folder. As Default in Loginized points to gnome-shell default which is the blue theme.

More features are planned in further releases.

## Installation
Download package that suits most for you. Software has built in quick installer for fast setup. Installation needs sudo access and it will be asked from you at the installation.

### Pre-requirements
This application uses `glib-compile-resources` command, make sure it is available in your system.
In Ubuntu it is found from `libglib2.0-bin` package and in Ubuntu 18.04 onwards it is found from package `libglib2.0-dev-bin`. In OpenSUSE it is found under `glib2-devel` package.

### Downloads
Debian Based | RPM Based | All Distributions
-------------|-----------|------------------
[Loginized_0.2.6_x64.deb](https://github.com/juhaku/loginized/releases/download/v0.2.6/Loginized_0.2.6_x64.deb)|[Loginized_0.2.6_x64.rpm](https://github.com/juhaku/loginized/releases/download/v0.2.6/Loginized_0.2.6_x64.rpm)|[Loginized_0.2.6_x64_all.zip](https://github.com/juhaku/loginized/releases/download/v0.2.6/Loginized_0.2.6_x64_all.zip)

### Tested on
* Ubuntu 16.10 ->
* Open SUSE
* Fedora
* Manjaro

Basically runs on every Gnome based distribution with GDM as login manager running on gnome-shell 3.26 and above. Older ones should work as well but are not tested.

## Things to consider
Login theme is kind of global theme for the desktop, so you should use same or similar theme as login theme and shell theme since login theme affects to shell as well. If different theme is being used as shell theme and login theme then there might be funny outcomes and some things won't necessarily render correctly.

## Screenshots
![Main screen with selections](https://github.com/juhaku/loginized/blob/master/screenshots/screen_3.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screenshots/screen_2.png)

# License

This project is lincensed under GPL-3.0 license. See more details at [LICENSE](https://github.com/juhaku/loginized/blob/master/LICENSE)
