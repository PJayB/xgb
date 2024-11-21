Cross-Platform Game Builds
==========================

XGB provides a set of scripts to help bootstrap cross-platform building of C/C++ projects (with a strong bias towards game-like projects).

## `docker/`

The included Dockerfile and Bash scripts can be used to prepare an Ubuntu/Debian-based container for building without contaminating your system.

* `Dockerfile` and `example-install.bash`: an example of how to use the scripts to prepare a container.
* Configuring Apt for the newest CMake
* Configuring Apt for the newest Wine (useful for running Windows utilities like `fxc` at build time, or debugging MingW applications)
* Configuring dpkg and Apt for cross-compilation
* Shorthands for installing `gcc` for the various platforms
* Installing the latest Emscripten SDK

## `cmake/`

CMake Toolchain files are provided for for cross-compilation:

* Windows: Visual Studio 2022 and Mingw64
* Linux: x86_64 and aarch64
* Emscripten

Plus some CMake files providing common functionality for game projects:

* Copying assets into customizable locations in the build directory (`copyfile.cmake`)
* Packaging files into customizable locations in the Emscripten package (`empackager.cmake`)
* Copying and validating YAML source into the build tree (`yaml.cmake`)

## `xgb-cmake` Wrapper

`bin/xgb-cmake` wraps CMake to make it easier to build in a specific environment or a specific target. The command line is designed to be similar enough in many cases to `cmake` itself, but there are a few changes.

**WARNING: this script is highly opinionated.**

* Use `--podman-image` to run inside a podman container (or set the `XGB_PODMAN_IMAGE` enviroment variable). Use `-v` to mount things inside the container.
* Set `--emscripten` to use `emcmake` instead of regular `cmake`.
* It also provides some handy shorthands, such as `--cmake-trace` that turns on the most common CMake tracing switches, or `--open-log` that opens the output in `$EDITOR`.

## To Do

* More `mingw64` support scripts, e.g. fetching of glfw
* Documentation
* Scripts for help building within the container
* VSCode `launch.json` and `tasks.json` examples
