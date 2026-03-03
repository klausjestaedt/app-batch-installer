#/usr/bin/env bash
# -----------------------------------------------------------------------------
# Script:       apps.sh
#
# Beschreibung: Dieses Tool kann Apps aus Listen in Textdateien:
# 			-prüfen ob alle installiert sind
# 			-fehlende Programme installieren
# 		Es berücksichtigt:
# 			- Debian APT Pakete mittels apt
# 			- Arch Pakete und AUR (Arch User Repository) mittels yay oder paru
# 			- RedHat RPM Pakete mittels dnf
# 			- Flatpaks mittels flatpak (Flathub muss eingerichtet sein)
#
# Description:  This tool can process apps from lists in text files to:
# 			- Check if all are installed
# 			- Install missing programs
# 		It supports:
# 			- Debian APT packages via apt
# 			- Arch packages and AUR (Arch User Repository) via yay or paru
# 			- RedHat RPM packages via dnf
# 			- Flatpaks via flatpak (Flathub must be configured)
#
# Zweck:	Wer häufig Systeme installiert sammelt Apps
# 		die er auf jedem System installieren will.
# Purpose: 	Those who frequently install systems collect apps
# 		that they want to have installed on every system.
#
# Beispiele:	Starte einfach ./apps.sh und folge den Hinweisen
# Examples:	Just start ./apps.sh and follow the hints
#
#
# Video zum Script:
# Script video:		https://www.youtube.com/ follows a.s.a.p.
#
# Author:	Klaus Jestädt
# Created:	01. Januar 2026
# Version:      1.0
#
# Abhängigkeiten: Installiertes Linux System mit den konfigurierten
#                 Paketmanagern: (apt || dnf || yay || paru) && flatpak
#
# License: MIT
# -----------------------------------------------------------------------------

arg_count="$#"
arg_command="$1"
arg_applists="$2"

# Konfigurationsverzeichnis abfragen/anlegen
if [[ ! -d ~/.applists ]]; then
	echo "Creating directory ~/.applists/ an" &&\
	mkdir ~/.applists
fi

# Konfigurationsdatei abfragen/anlegen
[[ ! -f ~/.applists/apps.config ]] && touch ~/.applists/apps.config
grep 'applist_dir=' ~/.applists/apps.config >/dev/null
if [[ $? != 0 ]]; then
	echo
	echo "There is no definition where your applists will be stored."
	read -p ">> Please enter the complete path to this folder: " applist_dir
	applist_dir=$(echo $applist_dir | sed 's/\/$//')
	applist_dir="${applist_dir}/"
	if [[ ! -d "/$applist_dir" ]]; then
		echo -e "\n\nAttention: /$applist_dir does not exist, stopping execution..\n\n"
		exit 1
	fi
	read -p "Is $applist_dir correct? (y/N)" yesno
	[[ $yesno == y || $yesno == j ]] && echo "applist_dir=${applist_dir}" >> ~/.applists/apps.config
fi

# Verzeichnis der Applist Dateien aus Config auslesen
line=$(grep "applist_dir=" ~/.applists/apps.config)
applist_dir="${line#*=}"


# Welche Paketsysteme sind installiert
[[ $(which apt 2>/dev/null) ]] && tool_apt=true || tool_apt=false
[[ $(which dnf 2>/dev/null) ]] && tool_dnf=true || tool_dnf=false
if [[ $(which pacman 2>/dev/null) ]]; then
	tool_pacman=true
	arch_tool="pacman"
	[[ $(which paru 2>/dev/null) ]] && arch_tool="paru"
	[[ $(which yay 2>/dev/null) ]] && arch_tool="yay"
else
	tool_pacman=false
fi


# Wenn kein Argument übergeben wurde Hilfe ausgeben
if [[ $arg_count == 0 ]]; then
	cat <<EOF

