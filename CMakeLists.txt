cmake_minimum_required(VERSION 3.16)
project(ContextMenuProject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickControls2
)

qt_add_executable(ContextMenuDemo
    main.cpp
)

qt_add_qml_module(ContextMenuDemo
    URI ContextMenu
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ContextMenu.qml
        qml/MenuItem.qml
        qml/Separator.qml
)

target_link_libraries(ContextMenuDemo
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)
