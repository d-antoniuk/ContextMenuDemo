    import QtQuick
    import QtQuick.Controls
    import QtQml

    Popup {
        id: menu
        width: 200
        modal: true
        focus: true
        padding: 6
        background: Rectangle {
            color: "#222222"
            radius: 8
        }

        property var menuData: []

        function buildMenu() {
            menuContent.data = []

            for (let i = 0; i < menu.menuData.length; i++) {
                let entry = menu.menuData[i]

                if (entry.type === "separator") {
                    var component = Qt.createComponent("Separator.qml")
                    if (component.status == Component.Ready) {
                        var separator = component.createObject(menuContent);
                    }
                } else if (entry.type === "item") {
                    let component = Qt.createComponent("MenuItem.qml")
                    if (component.status == Component.Ready) {
                        let item = component.createObject(menuContent, {
                            label: entry.label,
                            itemId: entry.id
                        })

                        item.triggered.connect(() => {
                            if (entry.handler)
                                entry.handler()
                            menu.close()
                        })
                    }
                }
            }
        }

        contentItem: Column {
            id: menuContent
            spacing: 4
        }
    }

