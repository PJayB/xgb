#/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

packages=(
    build-essential
    ninja-build
    cmake
)

# Install foreign architecture toolchains
while read -r arch ; do
    arch="$(echo "$arch" |
        sed 's/amd64/x86_64/g' |
        sed 's/arm64/aarch64/g' |
        sed 's/i386/i686/g' |
        cat)"
    packages+=( "g++-$arch-linux-gnu" )
done < <(dpkg --print-foreign-architectures)

apt-get install -y "${packages[@]}"
