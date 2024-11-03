#!/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

die() { echo "$*" >&2 ; exit 1 ; 

case "$(dpkg --print-architecture)" in
amd64|i386) : ;;
*)          die "Wine is only supported on x86-based platforms." ;;
esac

# Wine repo setup
winekey="/etc/apt/keyrings/winehq.gpg"
[ -f "$winekey" ] || curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | gpg --batch --dearmor -o "$winekey"
echo "deb [signed-by=$winekey] https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/winehq.list > /dev/null
