#!/bin/bash
#
# TODO: documentation
#
set -e
set -o pipefail

args=()
archs=()
for i in "$@"; do
    if [[ "$i" == -* ]]; then
        args+=( "$i" )
    else
        archs+=( "$i" )
    fi
done

while read -r package ; do
    for a in "${archs[@]}"; do
        args+=( "$package:$a" )
    done
done

apt-get install "${args[@]}"
