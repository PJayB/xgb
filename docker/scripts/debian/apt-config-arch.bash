#!/bin/bash
set -e
set -o pipefail

die() { echo "$*" >&2 ; exit 1 ; }

which lsb_release 1>/dev/null 2>&1 || die "Install lsb_release first"

[ -n "$1" ] || die "Expected architecture"

# Set up some invariants
ubuntu_version="$(lsb_release -cs)"
original_sources_list="/etc/apt/sources.list"
original_sources_list_backup="/etc/apt/sources.list.bak"

get_apt_family() {
    case "$1" in
    amd64|i386)   echo "archive" ;;
    arm64)        echo "ports" ;;
    *)            die "Unsupported architecture, $1" ;;
    esac
}

get_apt_repo() {
    case "$1" in
    archive)      echo "http://archive.ubuntu.com/ubuntu/" ;;
    ports)        echo "http://ports.ubuntu.com/" ;;
    *)            die "Unsupported family, $1" ;;
    esac
}

create_sources_list() {
    local apt_foreign_arch="$1"
    local apt_foreign_repo="$2"
    local foreign_sources_list="$3"
    # Create a foreign sources list
    echo "deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version} main restricted
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-updates main restricted
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version} universe
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-updates universe
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version} multiverse
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-updates multiverse
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-backports main restricted universe multiverse" > "$foreign_sources_list"
}

apt_native_arch="$(dpkg --print-architecture)"
apt_native_family="$(get_apt_family "$apt_native_arch")"

declare -A apt_families=(
    ["$apt_native_family"]="$apt_native_arch"
)

for apt_foreign_arch in "$@"; do
    # Quit if this is a noop
    [ "$apt_native_arch" == "$apt_foreign_arch" ] && continue

    apt_foreign_family="$(get_apt_family "$apt_foreign_arch")"

    dpkg --add-architecture "$apt_foreign_arch"

    cur_family="${apt_families[$apt_foreign_family]}"
    [ -z "$cur_family" ] || cur_family=",$cur_family"
    apt_families["$apt_foreign_family"]="${apt_foreign_arch}${cur_family}"
done

for apt_family in "${!apt_families[@]}"; do
    apt_foreign_repo="$(get_apt_repo "$apt_family")"
    foreign_sources_list="/etc/apt/sources.list.d/$ubuntu_version-$apt_family.list"

    archs="${apt_families["$apt_family"]}"

    # Create a foreign sources list
    create_sources_list "$archs" "$apt_foreign_repo" "$foreign_sources_list"
done
