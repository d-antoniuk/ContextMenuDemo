import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ContextMenu

Item {
    id: root
    width: parent ? parent.width : 180
    height: Theme.itemHeight

    property string label: ""
    property string itemId: ""
    property var children: []
    property bool hasSubmenu: children && children.length > 0
    property string shortcut: ""

    signal triggered(string id)
    signal requestOpenSubmenu(Item refItem)

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 4
        color: hoverArea.containsMouse ? Theme.menuHoverBackground : Theme.menuBackground
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Text {
            id: labelText
            text: root.label
            color: Theme.menuText
            font.pixelSize: Theme.fontSize
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: shortcutText
            text: root.shortcut
            visible: root.shortcut !== ""
            color: Theme.menuShortcutText
            opacity: 0.8
            font.pixelSize: Theme.fontSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: visible ? implicitWidth : 0
        }

        Text {
            id: arrow
            text: "›"
            visible: root.hasSubmenu
            color: Theme.menuText
            font.pixelSize: Theme.fontSize
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: visible ? implicitWidth : 0
        }
    }

    Timer {
        id: hoverTimer
        interval: 100
        repeat: false
        onTriggered: {
            if (hoverArea.containsMouse && root.hasSubmenu)
                root.requestOpenSubmenu(root)
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (root.hasSubmenu)
                hoverTimer.start()
        }

        onExited: hoverTimer.stop()

        onClicked: {
            if (root.hasSubmenu)
                root.requestOpenSubmenu(root)
            else
                root.triggered(root.itemId)
        }
    }
}
