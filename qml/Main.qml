import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import ContextMenu

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
            role: "name",
            width: 360
        },
        {
            title: "Version",
            role: "version",
            width: 160
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
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: Theme.panelBackground
            clip: true

            StackLayout {
                anchors.fill: parent
                anchors.margins: 12
                currentIndex: (deviceModel && (deviceModel.state === DeviceModel.Pending || deviceModel.state === DeviceModel.Error)) ? 1 : 0

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
                                    radius: 6

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
                        rowHeightProvider: function (row) {
                            return 40;
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            implicitWidth: tableView.columnWidth
                            implicitHeight: 40
                            color: tableView.activeRow === row ? Theme.rowActiveBackground : (row % 2 === 0 ? Theme.rowEvenBackground : Theme.rowOddBackground)
                            border.width: 1
                            border.color: Theme.rowBorder
                            radius: 6

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
                        text: deviceModel && deviceModel.statusMessage.length > 0 ? deviceModel.statusMessage : (deviceModel && deviceModel.state === DeviceModel.Pending ? "Loading devices..." : "Failed to load devices")
                        color: Theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }
        }
    }

    ContextMenu {
        id: rowContextMenu
        property var currentDevice: null

        function showFor(device, point) {
            currentDevice = device;
            menuData = [
                {
                    type: "submenu",
                    label: "Option-level-1",
                    shortcut: "Alt+1",
                    children: [
                        {
                            type: "submenu",
                            label: "Option-level-2",
                            shortcut: "Alt+2",
                            children: [
                                {
                                    type: "item",
                                    label: "Option-level-3",
                                    id: "option-level-3",
                                    shortcut: "Alt+3",
                                    handler: function () {
                                        console.log(device.name, device.version);
                                    }
                                }
                            ]
                        }
                    ]
                },
                {
                    type: "item",
                    label: "Option-2-level-1",
                    id: "option-2-level-2",
                    shortcut: "Ctrl+D",
                    handler: function () {
                        console.log(device.name, device.version);
                    }
                }
            ];

            openAt(point.x, point.y);
        }
    }
}
