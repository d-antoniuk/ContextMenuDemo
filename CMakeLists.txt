cmake_minimum_required(VERSION 3.16)

project(ContextMenuDemo LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Qml
    Quick
    QuickControls2
)

qt_standard_project_setup()

add_subdirectory(IbMenu)

qt_add_executable(DemoAppExe
    src/main.cpp
    src/device_model.cpp
    src/device_model.h
)

qt_add_qml_module(DemoAppExe
    URI DemoApp
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(DemoAppExe
    PRIVATE
        IbMenu
        Qt6::Quick
        Qt6::QuickControls2
)
