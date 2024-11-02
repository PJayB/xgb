#!/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

# CMake repo setup
cmakekey="/etc/apt/keyrings/kitware-archive-keyring.gpg"
[ -f "$cmakekey" ] || curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor -o "$cmakekey"
echo "deb [signed-by=$cmakekey] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null
