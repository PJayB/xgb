#
# Package files into an Emscripten package
#
# TODO: documentation
#
find_program(EMSCRIPTEN_PACKAGER
    NAMES file_packager
    HINTS
        /usr/share/emscripten
        /lib/emscripten
    PATH_SUFFIXES
        tools
    REQUIRED
)

function(em_package_files data_file_name js_file_name)
    # Strip all @... off each input
    foreach (arg ${ARGN})
        string(REGEX REPLACE "@.+" "" stripped_arg ${arg})
        list(APPEND package_inputs "${stripped_arg}")
    endforeach()

    # Add the inputs
    add_custom_command(
        OUTPUT
            ${data_file_name}
            ${js_file_name}
        COMMAND
            ${EMSCRIPTEN_PACKAGER}
                ${data_file_name}
                --js-output=${js_file_name}
                --preload ${ARGN}
        DEPENDS
            ${package_inputs}
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_BINARY_DIR}
        VERBATIM
        )
endfunction()

function(target_package_for_emscripten target_name data_file_name js_file_name)
    em_package_files(${data_file_name} ${js_file_name} ${ARGN})
    add_custom_target(${target_name}
        DEPENDS ${data_file_name} ${js_file_name})
endfunction()
