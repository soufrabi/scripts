#!/bin/sh

show_help(){

	cat << EOF
distrobox.sh

Choose one of the available commands:
	manufacture
	help | --help | -h
	
EOF


}


if [ $# -eq 0 ]; then
	show_help
	exit
fi


_manufacture() {

	distrobox-manufacture.sh


}

main() {

	case "$1" in 
		(manufacture)
			shift
			_manufacture "$@"
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
