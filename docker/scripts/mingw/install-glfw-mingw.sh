#/bin/bash
set -e
set -o pipefail

here="$(dirname "$0")"
source "$here/mingw-paths.sh"

glfw_ver=3.4
glfw_long_ver="glfw-${glfw_ver}.bin.WIN64"
glfw_lib="${MINGW_LIB_PATH}/libglfw3dll.a"
if [ -f "${glfw_lib}" ]; then
    echo "${glfw_lib} is present"
else
    glfw_zip="$here/${glfw_long_ver}.zip"

    unzip -joC -d"${MINGW_LIB_PATH}" "${glfw_zip}" \
        "${glfw_long_ver}/lib-mingw-w64/glfw3.dll" \
        "${glfw_long_ver}/lib-mingw-w64/libglfw3dll.a"
    unzip -joC -d"${MINGW_INCLUDE_PATH}/GLFW" "${glfw_zip}" \
        "${glfw_long_ver}/include/GLFW/glfw3.h" \
        "${glfw_long_ver}/include/GLFW/glfw3native.h"
fi
