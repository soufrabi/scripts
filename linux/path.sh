#!/bin/sh

prepend_path() {
	
	_new_path="$1"
	if [ ! -d "$_new_path" ]; then
		printf "Path ${_new_path} does not exist \n"
		return
	fi

	# If path ends with forward slash, remove the forward slash
	case "$_new_path" in 
		(*/) 
			_new_path="${_new_path%/*}"
			;;
	esac

	_path="$PATH"
	# echo $_path

	
	case ":${_path:=$_new_path}:" in
		(*:"$_new_path":*)  ;;
		(*:"$_new_path"/:*)  ;;
		(*) _path="$_new_path:$_path"  ;;
	esac

	export PATH="$_path"
	

	unset _new_path
	unset _path

}

if [ -d "/usr/sbin" ] ; then
	prepend_path "/usr/sbin"
fi

if [ -n "${DISTROBOX_HOST_HOME}" ] && [ -d "${DISTROBOX_HOST_HOME}" ] ; then
	# printf "You are in a distrobox container \n"
	prepend_path "${DISTROBOX_HOST_HOME}/.local/bin"
	prepend_path "${DISTROBOX_HOST_HOME}/scripts"

fi

if [ -d "${HOME}/.local/bin" ]; then
	prepend_path "${HOME}/.local/bin"
fi

if [ -d "${HOME}/bin" ]; then
	prepend_path "${HOME}/bin"
fi

if [ -d "${HOME}/scripts" ] ; then
	prepend_path "${HOME}/scripts"
fi



