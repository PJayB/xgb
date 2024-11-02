cmake_minimum_required(VERSION 3.22)

#cmake_policy(SET CMP0156 NEW)

if (NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release)
endif ()

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

project(xplat-game-cmake-utils
    VERSION 0.0.1
    LANGUAGES C CXX
    HOMEPAGE_URL "https://github.com/PJayB/xplat-game-cmake-utils"
    )

include(../utils/copyfile.cmake)

if (EMSCRIPTEN)
    include(../utils/empackager.cmake)
endif()

add_executable(xplat-game-test
    main.cpp
)

if (MINGW)
    mingw_copy_dlls(xplat-game-test)
endif()
