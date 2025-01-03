#
# Generates an .inl file containing file contents for #including in C/C++ directly
#

#
# Download and install inline-it from https://github.com/PJayB/inline-it
#
find_program(INLINE_IT inline-it REQUIRED)

function(add_inline_resource target src_path)
    set(options BARE NULL_TERMINATE)
    set(oneValueArgs OUTPUT WORKING_DIRECTORY)
    set(multiValueArgs)
    cmake_parse_arguments(ADD_INLINE_RESOURCES "${options}" "${oneValueArgs}"
        "${multiValueArgs}" ${ARGN})

    get_filename_component(file "${src_path}" NAME)
    if (NOT ADD_INLINE_RESOURCES_OUTPUT)
        set(ADD_INLINE_RESOURCES_OUTPUT "${file}.inl")
    endif()
    if (NOT ADD_INLINE_RESOURCES_WORKING_DIRECTORY)
        set(ADD_INLINE_RESOURCES_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    endif()
    if (ADD_INLINE_RESOURCES_BARE)
        set(INLINE_IT_COMMAND ${INLINE_IT} -b)
    else()
        set(INLINE_IT_COMMAND ${INLINE_IT})
    endif()

    set(NULL_TERMINATE_SWITCH "")
    if (ADD_INLINE_RESOURCES_NULL_TERMINATE)
        set(NULL_TERMINATE_SWITCH "-z")
    endif()

    get_filename_component(target_file "${ADD_INLINE_RESOURCES_OUTPUT}"
        REALPATH BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")

    add_custom_command(
        OUTPUT
            ${target_file}
        COMMAND
            ${INLINE_IT_COMMAND} ${NULL_TERMINATE_SWITCH} -o "${target_file}" ${src_path}
        DEPENDS
            ${src_path}
        WORKING_DIRECTORY
            ${ADD_INLINE_RESOURCES_WORKING_DIRECTORY}
        VERBATIM
        )

    add_custom_target(${target})
    target_sources(${target} PRIVATE ${target_file})
endfunction()


function(add_inline_resources target)
    set(options NULL_TERMINATE)
    set(oneValueArgs OUTPUT WORKING_DIRECTORY)
    set(multiValueArgs FILES)
    cmake_parse_arguments(ADD_INLINE_RESOURCES "${options}" "${oneValueArgs}"
        "${multiValueArgs}" ${ARGN})

    if (NOT ADD_INLINE_RESOURCES_OUTPUT)
        set(ADD_INLINE_RESOURCES_OUTPUT "${target}.inl")
    endif()
    if (NOT ADD_INLINE_RESOURCES_WORKING_DIRECTORY)
        set(ADD_INLINE_RESOURCES_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    endif()
    if (NOT ADD_INLINE_RESOURCES_FILES)
        message(FATAL_ERROR "FILES not set.")
    endif()

    set(NULL_TERMINATE_SWITCH "")
    if (ADD_INLINE_RESOURCES_NULL_TERMINATE)
        set(NULL_TERMINATE_SWITCH "-z")
    endif()

    get_filename_component(target_file "${ADD_INLINE_RESOURCES_OUTPUT}"
        REALPATH BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")

    foreach (src_path ${ADD_INLINE_RESOURCES_FILES})
        # todo: ideally we'd use the relative path here, e.g.
        #   ${CMAKE_CURRENT_SOURCE_DIR}/a/b/c
        # would become
        #   ${CMAKE_CURRENT_BINARY_DIR}/a/b/c.inl
        get_filename_component(file "${src_path}" NAME)
        get_filename_component(dest_path "${file}.inl"
            REALPATH BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")

        list(APPEND target_paths "${dest_path}")

        add_custom_command(
            OUTPUT
                ${dest_path}
            COMMAND
                ${INLINE_IT} ${NULL_TERMINATE_SWITCH} -o "${dest_path}" "${file}"
            DEPENDS
                ${src_path}
            WORKING_DIRECTORY
                ${ADD_INLINE_RESOURCES_WORKING_DIRECTORY}
            VERBATIM
            )
    endforeach()

    add_custom_command(
        OUTPUT
            ${target_file}
        DEPENDS
            ${target_paths}
        COMMAND
            "${CMAKE_COMMAND}" -E cat ${target_paths} > ${target_file}
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_BINARY_DIR}
        VERBATIM
        )

    add_custom_target(${target})
    target_sources(${target} PRIVATE ${target_file})
endfunction()
