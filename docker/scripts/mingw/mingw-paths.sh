#!/bin/bash
set -e
set -o pipefail

# Check whether this is Msys
if [ "$(uname -o)" = "Msys" ]; then
    MINGW_ROOT="${MSYSTEM_PREFIX:-/mingw64}"
    MINGW_BIN_PATH="${PKG_CONFIG_SYSTEM_BINARY_PATH:-$MSYSTEM_PREFIX/bin}"
    MINGW_LIB_PATH="${PKG_CONFIG_SYSTEM_LIBRARY_PATH:-$MSYSTEM_PREFIX/lib}"
    MINGW_INCLUDE_PATH="${PKG_CONFIG_SYSTEM_INCLUDE_PATH:-$MSYSTEM_PREFIX/include}"
else
    MINGW_ROOT="${MSYSTEM_PREFIX:-/usr/x86_64-w64-mingw32}"
    MINGW_BIN_PATH="$MINGW_ROOT/bin"
    MINGW_LIB_PATH="$MINGW_ROOT/lib"
    MINGW_INCLUDE_PATH="$MINGW_ROOT/include"
fi

if [ ! -d "$MINGW_ROOT" ]; then
    echo "Couldn't dtermine MINGW_ROOT" >&2
    exit 1
fi
