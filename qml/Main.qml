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
    { type: "item", label: "Test", id: "" },

    { type: "submenu", label: "Test", children: [
        { type: "item", label: "Test", id: "" },
        { type: "item", label: "Test", id: "" },
        { type: "submenu", label: "Test", children: [
            { type: "item", label: "Test", id: "" },
            { type: "separator" },
            { type: "item", label: "Test", id: "" },
            { type: "item", label: "Test", id: "" }
        ]},
    ]},

    { type: "separator" },

    { type: "submenu", label: "Test", children: [
        { type: "item", label: "Test", id: "" },
        { type: "item", label: "Test", id: "" },
        { type: "submenu", label: "Test", children: [
            { type: "item", label: "Test", id: "" },
            { type: "separator" },
            { type: "item", label: "Test", id: "" },
            { type: "item", label: "Test", id: "" }
        ]},
    ]},

    { type: "separator" },

    { type: "item", label: "Test", id: "" },
    { type: "item", label: "Test", id: "" },

    { type: "separator" },

    { type: "item", label: "Test", id: "" },
    { type: "item", label: "Test", id: "" }
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

