set(CMAKE_C_FLAGS "/Zi /EHsc" CACHE STRING "C compiler flags")
set(CMAKE_C_FLAGS_DEBUG "/D_DEBUG /DDEBUG /Od" CACHE STRING "C compiler flags (debug)")
set(CMAKE_CXX_FLAGS "/Zi /EHsc" CACHE STRING "C++ compiler flags")
set(CMAKE_CXX_FLAGS_DEBUG "/D_DEBUG /DDEBUG /Od" CACHE STRING "C++ compiler flags (debug)")

set(XGB_WINDOWS_CONSOLE_SWITCH "/SUBSYSTEM:CONSOLE" CACHE STRING "Use this linker option if making a console Windows app.")
set(XGB_WINDOWS_GUI_SWITCH "/SUBSYSTEM:WINDOWS" CACHE STRING "Use this linker option if making a regular Windows app.")
