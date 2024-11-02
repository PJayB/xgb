#!/bin/bash
set -e
set -o pipefail

readarray -t archs < <(
    dpkg --print-architecture
    dpkg --print-foreign-architectures
    )

args=()
for i in "$@"; do
    if [[ "$i" == -* ]]; then
        args+=( "$i" )
    else
        for a in "${archs[@]}"; do
            args+=( "$i:$a" )
        done
    fi
done

apt-get install "${args[@]}"
