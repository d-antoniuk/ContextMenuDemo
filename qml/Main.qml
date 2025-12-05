import QtQuick
import QtQuick.Window
import QtQuick.Controls
import ContextMenu

Window {
    id: root
    width: 450
    height: 320
    visible: true
    title: "Context Menu"

    property var menuJson: [
        { type: "item", label: "New File", id: "new", handler: () => console.log("NEW FILE") },
        { type: "item", label: "Open…", id: "open", handler: () => console.log("OPEN") },
        { type: "separator" },
        { type: "item", label: "Save", id: "save", handler: () => console.log("SAVE") },
        { type: "item", label: "Save As…", id: "saveAs", handler: () => console.log("SAVE AS") },
        { type: "separator" },
        { type: "item", label: "Exit", id: "exit", handler: () => Qt.quit() }
    ]

    ContextMenu {
        id: ctx
        menuData: root.menuJson
    }

    Rectangle {
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton

            onClicked: function(mouse) {
                if (mouse.button === Qt.RightButton) {
                    ctx.buildMenu()
                    ctx.x = mouse.x
                    ctx.y = mouse.y
                    ctx.open()
                }
            }
        }
    }
}

