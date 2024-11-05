#!/bin/bash
#
# TODO: documentation
#
# Copy this and adapt it for your project as needed
#
set -e
set -o pipefail

# Install basics
apt-get install -y \
    lsb-release \
    git \
    curl \
    wget \
    unzip \
    tar \
    gpg \
    ;

# Configure apt sources
./debian/apt-config-cmake.bash
#./debian/apt-config-winehq.bash
apt-get update

# Install native toolchain
apt-get install -y \
    build-essential \
    ninja-build \
    cmake \
    ;

# Install cross-platform Debian packages
echo "
    libglfw3-dev
    libgles2-mesa-dev
    libopenal1 libopenal-dev
" | ./debian/apt-install-foreign.bash -y aarch64 i386 x86_64

# Install foreign architecture toolchains
./debian/apt-install-cross-g++.bash aarch64 i386 x86_64

# Install mingw toolchain
./debian/apt-install-mingw64.bash
./mingw/install-glfw-mingw.sh
./mingw/install-openal-mingw.sh

# Install emscripten SDK
./install-emsdk.bash latest
