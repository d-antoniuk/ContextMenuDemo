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
            label: "Copy",
            id: "copy",
            shortcut: "Cmd+C",
            handler: function () {
                console.log("Copy");
            }
        },
        {
            type: "submenu",
            label: "Copy as",
            children: [
                {
                    type: "submenu",
                    label: "Copy as code",
                    children: [
                        { type: "item", label: "CSS", id: "copy-code-css" },
                        { type: "item", label: "CSS (all layers)", id: "copy-code-css-all" },
                        { type: "item", label: "iOS", id: "copy-code-ios" },
                        { type: "item", label: "Android", id: "copy-code-android" }
                    ]
                },
                { type: "item", label: "Copy as SVG", id: "copy-svg" },
                { type: "item", label: "Copy as PNG", id: "copy-png", shortcut: "Ctrl+Shift+C" },
                { type: "item", label: "Copy link to selection", id: "copy-link" },
                { type: "separator" },
                { type: "item", label: "Copy properties", id: "copy-props", shortcut: "Ctrl+Alt+C" }
            ]
        }
    ]

    ContextMenu {
        id: ctx
        menuData: root.menuJson
    }

    // Timer {
    //     interval: 12000
    //     running: true
    //     repeat: false
    //     onTriggered: {
    //         root.menuJson.push({
    //             type: "item",
    //             label: "Dynamic menu item",
    //             id: ""
    //         });

    //         const firstSubmenu = root.menuJson.find(entry => entry.type === "submenu");
    //         if (firstSubmenu) {
    //             firstSubmenu.children.push({
    //                 type: "item",
    //                 label: "Dynamic submenu item",
    //                 id: ""
    //             });

    //             firstSubmenu.children.push({
    //                 type: "submenu",
    //                 label: "Dynamic nested submenu",
    //                 children: [
    //                     {
    //                         type: "item",
    //                         label: "Nested item",
    //                         id: ""
    //                     },
    //                     {
    //                         type: "submenu",
    //                         label: "Deeper submenu",
    //                         children: [
    //                             {
    //                                 type: "item",
    //                                 label: "Deep item",
    //                                 id: ""
    //                             }
    //                         ]
    //                     }
    //                 ]
    //             });
    //         }
    //     }
    // }

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
