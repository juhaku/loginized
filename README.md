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

## Ubuntu users
Default theme in Loginized app is the actual de facto from Gnome which is Blue adwaita based gnome-shell theme.
Ubuntu overrides this theme's css file to provide different colors to login screen. When Default theme is used with Loginized that will use the standard from Gnome (blue adwaita). 

In order to use the Yaru as login theme with Loginized that is standard for Ubuntu see https://github.com/juhaku/loginized/wiki/Help#ubuntu-users-yaru-gnome-shell-theme

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
Arch based   | [loginized-1.4.0.pacman](https://github.com/juhaku/loginized/releases/download/1.4.0/loginized-1.4.0.pacman) | 	 efff5d37f3728dbc16832219ac346ef77af3c613 | glib2, xdg-utils
RPM based    | [loginized-1.4.0.x86_64.rpm](https://github.com/juhaku/loginized/releases/download/1.4.0/loginized-1.4.0.x86_64.rpm) | 	 b4e7cd93e8d765671f9bd03df1b29e7370ada60c | glib2-devel, xdg-utils (Open SUSE, Fedora)
Debian based | [loginized_1.4.0_amd64.deb](https://github.com/juhaku/loginized/releases/download/1.4.0/loginized_1.4.0_amd64.deb) | 3df077659cf0ed3cf5cd55d9cd87f0242e12ca7d | libglib2.0-bin, libglib2.0-dev-bin, xdg-utils (Ubuntu)
All          | [Loginized.1.4.0.AppImage](https://github.com/juhaku/loginized/releases/download/1.4.0/Loginized.1.4.0.AppImage) | 	 e78e2f8eb2344adfeab25ed9f13bbae6a57502d2 | Distro dependant
All          | [loginized-1.4.0.zip](https://github.com/juhaku/loginized/releases/download/1.4.0/loginized-1.4.0.zip) | 	 f778e73ae761e2b131b6e0020c028f9577957ba2 | Distro dependant

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

## Contributing
Contributing is very well welcome. You should start with cloning the repository and then getting to now technics used in this application. If you are already familiar with them just drop A PR but make sure that you have actually tested that your changes works before submitting a PR. 

As of for quite some time I haven't been using Gnome desktop because mutters inefficiency so I have no interest to develop this application activly. But I will keep it maintained at least for now.

## Screenshots
![Theme selection](https://github.com/juhaku/loginized/blob/master/screenshots/screen1.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screenshots/screen2.png)

![About](https://github.com/juhaku/loginized/blob/master/screenshots/screen3.png)

# License

This project is lincensed under GPL-3.0 license. See more details at [LICENSE](https://github.com/juhaku/loginized/blob/master/LICENSE)
