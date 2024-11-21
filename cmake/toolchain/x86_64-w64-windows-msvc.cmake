#
# TODO: documentation
#
set(CMAKE_SYSTEM_NAME Windows)

set(MSVC 1)
set(WIN32 1)

add_definitions(-DWIN32)
add_definitions(-D_WIN32)
add_definitions(-D_WINDOWS)

include(${CMAKE_CURRENT_LIST_DIR}/shared/msvc.cmake)
