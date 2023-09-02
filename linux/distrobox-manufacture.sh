#!/bin/sh

db_create() {

  db_name="$1"
  db_image="$2"
  db_home_dir=""
  nvidia_flag=""

  printf "Name of distrobox (default:${db_name}) : " 
  read _db_name

  if [ -n "$_db_name" ]; then
    echo "Setting distrobox name as : ${_db_name}"
    db_name="${_db_name}"
  else 
    echo "Using default distrobox name : ${db_name}"
  fi

  printf "Do you want to create a separate home directory (y/n) (default:y) : "
  read _separate_home_dir_confirm

  case "$_separate_home_dir_confirm" in
    (n* | N*)
      db_home_dir="$HOME" 
      printf "Using host's home directory : ${db_home_dir} \n"
      ;;
    (y* | Y* | *)
      db_home_dir="$HOME/distroboxes/${db_name}"
      printf "Created separate home directory at : ${db_home_dir} \n"
      mkdir -p "${db_home_dir}"
      ;;
  esac

  printf "Do you want to enable nvidia support (y/n) (default:n) : "
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

  printf "If you want to pass any custom flags type them here (default: "") : "
  read custom_flags
  
  if [ -n "$custom_flags" ]; then
    printf "Using custom flags : ${custom_flags} \n"
  else
    printf "Proceeding without any custom options \n"
  fi
  

  distrobox-create --name "${db_name}" --image "${db_image}"  --home "${db_home_dir}" ${nvidia_flag} ${custom_flags}
  distrobox-enter "${db_name}"
}

main() {
echo "Distrobox Manufacture"

echo "1. Debian 12"
echo "2. Arch Linux"
echo "3. Ubuntu 22.04"
echo "4. Kali Linux"
echo "5. OpenSUSE"
echo "6. Alpine edge"

printf "Choose your distro : "
read _option

case "${_option}" in 
  "1")
    echo "Selected Debian 12"
    db_create "debian12" "quay.io/toolbx-images/debian-toolbox:12"
    ;;
  "2")
    echo "Selected Arch Linux"
    db_create "archlinux" "quay.io/toolbx-images/archlinux-toolbox"
    ;;
  "3")
    echo "Selected Ubuntu 22.04 lts"
    db_create "ubuntu22" "quay.io/toolbx-images/ubuntu-toolbox:22.04"
    ;;
  "4")
    echo "Selected Kali Linux"
    db_create "kali" "docker.io/kalilinux/kali-rolling:latest"
    ;;
  "5")
    echo "Selected OpenSUSE"
    db_create "opensuse" "registry.opensuse.org/opensuse/distrobox:latest"
    ;;
  "6")
    echo "Selected Alpine edge"
    db_create "alpine-edge" "quay.io/toolbx-images/alpine-toolbox:edge" 
    ;;
  *)
    echo "Selected Unknown option"
    ;;
esac



}


main "$@"




# distrobox create --name archlinux-init -i  docker.io/library/archlinux:latest --home $HOME/distroboxes/archlinux-init --init --init-hooks "umount /var/lib/flatpak"
# distrobox create --root --name archlinux-init-root --image quay.io/toolbx-images/archlinux-toolbox --home $HOME/distroboxes/archlinux-init-root --init --init-hooks "umount /var/lib/flatpak"

# distrobox-create --name fedora38-flatpak --image registry.fedoraproject.org/fedora-toolbox:38 --home $HOME/distroboxes/fedora38-flatpak --init-hooks "umount /var/lib/flatpak"





