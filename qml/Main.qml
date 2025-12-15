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
    title: "Device table with context menu"

    color: Theme.windowBackground

    property var columns: [
        { title: "Name", role: "name", width: 360 },
        { title: "Version", role: "version", width: 160 }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Text {
            text: "Devices"
            color: Theme.text
            font.pixelSize: 22
            font.bold: true
            horizontalAlignment: Text.AlignLeft
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: Theme.panelBackground
            border.color: Theme.panelBorder
            clip: true

            StackLayout {
                anchors.fill: parent
                anchors.margins: 12
                currentIndex: (deviceModel && (deviceModel.state === DeviceModel.Pending || deviceModel.state === DeviceModel.Error)) ? 1 : 0

                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        id: header
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: 8
                        color: Theme.headerBackground

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 0

                            Repeater {
                                model: root.columns
                                delegate: Text {
                                    width: tableView.columnWidthProvider(index)
                                    text: modelData.title
                                    color: Theme.headerText
                                    font.pixelSize: 14
                                    font.bold: true
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
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

                        columnWidthProvider: function (column) { return root.columns[column].width; }
                        rowHeightProvider: function (row) { return 40; }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            implicitWidth: root.columns[column].width
                            implicitHeight: 40
                            color: tableView.activeRow === row ? Theme.rowActive
                                                               : (row % 2 === 0 ? Theme.rowEven : Theme.rowOdd)
                            border.width: mouseArea.containsMouse ? 1 : 0
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
                                color: Theme.text
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
                        text: deviceModel && deviceModel.statusMessage.length > 0
                              ? deviceModel.statusMessage
                              : (deviceModel && deviceModel.state === DeviceModel.Pending
                                 ? "Loading devices..."
                                 : "Failed to load devices")
                        color: Theme.text
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
                                    handler: function () { console.log(device.name, device.version); }
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
                    handler: function () { console.log(device.name, device.version); }
                }
            ];

            openAt(point.x, point.y);
        }
    }
}
