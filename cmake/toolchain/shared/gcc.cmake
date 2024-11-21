
set(CMAKE_C_FLAGS "-Wall -Werror" CACHE STRING "C compiler flags")
set(CMAKE_C_FLAGS_DEBUG "-D_DEBUG -DDEBUG -O0 -g" CACHE STRING "C compiler flags (debug)")
set(CMAKE_CXX_FLAGS "-Wall" CACHE STRING "C++ compiler flags")
set(CMAKE_CXX_FLAGS_DEBUG "-D_DEBUG -DDEBUG -O0 -g" CACHE STRING "C++ compiler flags (debug)")

set(XGB_WINDOWS_CONSOLE_SWITCH "-mconsole" CACHE STRING "Use this linker option if making a console Windows app.")
set(XGB_WINDOWS_GUI_SWITCH "-mwindows" CACHE STRING "Use this linker option if making a regular Windows app.")
