# [apps.sh]

## Description

This Bash script is used to install apps from files containing lists of programs. It is designed to quickly provide a system with desired software. It can also check if desired programs are already installed.

The following package managers and packages are supported:

1. Debian DEB packages installed using apt
2. RedHat RPM packages installed using dnf
3. Arch and AUR (Arch User Repository) packages installed using yay or paru
4. Flatpaks installed using flatpak (Flathub must be configured)

On the first start, the script checks if a configuration file exists at ~/.applists/apps.config. If not, it asks for the path where the files with the app lists are located. Any number of files with the extension *.applist can be stored there. The location is then saved in ~/.applists/apps.config.

The tool can then be called:

Without arguments, the script displays a short help message and lists all *.applist files.
    ./apps.sh

If argument 1 = check, then argument 2 is checked.
Argument 2 can also list multiple files but must be enclosed in quotes, ' or "
Argument 2 can also contain GLOB specifications, also here quotes are to be used, ' or "
    ./apps.sh check file1.applist
    ./apps.sh check "file1.applist file2.applist file3.applist"
    ./apps.sh check "myDistro*.applist"

If argument 1 = install is set, an attempt is made to install the corresponding packages.
It is checked if the commands apt, dnf, yay, paru, and flatpak exist to ignore foreign package systems.
    ./apps.sh install file1.applist
    ./apps.sh install "file1.applist file2.applist file3.applist"
    ./apps.sh install "myDistro*.applist"

The text files have the following format and Unix line endings:
type=arch
packagename1;Package description1
#packagename2;Package description2
packagename3;Package description3
packagename4;Package description4

The package type header in line 1 can contain the following values:
For Arch:       type=arch or ARCH or aur or AUR
For DEB:        type=apt or APT or deb or DEB or Debian or DEBIAN
For RPM:        type=rpm or RPM or dnf or DNF
For Flatpaks:   type=flatpak or Flatpak or flat or Flat or flathub or Flathub

The program description is optional and purely informative; it is currently not used by the tool.

It is recommended to first run a check, then the install, and then another check if a package was not installed to identify where there might have been problems in a longer installation.

## Video for the script

<https://www.youtube.com/ follows a.s.a.p.>

## Author

- Author:     Klaus Jestädt
- Created:    01.01.2026
- Version:    1.0
- Updated:    15.03.2026
- Version:    1.1 See UPDATE_v1.1.md (Support for Debian repositories)

## Dependencies

Linux system with a package system apt or dnf or yay or paru and optionally flatpak

## License

MIT License
