
SET(LOCAL_FILES
    vrpRouting-header.sql
    )

foreach (f ${LOCAL_FILES})
    configure_file(${f} ${f})
    list(APPEND PACKAGE_SQL_FILES  ${CMAKE_CURRENT_BINARY_DIR}/${f})
endforeach()

set(PROJECT_SQL_FILES ${PROJECT_SQL_FILES} ${PACKAGE_SQL_FILES} PARENT_SCOPE)

configure_file(${PROJECT_NAME_LOWER}.control ${PROJECT_NAME_LOWER}.control)
