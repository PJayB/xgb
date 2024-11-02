Cross-Platform Game Builds
==========================

Docker/Podman and CMake scripts to support cross-platform building of C/C++ game projects.

Dockerfile and Bash scripts for preparing an Ubuntu/Debian-based container for building within:

* `Dockerfile` and `example-install.bash`: an example of how to use the scripts to prepare a container.
* Configuring Apt for the newest CMake
* Configuring Apt for the newest Wine
* Configuring dpkg and Apt for cross-compilation
* Shorthands for installing gcc for the various platforms
* Installing the latest Emscripten SDK

CMake files for cross-compilation:

* Windows: Visual Studio 2022 and Mingw64
* Linux: x86_64 and aarch64
* Emscripten

CMake files providing common functionality for game projects:

* Copying assets into customizable locations in the build directory (`copyfile.cmake`)
* Packaging files into customizable locations in the Emscripten package (`empackager.cmake`)
* Copying and validating YAML source into the build tree (`yaml.cmake`)

To do:

* More mingw64 support scripts, e.g. fetching of glfw
* Documentation
* Scripts for help building within the container
* VSCode `launch.json` and `tasks.json` examples
