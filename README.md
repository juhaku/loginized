# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

### Features
* Change login wallpaper
* Change login theme (global system theme) from themes located in __/usr/share/themes__
* Change login screen shield. (Login screen's lockscreen image)
* Enable / disable user list at login. 

As a cherry on top of the cake Loginized comes also with command line application __(loginized-cli)__.

__Note!__ If you are not seeing any themes via the application or you cannot see the theme you want to see. It might be because of that theme or those themes does not have gnome-shell theme available as compilied resource. In such case see the wiki for more details [WIKI](https://github.com/juhaku/loginized/wiki/Help).

More features are planned in further releases.

## Installation
Download package that suits most for you.
 * Read install instructions from [WIKI](https://github.com/juhaku/loginized/wiki).
 * Also it's not bad idea to check release notes in [RELEASES](https://github.com/juhaku/loginized/releases).

### Pre-requirements
 * Command `glib-compile-resources` is used to compile and extract the themes. This must be available in operating system in order to application work correctly.
 * Command `xdg-open` is used to open links via application. Missing this will not stop using the application.
 * Before Download PLEASE READ [__Things to consider__](#things-to-consider) section first.

### Downloads

Distribution | DL | Sha1 | Required packages
-------------|----|------|------------------
Arch based   | [loginized-1.1.2.pacman](https://github.com/juhaku/loginized/releases/download/1.1.2/loginized-1.1.2.pacman) | 	 f0d1b6f37dab97e650b001aa59180c0422feff66 | glib2, xdg-utils
RPM based    | [loginized-1.1.2.x86_64.rpm](https://github.com/juhaku/loginized/releases/download/1.1.2/loginized-1.1.2.x86_64.rpm) | 	 ad7fa1fe336d00443fcd547b13ec7676b74c6575 | glib2-devel, xdg-utils (Open SUSE, Fedora)
Debian based | [loginized_1.1.2_amd64.deb](https://github.com/juhaku/loginized/releases/download/1.1.2/loginized_1.1.2_amd64.deb) | a287baca22c12c1d71fa8341f1640c537ff95a74 | libglib2.0-bin, libglib2.0-dev-bin, xdg-utils (Ubuntu)
All          | [Loginized.1.1.2.AppImage](https://github.com/juhaku/loginized/releases/download/1.1.2/Loginized.1.1.2.AppImage) | 	 fd655b95543d52e3ba792b993e9f00b1d4846774 | Distro dependant
All          | [loginized-1.1.2.zip](https://github.com/juhaku/loginized/releases/download/1.1.2/loginized-1.1.2.zip) | 	 8f2c90d76eab30287ba875c64181978904e72105 | Distro dependant

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
