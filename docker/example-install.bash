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
./debian/apt-install-foreign.bash -y \
    libglfw3-dev \
    libgles2-mesa-dev \
    libopenal1 libopenal-dev \
    ;

# Install foreign architecture toolchains
./debian/apt-install-cross-g++.bash

# Install mingw toolchain
./debian/apt-install-mingw64.bash

# Install emscripten SDK
./install-emsdk.bash
