import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import DemoApp
import IbMenu

Window {
    id: root
    width: 800
    height: 450
    visible: true
    title: "Device Manager"
    color: Theme.windowBackground

    property var columns: [
        {
            title: "Name",
            role: "name"
        },
        {
            title: "Version",
            role: "version"
        }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Text {
            text: "Devices"
            color: Theme.textPrimary
            font.pixelSize: 22
            font.bold: true
            horizontalAlignment: Text.AlignLeft
        }

        Rectangle {
            id: panelContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Theme.radius
            color: Theme.panelBackground
            clip: true

            readonly property bool isBusy: deviceModel && deviceModel.state !== DeviceModel.Ready
            readonly property string statusText: deviceModel ? deviceModel.statusMessage : ""

            StackLayout {
                anchors.fill: parent
                anchors.margins: 12
                currentIndex: panelContainer.isBusy ? 1 : 0

                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        id: header
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        Row {
                            anchors.fill: parent
                            spacing: 0

                            Repeater {
                                model: root.columns
                                delegate: Rectangle {
                                    width: tableView.columnWidth
                                    height: header.height
                                    color: Theme.headerBackground
                                    border.width: 1
                                    border.color: Theme.rowBorder
                                    radius: Theme.radius

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.title
                                        color: Theme.headerText
                                        font.pixelSize: 14
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }

                    TableView {
                        id: tableView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columnSpacing: 0
                        rowSpacing: 2
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        reuseItems: true
                        model: deviceModel
                        property int activeRow: -1
                        property real columnWidth: (root.columns && root.columns.length > 0) ? width / root.columns.length : 0

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            implicitWidth: tableView.columnWidth
                            implicitHeight: 40
                            color: tableView.activeRow === row ? Theme.rowActiveBackground : (row % 2 === 0 ? Theme.rowEvenBackground : Theme.rowOddBackground)
                            border.width: 1
                            border.color: Theme.rowBorder
                            radius: Theme.radius

                            property var columnInfo: root.columns[column]

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                text: model[columnInfo.role]
                                color: Theme.textPrimary
                                font.pixelSize: Theme.fontSize
                                elide: Text.ElideRight
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                onClicked: function (mouse) {
                                    tableView.activeRow = row;
                                    if (mouse.button === Qt.RightButton) {
                                        const globalPos = mouseArea.mapToItem(null, mouse.x, mouse.y);
                                        rowContextMenu.showFor(model, globalPos);
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        anchors.centerIn: parent
                        text: panelContainer.statusText
                        color: Theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }
        }
    }

    IbMenu {
        id: rowContextMenu
        property var currentDevice: null

        function showFor(device, point) {
            currentDevice = device;
            menuData = [
                {
                    type: "item",
                    label: "Option 1",
                    id: "option-1",
                    checkable: true,
                    checked: true,
                    handler: function () {}
                },
                {
                    type: "item",
                    label: "Option 2",
                    id: "option-2",
                    checkable: true,
                    checked: false,
                    shortcut: "Ctrl+L",
                    handler: function () {}
                },
                {
                    type: "separator"
                },
                {
                    type: "submenu",
                    label: "Option 3",
                    children: [
                        {
                            type: "submenu",
                            label: "Option 4",
                            children: [
                                {
                                    type: "item",
                                    label: "Option 5",
                                    id: "option-5",
                                    shortcut: "Alt+3",
                                    checkable: true,
                                    checked: true,
                                    handler: function () {
                                        console.log(device.name, device.version, "Option-5 checked:", rowContextMenu.checkedItems["option-5"]);
                                    }
                                }
                            ]
                        }
                    ]
                },
                {
                    type: "item",
                    label: "Option 6",
                    id: "option-6",
                    shortcut: "Ctrl+D",
                    checkable: true,
                    handler: function () {
                        console.log(device.name, device.version, "Option-6 checked:", rowContextMenu.checkedItems["option-6"]);
                    }
                }
            ];

            openAt(point.x, point.y);
        }
    }
}
