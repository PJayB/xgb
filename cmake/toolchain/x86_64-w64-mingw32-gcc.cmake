#
# TODO: documentation
#
set(CMAKE_SYSTEM_NAME Windows)

set(MINGW 1)
set(MINGW32 1)
set(MINGW64 1)
set(WIN32 1)

add_definitions(-DWIN32)
add_definitions(-D_WIN32)
add_definitions(-D_WINDOWS)

set(CMAKE_SYSTEM_PROCESSOR "x86_64" CACHE STRING "The target processor")
set(MINGW_TRIPLE "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target triple to use")
set(MINGW_GCC_NAME "${MINGW_TRIPLE}-gcc" CACHE STRING "The C compiler name to use")
set(MINGW_GXX_NAME "${MINGW_TRIPLE}-g++" CACHE STRING "The C++ compiler name to use")
set(MINGW_RC_NAME "${MINGW_TRIPLE}-windres" CACHE STRING "The RC compiler name to use")
set(MINGW_RANLIB_NAME "${MINGW_TRIPLE}-ranlib" CACHE STRING "The windres compiler name to use")

include(${CMAKE_CURRENT_LIST_DIR}/shared/gcc.cmake)

#
# Set the sysroot
#
if (NOT "$ENV{MSYSTEM_PREFIX}" STREQUAL "")
    # Running in Msys
    set(MINGW_ROOT $ENV{MSYSTEM_PREFIX})
    set(MINGW_DLL_PATH ${MINGW_ROOT}/bin)
else()
    # Running on Linux
    set(MINGW_ROOT /usr/x86_64-w64-mingw32)
    set(CMAKE_SYSROOT ${MINGW_ROOT})

    # We don't set MINGW_DLL_PATH here as we get it from GCC soon
    # set(MINGW_DLL_PATH /usr/lib/gcc/x86_64-w64-mingw32/<VERSION>)
endif()

set(CMAKE_FIND_ROOT_PATH ${MINGW_ROOT} CACHE STRING "The location to search for files")
set(CMAKE_SYSTEM_PREFIX_PATH ${MINGW_ROOT} CACHE STRING "The location of system headers and libraries")
#set(CMAKE_STAGING_PREFIX ${MINGW_ROOT} CACHE STRING "The path to install to when cross-compiling")
set(CMAKE_FIND_NO_INSTALL_PREFIX ON) # Don t search the staging prefix when looking for files

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

#
# Set the compiler name
#
find_program(CMAKE_C_COMPILER ${MINGW_GCC_NAME})
find_program(CMAKE_CXX_COMPILER ${MINGW_GXX_NAME})
find_program(CMAKE_RC_COMPILER ${MINGW_RC_NAME})
find_program(CMAKE_RANLIB ${MINGW_RANLIB_NAME})

# Set the DLL path based on the GCC version on Linux
if ("$ENV{MSYSTEM}" STREQUAL "")
    execute_process(
        COMMAND ${CMAKE_C_COMPILER} -dumpversion
        OUTPUT_VARIABLE MINGW_GCC_VER
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    set(MINGW_DLL_PATH /usr/lib/gcc/${MINGW_TRIPLE}/${MINGW_GCC_VER})
endif()

# todo: fixme: this doesn't expand properly and has semicolons in it, and find_path is shit
find_file(MINGW_WINPTHREAD_DLL_PATH libwinpthread-1.dll PATH_SUFFIXES lib REQUIRED)

#
# Install DLLs into the build folder of the executable for debugging
#
function (mingw_copy_dlls target)
    set(COPY_DLL_TARGET_PATH $<TARGET_FILE_DIR:${target}>)
    foreach (dll
        "${MINGW_WINPTHREAD_DLL_PATH}"
        "${MINGW_DLL_PATH}/libgcc_s_seh-1.dll"
        "${MINGW_DLL_PATH}/libstdc++-6.dll"
        ${ARGN}
    )
        add_custom_command(
            TARGET ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND}
                ARGS -E copy "${dll}" ${COPY_DLL_TARGET_PATH}/
                VERBATIM)
    endforeach()
endfunction()
