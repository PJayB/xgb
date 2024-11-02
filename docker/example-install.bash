#!/bin/bash
#
# Copy this and adapt it for your project as needed
#
set -e
set -o pipefail

# Disable dumb tzdata interactivity (can occur during upgrades/some
# installations).
export DEBIAN_FRONTEND=noninteractive

# Install basics
apt-get update
apt-get upgrade -y
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
./debian/apt-config-aarch64.bash
./debian/apt-config-cmake.bash
#./debian/apt-config-winehq.bash
apt-get update

# Install toolchains, including foreign architecture toolchains
./debian/apt-install-toolchains.bash

# Install mingw toolchain
./debian/apt-install-mingw64.bash

# Install cross-platform Debian packages
./debian/apt-install-foreign.bash -y \
    libglfw3-dev \
    libgles2-mesa-dev \
    libopenal1 libopenal-dev \
    ;

# Install emscripten SDK
./install-emsdk.bash
