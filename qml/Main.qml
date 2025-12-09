import QtQuick
import QtQuick.Window
import QtQuick.Controls
import ContextMenu

Window {
    id: root
    width: 900
    height: 600
    visible: true
    title: "Context Menu"

    property var menuJson: [
        {
            type: "item",
            label: "Test",
            id: "",
            handler: function () {
                console.log("Test menu entry click");
            }
        },
        {
            type: "submenu",
            label: "Test",
            children: [
                {
                    type: "item",
                    label: "Test",
                    id: ""
                },
                {
                    type: "item",
                    label: "Test",
                    id: ""
                },
                {
                    type: "submenu",
                    label: "Test",
                    children: [
                        {
                            type: "item",
                            label: "Test",
                            id: ""
                        },
                        {
                            type: "separator"
                        },
                        {
                            type: "item",
                            label: "Test",
                            id: ""
                        },
                        {
                            type: "item",
                            label: "Test",
                            id: ""
                        }
                    ]
                },
            ]
        },
        {
            type: "separator"
        },
        {
            type: "submenu",
            label: "Test",
            children: [
                {
                    type: "item",
                    label: "Test",
                    id: ""
                },
                {
                    type: "item",
                    label: "Test",
                    id: ""
                },
                {
                    type: "submenu",
                    label: "Test",
                    children: [
                        {
                            type: "item",
                            label: "Test",
                            id: ""
                        },
                        {
                            type: "separator"
                        },
                        {
                            type: "item",
                            label: "Test",
                            id: ""
                        },
                        {
                            type: "item",
                            label: "Test",
                            id: ""
                        }
                    ]
                },
            ]
        },
        {
            type: "separator"
        },
        {
            type: "item",
            label: "Test",
            id: ""
        },
        {
            type: "item",
            label: "Test",
            id: ""
        },
        {
            type: "separator"
        },
        {
            type: "item",
            label: "Test",
            id: ""
        },
        {
            type: "item",
            label: "Test",
            id: ""
        }
    ]

    ContextMenu {
        id: ctx
        menuData: root.menuJson
    }

    Timer {
        interval: 12000
        running: true
        repeat: false
        onTriggered: {
            root.menuJson.push({
                type: "item",
                label: "Dynamic menu item",
                id: ""
            });

            const firstSubmenu = root.menuJson.find(entry => entry.type === "submenu");
            if (firstSubmenu) {
                firstSubmenu.children.push({
                    type: "item",
                    label: "Dynamic submenu item",
                    id: ""
                });

                firstSubmenu.children.push({
                    type: "submenu",
                    label: "Dynamic nested submenu",
                    children: [
                        {
                            type: "item",
                            label: "Nested item",
                            id: ""
                        },
                        {
                            type: "submenu",
                            label: "Deeper submenu",
                            children: [
                                {
                                    type: "item",
                                    label: "Deep item",
                                    id: ""
                                }
                            ]
                        }
                    ]
                });
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                ctx.openAt(mouse.x, mouse.y);
            }
        }
    }
}
