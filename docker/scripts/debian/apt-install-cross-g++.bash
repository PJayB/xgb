#/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

# Install foreign architecture toolchains
native_arch="$(uname -m)"
for arch in "$@" ; do
    [ "$native_arch" == "$arch" ] && continue

    packages+=( "g++-$arch-linux-gnu" )
done

apt-get install -y "${packages[@]}"
