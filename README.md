# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

### Features
* Change login wallpaper
* Change login theme (global system theme) from themes located in __/usr/share/themes__
* Change login screen shield. (Login screen's lockscreen image)
* Enable / disable user list at login. 
* __NEW!__ Force rounded login icon. __Proven to work gnome-shell 3.32 onwards as it has support for it.__ Might also work earlier versions but is not tested and in case if it is not working nothing will be done to fix.

As a cherry on top of the cake Loginized comes also with command line application __(loginized-cli)__.

__Note!__ If you are not seeing any themes via the application or you cannot see the theme you want to see. It might be because of that theme or those themes does not have gnome-shell theme available as compilied resource. In such case see the wiki for more details [WIKI](https://github.com/juhaku/loginized/wiki/Help).

More features are planned in further releases.

## Installation
Download package that suits most for you.
 * Read install instructions from [WIKI](https://github.com/juhaku/loginized/wiki).
 * Also it's not bad idea to check release notes in [RELEASES](https://github.com/juhaku/loginized/releases).

Alternatively you may build the application from sources. See [WIKI](https://github.com/juhaku/loginized/wiki#build-application-from-sources) for more details.

### Prerequisites
 * Command `glib-compile-resources` is used to compile and extract the themes. This must be available in operating system in order to application work correctly.
 * Command `xdg-open` is used to open links via application. Missing this will not stop using the application.
 * Command `notify-send` is used to notify new versions. Missing this will not stop using the application but will certainly break the updates notification.
 * Before Download PLEASE READ [__Things to consider__](#things-to-consider) section first.

### Downloads

Distribution | DL | Sha1 | Required packages
-------------|----|------|------------------
Arch based   | [loginized-1.3.6.pacman](https://github.com/juhaku/loginized/releases/download/1.3.6/loginized-1.3.6.pacman) | 	 713a6c2cdd8798a77cd6123da325c0cac2c5f88a | glib2, xdg-utils
RPM based    | [loginized-1.3.6.x86_64.rpm](https://github.com/juhaku/loginized/releases/download/1.3.6/loginized-1.3.6.x86_64.rpm) | 	 22dd49cac5c25c9bac6abf1ef20e21f5f5ab00be | glib2-devel, xdg-utils (Open SUSE, Fedora)
Debian based | [loginized_1.3.6_amd64.deb](https://github.com/juhaku/loginized/releases/download/1.3.6/loginized_1.3.6_amd64.deb) | 27ba6202d6e23ffb3fdf41c07290073a885503ee | libglib2.0-bin, libglib2.0-dev-bin, xdg-utils (Ubuntu)
All          | [Loginized.1.3.6.AppImage](https://github.com/juhaku/loginized/releases/download/1.3.6/Loginized.1.3.6.AppImage) | 	 1cf0cc6ec2c6cd2bb49bdb761819a700c96e9746 | Distro dependant
All          | [loginized-1.3.6.zip](https://github.com/juhaku/loginized/releases/download/1.3.6/loginized-1.3.6.zip) | 	 c6058cc51ada812fb65ef5e686b434d7f0a08b84 | Distro dependant

### Tested on
* Ubuntu 16.10 ->
* Open SUSE
* Fedora
* Manjaro

Basically runs on every Gnome based distribution with GDM as login manager running on gnome-shell 3.26 and above. Older ones should work as well but are not tested.

## Known limitations and issues

* Currently by some unknown reason on openSUSE Thumbleweed running gnome-shell 3.30.2 with wayland it is not able to change background nor the lock screen image at login. Theme however will change. 

Feel free to prove me wrong as issues are never good thing. 

## Things to consider
 * Login theme is actually just a global gnome-shell theme. You should use same or similar gnome-shell theme as login theme and desktop's gnome-shell theme which can be changed via __Gnome Tweak Tool__. If different theme is being used as shell theme and login theme there might be funny outcomes and some things won't necessarily render correctly.
 * In Ubuntu 18.04 onwards you should take a backup from /usr/share/gnome-shell/theme/ubuntu.css file. This file contains the Ubuntu flavored styles of the default gnome-shell blue theme. In Ubuntu 18.04 this file is overrided by each theme's .css file when installed as login theme. So if needed to go back to original Ubuntu flavored theme you need to manually revert this file to the original one.
 * Please backup default __/usr/share/gnome-shell/gnome-shell-theme.gresource__ file before using Loginized in case it need to be reverted.
 * Anything you do with the application is at your own risk and you understand that something can go wrong if misused or broken themes are being used. In case of issues please refer to [WIKI](https://github.com/juhaku/loginized/wiki/Help).

## Screenshots
![Theme selection](https://github.com/juhaku/loginized/blob/master/screenshots/screen1.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screenshots/screen2.png)

![About](https://github.com/juhaku/loginized/blob/master/screenshots/screen3.png)

# License

This project is lincensed under GPL-3.0 license. See more details at [LICENSE](https://github.com/juhaku/loginized/blob/master/LICENSE)
