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

set(qml_files
    qml/Main.qml
    qml/ContextMenu.qml
    qml/MenuPopup.qml
    qml/MenuEntry.qml
    qml/Separator.qml
)

set(qml_singletons
    qml/Theme.qml
)

set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(ContextMenuDemo
    URI ContextMenu
    VERSION 1.0
    QML_FILES
        ${qml_files}
        ${qml_singletons}
)

target_link_libraries(ContextMenuDemo
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)
