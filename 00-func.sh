#!/bin/sh

add_to_env_var() {
	env_var_name="$1"
	 _new_path="$2"
	if [ ! -d "$_new_path" ]; then
		printf "[Error] Path %s does not exist \n" "${_new_path}"
		return
	fi

	# If path ends with forward slash, remove the forward slash
	case "$_new_path" in
		(*/)
			_new_path="${_new_path%/*}"
			;;
	esac

	# env_var_val="$PATH"
	eval "env_var_val=\$$env_var_name"

	# echo $env_var_val


	case ":${env_var_val:=$_new_path}:" in
		(*:"$_new_path":*)  ;;
		(*:"$_new_path"/:*)  ;;
		(*)
            case "$3" in
                "PREPEND")
                    env_var_val="$_new_path:$env_var_val"  ;;
                "APPEND")
                    env_var_val="$env_var_val:$_new_path"  ;;
                *)
                    printf "[Error] No operation specified \n"
                    return
                    ;;
            esac
	esac

	# export PATH="$env_var_val"
	export "$env_var_name=$env_var_val"


	unset _new_path
	unset env_var_val
    unset env_var_name


}

prepend_env_var() {
    add_to_env_var "$1" "$2" "PREPEND"
}

prepend_path() {
	prepend_env_var "PATH" "$1"

}

unset_env_var_if_path_not_present() {
    env_var_name="$1"
    env_var_val="\$$1"
    # $2 is used for checking type : DIR / FILE

    if [ -n "$env_var_val" ] ; then
        case "$2" in
            "DIR")
                if [ ! -d "$env_var_val" ] ; then
                    unset "$env_var_name"
                fi
                ;;
            *)
                printf "[Error] Cannot detect type of check\n"
                ;;
        esac
    fi

    unset env_var_name
    unset env_var_val

}

unset_env_var_if_dir_not_present() {
    unset_env_var_if_path_not_present "$1" "DIR"
}
