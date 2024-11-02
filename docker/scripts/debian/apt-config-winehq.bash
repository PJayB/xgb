#!/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

# Wine repo setup
winekey="/etc/apt/keyrings/winehq.gpg"
[ -f "$winekey" ] || curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | gpg --batch --dearmor -o "$winekey"
echo "deb [signed-by=$winekey] https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/winehq.list > /dev/null
