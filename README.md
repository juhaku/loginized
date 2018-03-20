# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

Loginized provides easy to use GUI to quickly change login theme of Gnome desktop environment. You can change the theme 
among all the themes that are installed globally on your system (/usr/share/themes). Also you can additionally change
login wallpaper.

More features are planned in further releases.

## Installation
Download package that suits most for you. Software has built in quick installer for fast setup. Just tick 
options you want to include and press OK. Installation needs sudo access and it will be asked from you at the installation.

In Debian and RPM based installations you may choose whether you want to install loginized-cli application as well.

### Pre-requirements
This application uses `glib-compile-resources` command, make sure it is available in your system.
In Ubuntu it is found from `libglib2.0-bin` package and in OpenSUSE it is found under `glib2-devel` package.

### Debian Based
Make sure your have installed package `libglib2.0-bin`. This should come as default by some distros.

[Loginized_0.1.0_x64.deb](https://github.com/juhaku/loginized/releases/download/v0.1.0/Loginized_0.1.0_x64_deb.deb)

### RPM Based 
Make sure you have installed package `glib2-devel`.

[Loginized_0.1.0_x64.rpm](https://github.com/juhaku/loginized/releases/download/v0.1.0/Loginized_0.1.0_x64_rpm.rpm)

### All distributions
Download zip archive and extract it where ever. After first run you don't need downloaded content as 
content will be installed by the installer within the application.

Before your application may run install `libgconf-2-4` package from package manager or by other means.

[Loginized_0.1.0_x64_all.zip](https://github.com/juhaku/loginized/releases/download/v0.1.0/Loginized_0.1.0_x64_all.zip)

## Things to consider
Login theme is kind of global theme for the desktop, so you should use same or similar theme as login theme and shell theme since login theme affects to shell as well. If different theme is being used as shell theme and login theme then there might be funny outcomes and some things won't necessarily render correctly.

## Screenshots
![Main Screen](https://github.com/juhaku/loginized/blob/master/screen_1.png)

![Main screen with selections](https://github.com/juhaku/loginized/blob/master/screen_2.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screen_3.png)
