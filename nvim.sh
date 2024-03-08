#!/bin/sh

show_help() {

	cat <<EOF
setup-neovim.sh

Choose one of the available commands:
    all
    install
    clean
    config
    help | --help | -h

EOF

}

sudo_mode=true
package_location="${HOME}/.local/share/neovim"
install_location="/usr/local"

package_location_sudo="/opt/neovim"
install_location_sudo="/usr/local"

appimage_x86_64_url="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
appimage_aarch64_url="https://github.com/matsuu/neovim-aarch64-appimage/releases/download/v0.9.0/nvim-v0.9.0.appimage"
tarball_x86_64_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
tarball_aarch64_url=""
appimage_url=""
tarball_url=""

if [ $sudo_mode ]; then
	package_location="${package_location_sudo}"
	install_location="${install_location_sudo}"
fi

set_arch_urls() {

	case "$(uname -m)" in
	x86_64)
		printf "You are running x86_64 architecture \n"
		appimage_url="${appimage_x86_64_url}"
		tarball_url="${tarball_x86_64_url}"
		;;
	aarch64)
		printf "You are running aarch64 architecture \n"
		appimage_url="${appimage_aarch64_url}"
		tarball_url="${tarball_aarch64_url}"
		;;
	*)
		printf "Unknown Architecture ! [Abort] \n"
		exit 1
		;;
	esac

}

remove_package() {

	sudo rm -rv "${package_location}"
	sudo rm -v "${install_location}/bin/nvim"
	sudo rm -v "${install_location}/share/applications/nvim.desktop"
}

install_package_appimage() {

	sudo mkdir -pv "${package_location}"
	cd "${package_location}"

	sudo curl -L "${appimage_url}" -o nvim.appimage
	sudo chmod --verbose +x nvim.appimage
	sudo ./nvim.appimage --appimage-extract

	sudo mkdir -pv "${install_location}/bin"
	sudo mkdir -pv "${install_location}/share/applications"
	sudo mkdir -pv "${install_location}/share/icons"
	sudo ln -sv "${package_location}/squashfs-root/usr/bin/nvim" "${install_location}/bin"
	sudo ln -sv "${package_location}/squashfs-root/usr/share/applications/nvim.desktop" "${install_location}/share/applications"

}

install_package_tarball() {

	sudo mkdir -pv "${package_location}"
	cd "${package_location}"

	sudo curl -LJO "${tarball_url}"
	sudo tar -xvzf nvim-linux64.tar.gz

	sudo mkdir -pv "${install_location}/bin"
	sudo mkdir -pv "${install_location}/share/applications"
	sudo mkdir -pv "${install_location}/share/icons"

	sudo ln -sv "${package_location}/nvim-linux64/bin/nvim" "${install_location}/bin"
	sudo ln -sv "${package_location}/nvim-linux64/share/applications/nvim.desktop" "${install_location}/share/applications/nvim.desktop"

}

install_packer() {

	# Clone packer plugin manager

	git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

}

clone_my_config() {

	if [ ! -d "$HOME/.config/nvim" ]; then
		# git clone git@github.com:soufrabi/config-nvim.git ~/.config/nvim
		git clone https://github.com/soufrabi/config-nvim.git ~/.config/nvim
	fi

	sh -c "cd ~/.config/nvim && git pull --all --verbose"

}

neovim_config() {

	install_packer
	clone_my_config

}

neovim_clean() {
	remove_package

}

neovim_install_options() {

	set_arch_urls

	echo "Install neovim options :- "
	echo "1. Install neovim as appimage"
	echo "2. Install neovim as tarball"
	printf "Enter your option [default:1] : "
	install_option_chosen=""
	read -r install_option_chosen

	case "${install_option_chosen}" in
	"2")
		echo "Installing tarball"
		install_package_tarball
		;;
	"1" | *)
		echo "Installing appimage"
		install_package_appimage
		;;
	esac

}

neovim_install_and_config() {
	neovim_install_options
	neovim_config
}

interactive_main_menu() {

	printf "Interactive Main Menu :-\n"
	printf "1. Install Only\n"
	printf "2. Clone Config\n"
	printf "3. Install and Clone Config\n"
	printf "4. Clean Existing Installation\n"
	printf "Enter your option : "
	read -r "option_chosen"
	case "$option_chosen" in
	1)
		neovim_install_options
		;;
	2)
		neovim_config
		;;
	3)
		neovim_install_and_config
		;;
	4)
		neovim_clean
		;;
	*)
		printf >&2 "Error: invalid option selected\n"
		exit 1
		;;
	esac

}

main() {

	if [ $sudo_mode ]; then
		printf "Running in sudo mode \n"
	else
		printf "Running in regular user mode \n"
	fi

	if [ $# -eq 0 ]; then
		interactive_main_menu
		exit
	fi

	case "$1" in
	all)
		shift
		neovim_install_and_config "$@"
		;;
	install)
		shift
		neovim_install_options "$@"
		;;
	config)
		shift
		neovim_config "$@"
		;;
	clean)
		shift
		neovim_clean "$@"
		;;
	help | --help | -h)
		show_help
		exit 0
		;;
	*)
		printf >&2 "Error: invalid command\n"
		show_help
		exit 1
		;;
	esac

}

main "$@"
