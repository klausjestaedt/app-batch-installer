# [apps.sh]

## Description

This Bash script can be used to check or install apps in batch processing from one or more applist files containing lists of programs and in some cases also repositories. It's designed to quickly provide a system with desired software. It can also check if desired programs are already installed and install the missiing ones. From v1.1 on Repositories are added for DEB and RPM packages.

The following package managers and packages are supported:
1. Debian DEB packages installed using apt
2. RedHat RPM packages installed using dnf
3. Arch and AUR (Arch User Repository) packages installed using yay or paru
4. Flatpaks installed using flatpak (Flathub must be configured)

On the first start
./apps.sh
the script checks if a configuration file exists at ~/.applists/apps.config. If not, it asks for the path where the files with the app lists are located. Any number of files with the extension *.applist can be stored there. The location is then saved in ~/.applists/apps.config


## Example content for an my-debian.applist file:

type=deb  
unix2dos;Line-ending converter  
#This is a comment  
nmap  
rsync;file sync tool  
#Following line is a repository for fastfetch  
repo:ppa:zhangsongcui3371/fastfetch;Repo for fastfetch  
fastfetch  


### Line 1 sets the app type
Valid values:
1. Debian based distros: apt, APT, deb, DEB, Debian, DEBIAN
2. RPM based distros: rpm, RPM, dnf, DNF
3. Arch based distros: type=arch, Arch, ARCH, aur, AUR
4. Flatpaks: type=flatpak, Flatpak, flat, Flat, flathub, Flathub

### Comment Lines
Each comment line starts with a heading #

### App lines
Each line starts with an existing app name from your distro package manager or flathub.org  
Be exact on that, escpecially for flatpaks: use org.gimp.GIMP instead of gimp  
Optional the ; separates your freestyle description for an app or repo

### One or more applist files
You can group *.applist files by topics or distros and use file globbing  
./apps.sh check mydistro*.applist  
or use exact file/s  
./apps.sh check "desktop.applist commandline.applist"


## Usage
Display a help message and list all *.applist files or ask for the storage location of your *.applist files.  
./apps.sh

Start the script with check argument, Repos are ignored here:  
./apps.sh check file1.applist  
./apps.sh check "file1.applist file2.applist file3.applist"  
./apps.sh check "myDistro*.applist"

Start the script with install argument:  
./apps.sh install file1.applist  
./apps.sh install "file1.applist file2.applist file3.applist"  
./apps.sh install "myDistro*.applist"  


I recommend to check first, then install whatever needed and then check again if all apps habve been installed.


## Video for the script v1.0

https://www.youtube.com/watch?v=AkwuVd4t0A8

## Author

- Author:     Klaus Jestädt
- Created:    01.01.2026
- Version:    1.0
- Updated:    15.03.2026
- Version:    1.1 Support for Debian repositories
- Version:    1.2 Support for RPM repositories

## Dependencies

Linux system with a package system apt or dnf or yay or paru and optionally flatpak

## License

MIT License
