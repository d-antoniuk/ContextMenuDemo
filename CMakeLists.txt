cmake_minimum_required(VERSION 3.16)
project(DynamicMenuDemo LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickControls2
)

qt_add_executable(appDynamicMenuDemo
    main.cpp
)

qt_add_qml_module(appDynamicMenuDemo
    URI DynamicMenu
    VERSION 1.0
    QML_FILES
    qml/Main.qml
)

target_link_libraries(appDynamicMenuDemo
    PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)
