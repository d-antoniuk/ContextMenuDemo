pragma Singleton
import QtQuick

QtObject {
    property color surfacePrimary: "#F1F4F9"
    property color surfaceSecondary: "#FFFFFF"
    property color accentPrimary: "#0D99FF"
    property color textPrimary: "#0F172A"

    // Semantic roles
    property color windowBackground: surfacePrimary
    property color panelBackground: surfaceSecondary
    property color tableBorder: "#D4D9E2"
    property color headerBackground: "#EEF2F8"
    property color headerText: textPrimary
    property color menuBackground: "#1E1E1E"
    property color menuHoverBackground: accentPrimary
    property color menuText: "#EDEDED"
    property color menuTextSecondary: "#9A9A9A"
    property color menuSeparator: "#2F2F2F"
    property color rowActiveBackground: "#E6F2FF"
    property color rowEvenBackground: surfaceSecondary
    property color rowOddBackground: "#F7F9FD"
    property color rowBorder: tableBorder

    // Metrics
    property int radius: 8
    property int itemRadius: 6
    property int itemHeight: 28
    property int fontSize: 14
    property int menuFontSize: 13
    property int menuShortcutFontSize: 12
    property int padding: 2
    property int menuPaddingVertical: 4
    property int menuPaddingHorizontal: 0
}