************************************************************************
Usage: apps.sh [check|install] [some.applist]
Usage: apps.sh [check|install] [some*]  #includes GLOB pattern
Usage: apps.sh [check|install] [\"some1.applist some2.applist\"]
Usage: apps.sh [check|install] [all]"
	
Argument 1:
  check       check if apps in the list are already installed
  install     install missing apps from a list
Argument 2:
  listname    one list or more "list1 list2" include globbing
  all         use all existing lists
************************************************************************

EOF
	echo "applists in $applist_dir"
	echo "--"
	for file in "${applist_dir}"*.applist; do
		basename "$file"
	done
	echo "--"
	
	exit 0
fi


# Wenn Argument 2 = all dann alle Listen einlesen
[[ $arg_applists == all ]] && arg_applists="$(cd ${applist_dir} && ls *.applist)"


# Loop durch die Listen und Kommandos ausführen
for list in $(echo ${applist_dir}/${arg_applists})
do
	[[ ! -f "$list" ]] && continue

	echo
	echo "Bearbeite Liste: $list"

	# Pakettyp auslesen
	paket_typ=$(head -1 "$list" | grep "type=" ${list})
	paket_typ="${paket_typ#*=}"


	case "$paket_typ" in

	    ##################################################################################
	    # PAKETLISTE IST RPM
	    "rpm" | "RPM" | "dnf" | "DNF")
		if [[ $tool_dnf == false ]]; then
			echo "Dies ist keine RPM basierte Distribution"
			echo -e "Ignoriere die Liste.\n"
			continue
		else
			grep -v "type=" ${list} | grep -v "^#" | while read app
			do
				app="${app%%;*}"
			        rpm -q $app >/dev/null 2>&1
				if [ "$?" == "0" ]; then
					printf "%-60s %s\n" "RPM-packet: $app" "bereits installiert"
				else
					if [[ $arg_command == check ]]; then
						printf "%-60s %s\n" "RPM-Paket: $app" "nicht installiert"
					elif [[ $arg_command == install ]]; then
						printf "%-60s %s\n" "RPM-Paket: $app" "installiere"
						sudo dnf install -y $app
					fi
				fi
			done
		fi
	    ;;

	    ##################################################################################
	    # PAKETLISTE IST APT
	    "apt" | "APT" | "deb" | "DEB" | "Debian" | "DEBIAN")
		if [[ $tool_apt == false ]]; then
			echo "Dies ist keine Debian basierte Distribution"
			echo -e "Ignoriere die Liste.\n"
			continue
		else
			grep -v "type=" ${list} | grep -v "^#" | while read app
			do
				app="${app%%;*}"
				dpkg-query -W -f='${Status}' $app 2>/dev/null | grep -q "ok installed"
				if [ "$?" == "0" ]; then
					printf "%-60s %s\n" "DEB-packet: $app" "bereits installiert"
				else
					if [[ $arg_command == check ]]; then
						printf "%-60s %s\n" "DEB-Paket: $app" "nicht installiert"
					elif [[ $arg_command == install ]]; then
						printf "%-60s %s\n" "DEB-Paket: $app" "installiere"
						sudo apt install -y $app
					fi
				fi
			done
		fi
	    ;;

	    ##################################################################################
	    # PAKETLISTE IST Arch oder AUR
	    "arch" | "Arch" | "ARCH" | "aur" | "AUR")
		if [[ $tool_pacman == false ]]; then
			echo  "Dies ist keine Arch Distribution"
			echo -e "Ignoriere die Liste.\n"
			continue
		else
			grep -v "type=" ${list} | grep -v "^#" | while read app
			do
				app="${app%%;*}"
				typeset -i c=$($arch_tool -Qs "${app}" | grep "$app" | wc -l)
			        if [ $c -gt 0 ]; then
					printf "%-60s %s\n" "Arch-Paket: $app" "bereits installiert"
				else
					if [[ $arg_command == check ]]; then
						printf "%-60s %s\n" "Arch-Paket: $app" "nicht installiert"
					elif [[ $arg_command == install ]]; then
						printf "%-60s %s\n" "Arch-Paket: $app" "installiere"
						$arch_tool -S --aur --noconfirm $app
						if [ "$app" == "teamviewer" ]; then
							echo -e "\n\nteamviewerd service starten..."
							sudo systemctl enable teamviewerd
							sudo systemctl start teamviewerd
							echo -e "\n\n"
						fi
					fi
				fi
			done
		fi
	    ;;

	    ##################################################################################
	    # PAKETLISTE IST Flatpak
	    "flatpak" | "Flatpak" | "flat" | "Flat" | "flathub" | "Flathub")
		if [[ $tool_flatpak == false ]]; then
			echo  "Das Tool flatpak ist nicht installiert"
			echo -e "Ignoriere die Liste.\n"
			continue
		else
			grep -v "type=" ${list} | grep -v "^#" | while read app
			do
				app="${app%%;*}"
				flatpak list --app | grep "$app" >/dev/null 2>&1
			        if [ $? -eq 0 ]; then
					printf "%-60s %s\n" "Flatpak: $app" "bereits installiert"
				else
					if [[ $arg_command == check ]]; then
						printf "%-60s %s\n" "Flatpak: $app" "nicht installiert"
					elif [[ $arg_command == install ]]; then
						printf "%-60s %s\n" "Flappak: $app" "installiere"
						flatpak install -y $app
					fi
				fi
			done
		fi
	    ;;

	    *)
	        echo "Unbekannter Pakettyp $paket_typ .. Abbruch..."
		exit 1
	        ;;

	esac
done

exit 0
