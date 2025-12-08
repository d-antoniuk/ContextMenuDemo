import QtQuick
import QtQuick.Controls
import ContextMenu

Item {
    id: root
    width: parent ? parent.width : 180
    height: Theme.itemHeight

    property string label: ""
    property string itemId: ""
    property var children: []
    property bool hasSubmenu: children && children.length > 0

    signal triggered(string id)
    signal requestOpenSubmenu(Item refItem)

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 4
        color: hoverArea.containsMouse ? Theme.hover : Theme.background
    }

    Text {
        text: root.label
        color: Theme.text
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    Text {
        text: "›"
        visible: root.hasSubmenu
        color: Theme.text
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
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
