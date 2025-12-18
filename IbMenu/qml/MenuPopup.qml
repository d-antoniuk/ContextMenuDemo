import QtQuick
import QtQuick.Controls
import QtQml

Popup {
    id: menu
    width: implicitWidth
    modal: true
    focus: true
    topPadding: Theme.menuPaddingVertical
    bottomPadding: Theme.menuPaddingVertical
    leftPadding: Theme.menuPaddingHorizontal
    rightPadding: Theme.menuPaddingHorizontal

    implicitWidth: Math.max(232, menuContent.implicitWidth + leftPadding + rightPadding)

    property var menuData: []
    property string lastHorizontalPlacement: "right"
    property string lastVerticalPlacement: "down"

    signal itemTriggered(var entry)
    signal submenuRequested(var entry, Item refItem)

    function smartPlace(params) {
        const opts = params || {};
        const popupSize = __popupSize();
        const margin = Theme.padding;
        const preferredX = opts.preferredX !== undefined ? opts.preferredX : menu.x;
        const preferredY = opts.preferredY !== undefined ? opts.preferredY : menu.y;
        const anchorRect = opts.anchorRect;
        const preferLeft = opts.preferLeft === true;

        let x = preferredX;
        let y = preferredY;
        let horizontal = "right";
        let vertical = "down";

        if (anchorRect) {
            const horiz = __placeHorizontal(anchorRect, popupSize, margin, preferLeft);
            horizontal = horiz.side;
            x = horiz.pos;

            const vert = __placeVertical(anchorRect, popupSize, margin);
            vertical = vert.side;
            y = vert.pos;

            const clamp = __clampToParent(x, y, popupSize, Theme.padding);
            x = clamp.x;
            y = clamp.y;
        } else {
            const clamp = __clampToParent(preferredX, preferredY, popupSize, margin);
            x = clamp.x;
            y = clamp.y;
            horizontal = clamp.x >= preferredX ? "right" : "left";
            vertical = clamp.y >= preferredY ? "down" : "up";
        }

        menu.x = x;
        menu.y = y;
        menu.lastHorizontalPlacement = horizontal;
        menu.lastVerticalPlacement = vertical;
        return {
            x,
            y,
            horizontal,
            vertical
        };
    }

    function __placeHorizontal(anchorRect, popupSize, margin, preferLeft) {
        const spaceRight = menu.parent.width - margin - (anchorRect.x + anchorRect.width);
        const spaceLeft = anchorRect.x - margin;
        const fitsRight = spaceRight >= popupSize.width;
        const fitsLeft = spaceLeft >= popupSize.width;

        if (preferLeft && fitsLeft)
            return {
                side: "left",
                pos: anchorRect.x - margin - popupSize.width
            };
        if (!preferLeft && fitsRight)
            return {
                side: "right",
                pos: anchorRect.x + anchorRect.width + margin
            };
        if (fitsLeft)
            return {
                side: "left",
                pos: anchorRect.x - margin - popupSize.width
            };
        if (fitsRight)
            return {
                side: "right",
                pos: anchorRect.x + anchorRect.width + margin
            };

        const chooseRight = spaceRight >= spaceLeft;
        return {
            side: chooseRight ? "right" : "left",
            pos: chooseRight ? menu.parent.width - margin - popupSize.width : margin
        };
    }

    function __placeVertical(anchorRect, popupSize, margin) {
        const spaceBelow = menu.parent.height - margin - (anchorRect.y + anchorRect.height);
        const spaceAbove = anchorRect.y - margin;
        const fitsBelow = spaceBelow >= popupSize.height;
        const fitsAbove = spaceAbove >= popupSize.height;

        if (fitsBelow)
            return {
                side: "down",
                pos: anchorRect.y
            };
        if (fitsAbove)
            return {
                side: "up",
                pos: anchorRect.y + anchorRect.height - popupSize.height
            };

        const chooseDown = spaceBelow >= spaceAbove;
        return {
            side: chooseDown ? "down" : "up",
            pos: chooseDown ? menu.parent.height - margin - popupSize.height : margin
        };
    }

    function __clampToParent(x, y, popupSize, margin) {
        const clampedX = Math.min(Math.max(margin, x), Math.max(margin, menu.parent.width - margin - popupSize.width));
        const clampedY = Math.min(Math.max(margin, y), Math.max(margin, menu.parent.height - margin - popupSize.height));
        return {
            x: clampedX,
            y: clampedY
        };
    }

    function __popupSize() {
        return {
            width: menu.width > 0 ? menu.width : menu.implicitWidth,
            height: menu.implicitHeight > 0 ? menu.implicitHeight : menu.height
        };
    }

    Component {
        id: separatorComponent
        Separator {}
    }
    Component {
        id: entryComponent
        MenuEntry {}
    }

    function buildMenu() {
        menuContent.data = [];
        menu.menuData.forEach(function (entry) {
            if (entry.type === "separator") {
                separatorComponent.createObject(menuContent);
                return;
            }
            if (entry.type !== "item" && entry.type !== "submenu")
                return;

            const item = entryComponent.createObject(menuContent, {
                label: entry.label,
                itemId: entry.id || "",
                children: entry.children || [],
                shortcut: entry.shortcut || "",
                checkable: entry.checkable === true || entry.checked !== undefined,
                checked: entry.checked === true
            });
            item.triggered.connect(() => menu.itemTriggered(entry));
            item.requestOpenSubmenu.connect(refItem => menu.submenuRequested(entry, refItem));
        });
    }

    background: Rectangle {
        id: bg
        radius: Theme.radius
        color: Theme.menuBackground
        antialiasing: true
        clip: true
    }

    contentItem: Column {
        id: menuContent
        spacing: 0
        width: menu.availableWidth
    }
}
