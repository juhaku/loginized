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
Download package that suits most for you.

### Pre-requirements
* Command `glib-compile-resources` is used to compile and extract the themes. This must be available in operating system in order to application work correctly.
* Command `xdg-open` is used to open links via application. Missing this will not stop using the application.

### Downloads

Distribution | DL | Sha1 | Required packages
-------------|----|------|------------------
Arch based   | [loginized-1.0.1.pacman](https://github.com/juhaku/loginized/releases/download/1.0.1/loginized-1.0.1.pacman) | 	
2257d442df1d587ce74e24edc4a6d6c795bbb411 | glib2, xdg-utils
RPM based    | [loginized-1.0.1.x86_64.rpm](https://github.com/juhaku/loginized/releases/download/1.0.1/loginized-1.0.1.x86_64.rpm) | 	
41352203b2f5eaa4e9c41518c6b502e282b0b4ac | glib2-devel, xdg-utils (Open SUSE, Fedora)
Debian based | [loginized_1.0.1_amd64.deb](https://github.com/juhaku/loginized/releases/download/1.0.1/loginized_1.0.1_amd64.deb) | 4b07bad289a59876607d87dae5b53ad0102b36a7 | libglib2.0-bin, libglib2.0-dev-bin, xdg-utils (Ubuntu)
All (Snap capable) | [loginized_1.0.1_amd64.snap](https://github.com/juhaku/loginized/releases/download/1.0.1/loginized_1.0.1_amd64.snap) | 	
83ad7d494eda78724cd0b479a629c7e6398b12a1 | Distro dependant
All          | [Loginized.1.0.1.AppImage](https://github.com/juhaku/loginized/releases/download/1.0.1/Loginized.1.0.1.AppImage) | 	
48d083e9ee52f0ac7b5baaccae9f4363abdea73e | Distro dependant
All          | [loginized-1.0.1.zip](https://github.com/juhaku/loginized/releases/download/1.0.1/loginized-1.0.1.zip) | 	
7130051a1f8d148d8ea41933961bd3cea886d32d | Distro dependant

### Tested on
* Ubuntu 16.10 ->
* Open SUSE
* Fedora
* Manjaro

Basically runs on every Gnome based distribution with GDM as login manager running on gnome-shell 3.26 and above. Older ones should work as well but are not tested.

## Things to consider
Login theme is kind of global theme for the desktop, so you should use same or similar theme as login theme and shell theme since login theme affects to shell as well. If different theme is being used as shell theme and login theme then there might be funny outcomes and some things won't necessarily render correctly.

## Screenshots
![Theme selection](https://github.com/juhaku/loginized/blob/master/screenshots/screen1.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screenshots/screen2.png)

![About](https://github.com/juhaku/loginized/blob/master/screenshots/screen3.png)

# License

This project is lincensed under GPL-3.0 license. See more details at [LICENSE](https://github.com/juhaku/loginized/blob/master/LICENSE)
