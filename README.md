# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

Loginized provides easy to use GUI to quickly change login theme of Gnome desktop environment. You can change the theme 
among all the themes that are installed globally on your system (/usr/share/themes). Also you can additionally change
login wallpaper.

More features are planned in further releases.

Currently under development. But once available the binaries will be available through releases at this Github repository.

## Installation
Download package that suits most for you. Software has built in quick installer for fast setup. Just tick 
options you want to include and press OK. Installation needs sudo access and it will be asked from you at the installation.

In Debian and RPM based installations all the options are not installable as they are installed by default by the
package manager thus no need to install them again via application.

This application uses `glib-compile-resources` command, make sure it is available in your system.
In Ubuntu it is found from `libglib2.0-bin` package and in OpenSUSE it is found under `glib2-devel` package.

### Debian Based
Download the `.deb` binary and install it via software center or by running: `# dpkg -i [name-of-binary]`.

### RPM Based 
Download the `.rpm` binary and run it. Make sure you have installed package `glib2-devel`.

### All distributions
Download zip archive and extract it where ever. After first run you don't need downloaded content as 
content will be installed by the installer within the application.

Before your application may run install `libgconf-2-4` package from package manager or by other means.

In Ubuntu it would be like: `# apt install libgconf-2-4`

## Things to consider
Login theme is kind of global theme for the desktop, so you should use same or similar theme as login theme and shell theme since login theme affects to shell as well. If different theme is being used as shell theme and login theme then there might be funny outcomes and some things won't necessarily render correctly.

## Screenshots
![Main Screen](https://github.com/juhaku/loginized/blob/master/screen_1.png)

![Main screen with selections](https://github.com/juhaku/loginized/blob/master/screen_2.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screen_3.png)