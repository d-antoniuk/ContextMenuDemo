import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: parent ? parent.width : 180
    height: 28

    signal triggered(string id)

    property string label: ""
    property string itemId: ""

    Rectangle {
        anchors.fill: parent
        color: controlArea.containsMouse ? "#3a3a3a" : "#2b2b2b"
        radius: 4
    }

    Text {
        text: root.label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: "white"
        font.pixelSize: 14
    }

    MouseArea {
        id: controlArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.triggered(root.itemId)
    }
}

