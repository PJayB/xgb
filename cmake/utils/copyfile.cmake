#
# Installs files to a custom location in the build folder using `src@relative_dst` syntax
# todo: I kinda hate this in retrospect
#
function(target_custom_copy_files)
    set(options)
    set(oneValueArgs NAME TARGET)
    set(multiValueArgs COMMAND FILES)
    cmake_parse_arguments(TARGET_COPY_FILES "${options}" "${oneValueArgs}"
        "${multiValueArgs}" ${ARGN})

    if (NOT TARGET_COPY_FILES_TARGET)
        message(FATAL_ERROR "TARGET not set.")
    endif()
    if (NOT TARGET_COPY_FILES_COMMAND)
        set(TARGET_COPY_FILES_COMMAND "${CMAKE_COMMAND}" -E copy)
    endif()

    foreach (arg ${TARGET_COPY_FILES_FILES})
        string(FIND ${arg} "@" at_pos)
        if (at_pos EQUAL -1)
            message(FATAL_ERROR "Cannot find '@' in '" ${arg} "'")
        endif()

        string(SUBSTRING ${arg} 0 ${at_pos} source_file)
        math(EXPR at_pos "${at_pos}+1")
        string(SUBSTRING ${arg} ${at_pos} -1 dest_path)
        if (source_file STREQUAL "")
            message(FATAL_ERROR "copy_files requires src in src@dst: " ${arg})
        endif()
        if (dest_path STREQUAL "")
            message(FATAL_ERROR "copy_files requires dst in src@dst: " ${arg})
        endif()

        if (IS_DIRECTORY ${dest_path} OR ${dest_path} MATCHES ".*/$")
            cmake_path(GET source_file FILENAME source_filename)
            cmake_path(APPEND dest_path "${source_filename}")
        endif()

        list(APPEND target_paths "${dest_path}")

        add_custom_command(
            OUTPUT
                ${dest_path}
            COMMAND
                ${TARGET_COPY_FILES_COMMAND} "${source_file}" "${dest_path}"
            DEPENDS
                ${source_file}
            WORKING_DIRECTORY
                ${CMAKE_CURRENT_BINARY_DIR}
            VERBATIM
            )
    endforeach()
    add_custom_target(${TARGET_COPY_FILES_TARGET} DEPENDS ${target_paths})
endfunction()
