function(target_windows_gui target value)
    if (${value})
        if (NOT XGB_WINDOWS_GUI_SWITCH)
            message(FATAL_ERROR "XGB_WINDOWS_GUI_SWITCH not set.")
        endif()
        target_link_options(${target} PUBLIC
            "${XGB_WINDOWS_GUI_SWITCH}"
        )
    else()
        if (NOT XGB_WINDOWS_CONSOLE_SWITCH)
            message(FATAL_ERROR "XGB_WINDOWS_CONSOLE_SWITCH not set.")
        endif()
        target_link_options(${target} PUBLIC
            "${XGB_WINDOWS_CONSOLE_SWITCH}"
        )
    endif()
endfunction()
