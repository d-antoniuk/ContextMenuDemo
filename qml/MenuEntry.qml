import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ContextMenu

Item {
    id: root
    width: parent ? parent.width : implicitWidth
    implicitWidth: rowLayout.implicitWidth + rowLayout.anchors.leftMargin + rowLayout.anchors.rightMargin
    height: Theme.itemHeight

    property string label: ""
    property string itemId: ""
    property var children: []
    property bool hasSubmenu: children && children.length > 0
    property string shortcut: ""
    property bool checkable: false
    property bool checked: false
    property bool highlighted: hoverArea.containsMouse && hoverArea.enabled

    signal triggered(string id)
    signal requestOpenSubmenu(Item refItem)

    Rectangle {
        id: bg
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        radius: Theme.itemRadius
        color: (hoverArea.containsMouse && hoverArea.enabled) ? Theme.menuHoverBackground : Theme.menuBackground
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        spacing: 8

        Text {
            id: checkmark
            text: root.checked ? "\u2713" : ""
            opacity: root.checkable ? 1 : 0
            color: Theme.menuText
            font.family: "Inter"
            font.pixelSize: Theme.menuFontSize
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: Theme.menuFontSize
        }

        Text {
            id: labelText
            text: root.label
            color: Theme.menuText
            font.family: "Inter"
            font.pixelSize: Theme.menuFontSize
            font.weight: Font.Normal
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: shortcutText
            text: root.shortcut
            visible: root.shortcut !== ""
            color: root.highlighted ? Theme.menuText : Theme.menuTextSecondary
            opacity: 1
            font.family: "Inter"
            font.pixelSize: Theme.menuShortcutFontSize
            font.weight: Font.Normal
            font.letterSpacing: Theme.menuShortcutFontSize * 0.02
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: visible ? implicitWidth : 0
        }

        Text {
            id: arrow
            text: "›"
            visible: root.hasSubmenu
            color: root.highlighted ? Theme.menuText : Theme.menuTextSecondary
            font.family: "Inter"
            font.pixelSize: Theme.menuFontSize
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: visible ? implicitWidth : 0
        }
    }

    Timer {
        id: hoverTimer
        interval: 150
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
        cursorShape: Qt.ArrowCursor
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
