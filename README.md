# Loginized
Gnome GDM Login Theme Manager. Easy and Fast Login Theme Manipulation.

Loginized provides easy to use GUI to quickly change login theme of Gnome desktop environment. You can change the theme 
among all the themes that are installed globally on your system (/usr/share/themes). Also you can additionally change
login wallpaper. 

As a cherry on top of the cake Loginized comes also with command line application __(loginized-cli)__ and it can be installed if wanted. It is highly recommended as it comes with many useful and awesome features that are not available via the GUI.

__Note!__ If you are not seeing any themes via the application or you cannot see the theme you want to see. It might be because of that theme or those themes does not have gnome-shell theme available as compilied resource. In such case see the wiki for more details.

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
[Loginized_0.1.0_x64.deb](https://github.com/juhaku/loginized/releases/download/v0.1.0/Loginized_0.1.0_x64_deb.deb)|[Loginized_0.1.0_x64.rpm](https://github.com/juhaku/loginized/releases/download/v0.1.0/Loginized_0.1.0_x64_rpm.rpm)|[Loginized_0.1.0_x64_all.zip](https://github.com/juhaku/loginized/releases/download/v0.1.0/Loginized_0.1.0_x64_all.zip)

### All distributions
Download zip archive and extract it where ever. After first run you don't need downloaded content as 
content will be installed by the installer within the application.

Before your application may run install `libgconf-2-4` package from package manager or by other means.

## Things to consider
Login theme is kind of global theme for the desktop, so you should use same or similar theme as login theme and shell theme since login theme affects to shell as well. If different theme is being used as shell theme and login theme then there might be funny outcomes and some things won't necessarily render correctly.

## Screenshots
![Main Screen](https://github.com/juhaku/loginized/blob/master/screen_1.png)

![Main screen with selections](https://github.com/juhaku/loginized/blob/master/screen_2.png)

![Settings](https://github.com/juhaku/loginized/blob/master/screen_3.png)
