import QtQuick
import QtQuick.Controls
import QtQml
import ContextMenu

Popup {
    id: menu
    width: 232
    modal: true
    focus: true
    padding: 6

    property var menuData: []

    signal itemTriggered(var entry)
    signal submenuRequested(var entry, Item refItem)

    function smartPlace(preferredX, preferredY, anchorRect) {
        const popupSize = __popupSize();
        const margin = Theme.padding;

        let x = preferredX;
        let y = preferredY;

        if (menu.parent) {
            if (anchorRect) {
                const spaceRight = menu.parent.width - margin - (anchorRect.x + anchorRect.width);
                const spaceLeft = anchorRect.x - margin;
                const fitsRight = spaceRight >= popupSize.width;
                const fitsLeft = spaceLeft >= popupSize.width;

                if (!fitsRight && fitsLeft) {
                    x = anchorRect.x - margin - popupSize.width;
                } else {
                    x = anchorRect.x + anchorRect.width + margin;

                    if (!fitsRight && !fitsLeft) {
                        x = spaceRight >= spaceLeft ? menu.parent.width - margin - popupSize.width : margin;
                    }
                }
            }

            x = Math.min(Math.max(margin, x), Math.max(margin, menu.parent.width - margin - popupSize.width));
            y = Math.min(Math.max(margin, y), Math.max(margin, menu.parent.height - margin - popupSize.height));
        } else {
            console.log("[MenuPopup.smartPlace] no menu.parent available; using preferred coords");
        }

        menu.x = x;
        menu.y = y;
    }

    function __popupSize() {
        return {
            width: menu.width > 0 ? menu.width : menu.implicitWidth,
            height: menu.implicitHeight > 0 ? menu.implicitHeight : menu.height
        }
    }

    function buildMenu() {
        menuContent.data = []

        for (let i = 0; i < menu.menuData.length; i++) {
            let entry = menu.menuData[i]

            if (entry.type === "separator") {
                let component = Qt.createComponent("Separator.qml")
                if (component.status === Component.Ready) {
                    component.createObject(menuContent)
                }
            } else if (entry.type === "item" || entry.type === "submenu") {
                let component = Qt.createComponent("MenuEntry.qml")
                if (component.status === Component.Ready) {
                    let item = component.createObject(menuContent, {
                        label: entry.label,
                        itemId: entry.id ? entry.id : "",
                        children: entry.children || []
                    })

                    item.triggered.connect(() => {
                        menu.itemTriggered(entry)
                    })

                    item.requestOpenSubmenu.connect(function(refItem) {
                        menu.submenuRequested(entry, refItem)
                    })
                }
            }
        }
    }

    background: Rectangle {
        color: Theme.background
        radius: Theme.radius
    }

    contentItem: Column {
        id: menuContent
        spacing: 2
    }
}
