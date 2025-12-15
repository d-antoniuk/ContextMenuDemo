pragma Singleton
import QtQuick

QtObject {
    // Colors
    property color background: "#1e1e1e"
    property color hover: "#0d99ff"
    property color text: "#ffffff"
    property color separator: "#383838"
    property color shortcutText: "#9b9b9b"
    property color windowBackground: background
    property color panelBackground: background
    property color panelBorder: separator
    property color headerBackground: background
    property color headerText: text
    property color rowActive: hover
    property color rowEven: background
    property color rowOdd: background
    property color rowBorder: hover

    // Metrics
    property int radius: 8
    property int itemHeight: 28
    property int fontSize: 14
    property int padding: 8
}
