cmake_minimum_required(VERSION 3.22)

project(Qt6CMakeTemplate
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "Simple cross-platform Qt6 cmake setup, that can be used as a starting point for a Qt c++ project."
    HOMEPAGE_URL "https://github.com/M3D-249/Qt6CMakeTemplate"
)

# C++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Versioning
configure_file(
    cmake/Version.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/Version.h
    @ONLY
)

# Qt 
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Widgets
)

qt_standard_project_setup()

# sources and subdirectories
add_executable(Qt6CMakeTemplate
    main.cpp
)

include_directories(Qt6CMakeTemplate PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/generated
)

target_link_libraries(Qt6CMakeTemplate PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
)

# Installation
include(GNUInstallDirs)
install(TARGETS Qt6CMakeTemplate
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Deployment
qt_generate_deploy_app_script(
    TARGET Qt6CMakeTemplate
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)

install(SCRIPT ${deploy_script})

# Tests
if (BUILD_TESTING)
    enable_testing()
    
    find_package(Qt6 REQUIRED COMPONENTS Test)
    
    add_executable(SimpleTest tests/test_main.cpp)
    target_link_libraries(SimpleTest PRIVATE 
        Qt6::Core 
        Qt6::Widgets 
        Qt6::Gui 
        Qt6::Test
    )
    
    add_test(
        NAME SimpleTest
        COMMAND SimpleTest
    )
endif()