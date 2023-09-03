#!/bin/sh

show_help(){

	cat << EOF
flatpak.sh

Choose one of the available commands:
	add-flathub
	theming
	theme-rm
	help | --help | -h
	
EOF


}


if [ $# -eq 0 ]; then
	show_help
	exit
fi


_add_flathub() {

	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

theming_gtk() {

	mkdir -p ~/.themes
	mkdir -p ~/.icons
	cp -ruv /usr/share/themes/* ~/.themes
	cp -ruv /usr/share/icons/* ~/.icons
	flatpak override --user --filesystem=$HOME/.themes
	flatpak override --user --filesystem=$HOME/.icons

	flatpak override --user --env=GTK_THEME=Arc-Dark
	# flatpak override --user --env=ICON_THEME=Adwaita-Dark
	


}

theme_rm() {

	# Some apps don't work on theming
	flatpak override --user --nofilesystem=$HOME/.themes $1
	flatpak override --user --nofilesystem=$HOME/.icons $1
	flatpak override --user --unset-env=GTK_THEME $1

}

theming_qt() {

	flatpak override --user --filesystem=xdg-config/Kvantum:ro
	flatpak override --user --env=QT_STYLE_OVERRIDE=kvantum
}

theming() {
	theming_gtk
}

main() {

	case "$1" in 
		(add-flathub)
			shift
			_add_flathub "$@"
			;;
		(theming)
			shift
			 theming "$@"
			;;
		(theme-rm)
			shift
			 theme_rm "$@"
			;;
		(help | --help | -h)
			show_help 
			exit 0 
			;;
		(*)
			printf >&2 "Error: invalid command\n"
			show_help
			exit 1
			;;

	esac
	

}

main "$@"
