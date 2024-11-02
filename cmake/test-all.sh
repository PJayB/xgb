#!/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

sourcedir="${1:-test}"
builddir="$sourcedir/build"
mkdir -p "$builddir"

for preset in x86_64-w64-mingw32 x86_64-linux-gnu aarch64-linux-gnu; do
    cmake -S "$sourcedir" --preset "$preset" >"$builddir/config.$preset.log" 2>&1 && \
        cmake --build "$builddir/$preset" -j"${nproc}" >"$builddir/build.$preset.log" 2>&1 || :
done

preset=wasm32-unknown-emscripten
emcmake cmake -S "$sourcedir" --preset "$preset" >"$builddir/config.$preset.log" 2>&1 && \
        emcmake cmake --build "$builddir/$preset" -j"${nproc}" >"$builddir/build.$preset.log" 2>&1 || :
