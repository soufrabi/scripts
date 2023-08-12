#!/bin/sh



show_help(){

	cat << EOF
searxng.sh

Choose one of the available commands:
	pull
	start
	help | --help | -h
	
EOF


}


if [ $# -eq 0 ]; then
	show_help
	exit
fi

_pull() {

	podman pull docker.io/searxng/searxng:latest

}

# ref : https://docs.searxng.org/admin/installation-docker.html
_start(){


	cd /home/darklord/my-instance

	PORT=8080
	podman run --rm \
             -d -p ${PORT}:8080 \
             -v "${PWD}/searxng:/etc/searxng" \
             -e "BASE_URL=http://localhost:$PORT/" \
             -e "INSTANCE_NAME=my-instance" \
			 --name searxng-podman \
             searxng/searxng

}




main() {

	case "$1" in 
		(pull)
			shift
			_pull "$@"
			;;
		(start)
			shift
			_start "$@"
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
