#!/bin/sh

dependency_check() {

if ! command -v fzf ; then
	printf "\033[1m\033[38;5;1m[Error]\033[m fzf not found \n"
	exit
fi

}


db_create() {

  local db_name=""
  local db_image=""
  local db_home_dir=""
  local nvidia_flag=""
  local rootful_container_flag=""
  local separate_initsystem_flag=""

  local db_image_selected="$(distrobox create --compatibility |  fzf -i --prompt "Select Image > " )"

  if [ -n "${db_image_selected}" ]; then
    db_image="${db_image_selected}"
    printf "Using image : ${db_image} \n"
  else
	printf "No option selected \n"
	exit 1
  fi


  printf "Name of distrobox : "
  local _db_name
  read _db_name

  if [ -n "$_db_name" ]; then
    db_name="${_db_name}"
    printf "Setting distrobox name as : ${db_name} \n"
  else
    printf "Name not provided \n"
    exit 1
  fi

  printf "Do you want to create a separate home directory (Y/n) : "
  local _separate_home_dir_confirm
  read _separate_home_dir_confirm

  case "$_separate_home_dir_confirm" in
    (n* | N*)
      db_home_dir="$HOME"
      printf "Using host's home directory : ${db_home_dir} \n"
      ;;
    (y* | Y* | *)
      db_home_dir="$HOME/distroboxes/${db_name}"
      printf "Create separate home directory at : ${db_home_dir} \n"
      ;;
  esac

  printf "Do you want this container to have a separate init system (y/N) : "
  local separate_initsystem_flag_confirm
  read separate_initsystem_flag_confirm

  case "$separate_initsystem_flag_confirm" in
    (y* | Y*)
      printf "Adding separate init system flag \n"
      separate_initsystem_flag="--init"
      ;;
    (n* | N* | *)
      printf "Not adding separate init system flag \n"
      separate_initsystem_flag=""
      ;;
  esac


  printf "Do you want to enable nvidia support (y/N) : "
  local _nvidia_flag_confirm
  read _nvidia_flag_confirm

  case "$_nvidia_flag_confirm" in
    (y* | Y*)
      printf "Adding nvidia flag \n"
      nvidia_flag="--nvidia"
      ;;
    (n* | N* | *)
      printf "Not adding nvidia flag \n"
      nvidia_flag=""
      ;;
  esac


  printf "Do you want this to be a rootful container (y/N) : "
  local rootful_container_flag_confirm
  read rootful_container_flag_confirm

  case "$rootful_container_flag_confirm" in
    (y* | Y*)
      printf "Adding rootful container flag \n"
      rootful_container_flag="--root"
      ;;
    (n* | N* | *)
      printf "Not adding rootful container flag \n"
      rootful_container_flag=""
      ;;
  esac



  printf "If you want to pass any pre init hooks type them here (default: "") : "
  local pre_init_hooks_passed
  local pre_init_hooks
  read pre_init_hooks

  if [ -n "$pre_init_hooks" ]; then
    printf "Using pre init hooks : ${pre_init_hooks} \n"
    pre_init_hooks_passed=true
  else
    printf "Proceeding without any pre init hooks \n"
    pre_init_hooks_passed=false
  fi

  rmdir --ignore-fail-on-non-empty  -- ~/distroboxes/*
  mkdir -p "${db_home_dir}"
  if [ "${pre_init_hooks_passed}" = true ] ; then
  distrobox-create --name "${db_name}" --image "${db_image}"  --home "${db_home_dir}" ${separate_initsystem_flag} ${nvidia_flag} ${rootful_container_flag}  --pre-init-hooks "${pre_init_hooks}"
  else
  distrobox-create --name "${db_name}" --image "${db_image}"  --home "${db_home_dir}" ${separate_initsystem_flag} ${nvidia_flag} ${rootful_container_flag}
  fi
  distrobox-enter ${rootful_container_flag}  "${db_name}"
}

main() {
printf "Distrobox Manufacture \n"

dependency_check
db_create

}

main "$@"


#     db_create "debian12" "quay.io/toolbx-images/debian-toolbox:12"
#     db_create "archlinux" "quay.io/toolbx-images/archlinux-toolbox"
#     db_create "ubuntu22" "quay.io/toolbx-images/ubuntu-toolbox:22.04"
#     db_create "kali" "docker.io/kalilinux/kali-rolling:latest"
#     db_create "opensuse" "registry.opensuse.org/opensuse/distrobox:latest"
#     db_create "alpine-edge" "quay.io/toolbx-images/alpine-toolbox:edge"
# distrobox create --name archlinux-init -i  docker.io/library/archlinux:latest --home $HOME/distroboxes/archlinux-init --init --init-hooks "umount /var/lib/flatpak"
# distrobox create --root --name archlinux-init-root --image quay.io/toolbx-images/archlinux-toolbox --home $HOME/distroboxes/archlinux-init-root --init --init-hooks "umount /var/lib/flatpak"
# distrobox-create --name fedora38-flatpak --image registry.fedoraproject.org/fedora-toolbox:38 --home $HOME/distroboxes/fedora38-flatpak --init-hooks "umount /var/lib/flatpak"

