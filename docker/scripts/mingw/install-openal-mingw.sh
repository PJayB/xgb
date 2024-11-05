#/bin/bash
set -e
set -o pipefail

here="$(dirname "$0")"
source "$here/mingw-paths.sh"

openal_ver="1.23.0"
openal_lib="${MINGW_LIB_PATH}/OpenAL32.dll"
if [ -f "${openal_lib}" ]; then
    echo "${openal_lib} is already present"
else
    openal_zip="$here/openal-${openal_ver}.zip"

    unzip -joC -d"${MINGW_LIB_PATH}" "${openal_zip}" \
        "openal-soft-${openal_ver}-bin/libs/Win64/libOpenAL32.dll.a"
    unzip -jpC "${openal_zip}" \
        "openal-soft-${openal_ver}-bin/bin/Win64/soft_oal.dll" > "${MINGW_LIB_PATH}/OpenAL32.dll"
    unzip -joC -d"${MINGW_INCLUDE_PATH}/AL" "${openal_zip}" \
        "openal-soft-${openal_ver}-bin/include/AL/al.h" \
        "openal-soft-${openal_ver}-bin/include/AL/alc.h"
fi
