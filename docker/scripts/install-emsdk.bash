#!/bin/bash
set -e
set -o pipefail

emsdk_root="${1:-/opt/emsdk}"

git clone https://github.com/emscripten-core/emsdk.git "$emsdk_root"
"$emsdk_root/emsdk" install latest
"$emsdk_root/emsdk" activate latest

source "$emsdk_root/emsdk_env.sh"
embuilder.py --pic build ALL

echo 'export EMSDK_QUIET=1' >> /etc/profile.d/emsdk.sh
echo 'export EM_FROZEN_CACHE=1' >> /etc/profile.d/emsdk.sh
echo "source $emsdk_root/emsdk_env.sh" >> /etc/profile.d/emsdk.sh
