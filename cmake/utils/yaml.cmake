find_program(YAMLLINT yamllint
    HINTS /usr/bin)

function(copy_yaml input_file output_file)
    add_custom_command(
        OUTPUT
            ${output_file}
        COMMAND
            ${CMAKE_COMMAND} -E copy "${input_file}" "${output_file}"
        DEPENDS
            ${input_file}
        VERBATIM
        )
endfunction()

function(copy_and_validate_yaml input_file output_file)
    add_custom_command(
        OUTPUT
            ${output_file}
        COMMAND
            ${YAMLLINT} ${input_file} &&
                ${CMAKE_COMMAND} -E copy "${input_file}" "${output_file}"
        DEPENDS
            ${input_file}
        VERBATIM
        )
endfunction()

function(add_yaml target_name file)
    set(input_file "${CMAKE_CURRENT_SOURCE_DIR}/${file}")
    set(output_file "${CMAKE_CURRENT_BINARY_DIR}/${file}")

    copy_yaml(${file} ${output_file})
    add_custom_target(${target_name} DEPENDS ${output_file})
endfunction()

function(target_add_yaml target_name scope)
    foreach(arg ${ARGN})
        set(input_file "${CMAKE_CURRENT_SOURCE_DIR}/${arg}")
        set(output_file "${CMAKE_CURRENT_BINARY_DIR}/${arg}")
        if (WIN32)
            copy_yaml(${input_file} ${output_file})
        else()
            copy_and_validate_yaml(${input_file} ${output_file})
        endif()
        list(APPEND dependencies ${output_file})
    endforeach()
    target_sources(${target_name} ${scope} ${dependencies})
endfunction()
