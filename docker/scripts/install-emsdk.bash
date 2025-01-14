#!/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

emversion="$1"
if [ -z "$emversion" ]; then
    echo "Specify Emscripten version or 'latest'" >&2
    exit 1
fi

emsdk_root="${2:-/opt/emsdk}"

if [ ! -d "$emsdk_root" ]; then
    git clone https://github.com/emscripten-core/emsdk.git "$emsdk_root"
fi
"$emsdk_root/emsdk" install "$emversion"
"$emsdk_root/emsdk" activate "$emversion"

# Load the Emscipten environment
source "$emsdk_root/emsdk_env.sh"

# Warm the dependency cache
embuilder.py --pic build ALL

# Install typescript
npm install -g typescript

# Set up the environment for subsequent runs
echo 'export EMSDK_QUIET=1' >> /etc/profile.d/emsdk.sh
echo 'export EM_FROZEN_CACHE=1' >> /etc/profile.d/emsdk.sh
echo "source $emsdk_root/emsdk_env.sh" >> /etc/profile.d/emsdk.sh
