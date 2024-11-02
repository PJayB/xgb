#!/bin/bash
set -e
set -o pipefail

die() { echo "$*" >&2 ; exit 1 ; }

which lsb_release 1>/dev/null 2>&1 || die "Install lsb_release first"

# Configure foreign package sources
native_arch="$(uname -m)"
case "$native_arch" in
aarch64)
    native_arch=aarch64
    foreign_arch=x86-64
    apt_native_arch=arm64
    apt_foreign_arch=amd64
    apt_foreign_repo=http://archive.ubuntu.com/ubuntu/
    ;;
x86_64)
    native_arch=x86-64
    foreign_arch=aarch64
    apt_native_arch=amd64
    apt_foreign_arch=arm64
    apt_foreign_repo=http://ports.ubuntu.com/
    ;;
*)
    die "Unsupported architecture, $native_arch"
    ;;
esac

original_sources_list="/etc/apt/sources.list"
original_sources_list_backup="/etc/apt/sources.list.bak"
native_sources_list="/etc/apt/sources.list.d/$apt_native_arch-toolchain-sources.list"
foreign_sources_list="/etc/apt/sources.list.d/$apt_foreign_arch-toolchain-sources.list"

ubuntu_version="$(lsb_release -cs)"
dpkg --add-architecture "$apt_foreign_arch"

# Remove the original sources list
if [ -f "$original_sources_list" ] && [ ! -f "$original_sources_list_backup" ]; then
    mv "$original_sources_list" "$original_sources_list_backup"
fi

# Modify original sources list for native arch
if [ -f "$original_sources_list_backup" ] && [ ! -f "$native_sources_list" ]; then
    sed -r "s/^(( *# *)?(deb(-src)?)) http/\1 [arch=$apt_native_arch] http/g" "$original_sources_list_backup" > "$native_sources_list"
fi

# Create a foreign sources list
echo "deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version} main restricted
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-updates main restricted
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version} universe
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-updates universe
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version} multiverse
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-updates multiverse
deb [arch=${apt_foreign_arch}] ${apt_foreign_repo} ${ubuntu_version}-backports main restricted universe multiverse" > "$foreign_sources_list"
