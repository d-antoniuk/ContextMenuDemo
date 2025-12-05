import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: root
    width: 400
    height: 300
    visible: true
    title: "Context Menu"

    property var menuData: [
        { label: "Open",  id: "open",  handler: () => console.log("OPEN executed") },
        { label: "Save",  id: "save",  handler: () => console.log("SAVE executed") },
        { label: "Close", id: "close", handler: () => console.log("CLOSE executed") }
    ]

    Menu {
        id: contextMenu

        Instantiator {
            model: root.menuData

            delegate: MenuItem {
                text: modelData.label
                onTriggered: modelData.handler()
            }

            onObjectAdded: (i, o) => contextMenu.insertItem(i, o)
            onObjectRemoved: (i, o) => contextMenu.removeItem(o)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#2b2b2b"

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup(mouse.x, mouse.y)
            }
        }
    }
}
