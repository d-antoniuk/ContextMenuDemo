import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: parent ? parent.width : 180
    height: Theme.itemHeight

    signal triggered(string id)

    property string label: ""
    property string itemId: ""

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 4
        color: controlArea.containsMouse ? Theme.hover : Theme.background
    }

    Text {
        text: root.label
        color: Theme.text
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    MouseArea {
        id: controlArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.triggered(root.itemId)
    }
}

