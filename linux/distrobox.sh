#!/bin/sh

show_help(){

	cat << EOF
distrobox.sh

Choose one of the available commands:
	install
	manufacture
	help | --help | -h
	
EOF


}


if [ $# -eq 0 ]; then
	show_help
	exit
fi

insall_package() {
	mkdir -p ~/gitrepos
	cd ~/gitrepos

	git clone https://github.com/89luca89/distrobox.git
	cd distrobox
	pwd ; ls ;

	printf "Do you want to install distrobox globally using sudo (y/n) (default:n) : "
	read confirm_install_globally


  case "$confirm_install_globally" in
    (y* | Y*)
      printf "Installing Globally \n"
	  sudo ./install
      ;;
    (n* | N* | *)
      printf "Installing for this user only \n"
      printf "Make sure ${HOME}/.local/bin is in PATH \n"
	  ./install
      ;;
  esac


}

manufacture() {

	distrobox-manufacture.sh

}

main() {

	case "$1" in 
		(install)
			shift
			insall_package "$@"
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
