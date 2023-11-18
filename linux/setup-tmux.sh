
#!/bin/sh

show_help(){

	cat << EOF
setup-tmux.sh

Choose one of the available commands:
    config
    help | --help | -h

EOF


}




install_tpm() {

# Install tmux plugin manager
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


}

clone_my_config() {

    if [ ! -d "$HOME/.config/nvim" ]  ; then
        # git clone git@github.com:soufrabi/config-tmux.git ~/.config/tmux
        git clone https://github.com/soufrabi/config-tmux.git ~/.config/tmux
    fi

    sh -c "cd ~/.config/nvim && git pull --all --verbose"

}

tmux_config() {

  install_tpm
  clone_my_config

}





main() {


	case "$1" in
		(config)
			shift
			tmux_config "$@"
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

