pragma Singleton
import QtQuick

QtObject {
    // Base palette
    property color surfacePrimary: "#1e1e1e"
    property color accentPrimary: "#0d99ff"
    property color textPrimary: "#ffffff"
    property color textMuted: "#9b9b9b"
    property color borderSubtle: "#383838"

    // Semantic roles
    property color windowBackground: surfacePrimary
    property color panelBackground: surfacePrimary
    property color tableBorder: textPrimary
    property color panelBorder: tableBorder
    property color headerBackground: surfacePrimary
    property color headerText: textPrimary
    property color menuBackground: surfacePrimary
    property color menuHoverBackground: accentPrimary
    property color menuText: textPrimary
    property color menuShortcutText: textMuted
    property color menuSeparator: borderSubtle
    property color rowActiveBackground: accentPrimary
    property color rowEvenBackground: surfacePrimary
    property color rowOddBackground: surfacePrimary
    property color rowBorder: tableBorder

    // Metrics
    property int radius: 8
    property int itemHeight: 28
    property int fontSize: 14
    property int padding: 8
}
