# [apps.sh]

## Beschreibung

Das Bash Script dient dazu, Apps aus Dateien mit Programmlisten zu installieren. Es dient dazu ein System schnell mit gewünschter Software zu versorgen. Auch kann es prüfen ob gewünschte Programme bereits installiert sind.

Unterstützt werden folgende Paketmanager und Pakete:

1. Debian DEB Pakete die mittels apt installiert werden
2. RedHat RPM Pakete die mittels dnf installiert werden
3. Arch und AUR (Arch User Repository) Pakete die mit yay oder paru installiert werden
4. Flatpaks die mittels flatpak installeirt werden (Flathub muss konfiguriert sein)

Beim ersten Start prüft das Script ob eine Konfigurationsdatei unter ~/.applists/apps.config existiert. Falls nicht fragt es den Pfad ab unter dem die Dateien mit den Applisten liegen. Dort können beliebige viele Dateien mit der Endung *.applist liegen. Der Speicherort wird dan in ~/.applists/apps.config gespeichert.

Das Tool kann dann aufgerufen werden:

Ohne Argumente gibt das Script eine kleine Hilfe aus und listet alle *.applist Dateien auf.
    ./apps.sh

Wenn Argument 1 = check dann wird Argument 2 geprüft.
Argument 2 kann auch mehrere Dateien auflisten, muss aber in Anführungszeichen gesetzt werden, ' oder "
Argument 2 kann auch GLOB Angaben enthalten, auch hier sind Anführungszeichen zu setzen, ' oder "
Argument 2 kann auch "all" sein um alle Listen einzulesen
    ./apps.sh check datei1.applist
    ./apps.sh check "datei1.applist datei2.applist datei3.applist"
    ./apps.sh check "myDistro*.applist"
    ./apps.sh check all

Wenn Argument 1 = install gesetzt wird wird versucht die entsprechenden Pakete zu installieren.
Es wird überprüft ob die Kommandos apt, dnf, yay, paru und flatpak existieren um fremde Paketsysteme zu ignorieren.
    ./apps.sh install datei1.applist
    ./apps.sh install "datei1.applist datei2.applist datei3.applist"
    ./apps.sh install "myDistro*.applist"
    ./apps.sh install all

Die Textdateien haben folgendes Format und Unix Zeilenschaltung:
type=arch
paketname1;Paket Beschreibung1
#paketname2;Paket Beschreibung2
paketname3;Paket Beschreibung3
paketname4;Paket Beschreibung4

Der Pakettyp Header in Zeile 1 kann folgende Werte enthalten:
Für Arch;       type=arch oder ARCH oder aur oder AUR
Für DEB:        type=apt oder APT oder deb oder DEB oder Debian oder DEBIAN
Für RPM:        type=rpm oder RPM oder dnf oder DNF
Für Flatpaks:   type=flatpak oder Flatpak oder flat oder Flat oder flathub oder Flathub

Die Programmbeschreibung ist optional und rein informativ, sie wird vom Tool aktuell nicht verwendet.

Es empfiehlt sich erst ein check, dann der install und dann nochmal einen check falls ein Paket nicht installiert wurde um zu erkennen wo es in einer längeren Installation vielleicht Probleme gab.

## Video zum Script

<https://www.youtube.com/ follows a.s.a.p.>

## Autor

Autor: Klaus Jestädt
Erstellt am: 01. Januar 2026
Version: 1.0

## Abhängigkeiten

Linux System mit einem Paketsystem apt oder dnf oder yay oder paru und optional flatpak

## Lizenz

MIT License
