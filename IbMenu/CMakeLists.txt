set_source_files_properties(qml/Theme.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(IbMenu
    URI IbMenu
    VERSION 1.0
    QML_FILES
        qml/IbMenu.qml
        qml/MenuPopup.qml
        qml/MenuEntry.qml
        qml/Separator.qml
        qml/Theme.qml
)
