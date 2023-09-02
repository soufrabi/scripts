#!/bin/sh

show_help(){

	cat << EOF
distrobox.sh

Choose one of the available commands:
	download
	manufacture
	help | --help | -h
	
EOF


}


if [ $# -eq 0 ]; then
	show_help
	exit
fi

download() {
	cd $(mktemp -d)
	git clone https://github.com/89luca89/distrobox.git
	cd distrobox
	pwd
	ls
}

manufacture() {

	distrobox-manufacture.sh


}

main() {

	case "$1" in 
		(download)
			shift
			download "$@"
			;;
		(manufacture)
			shift
			manufacture "$@"
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
