import QtQuick

Item {
    height: 9
    width: parent ? parent.width : 0

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 12
            rightMargin: 12
            verticalCenter: parent.verticalCenter
        }
        height: 1
        color: Theme.menuSeparator
    }
}
