import QtQuick
import QtQuick.Controls
import QtQml
import ContextMenu

MenuPopup {
    id: menu

    property var submenus: []

    onItemTriggered: function(entry) { handleTrigger(entry) }
    onSubmenuRequested: function(entry, refItem) { openSubmenu(entry, refItem, 0) }
    onClosed: closeSubmenusFrom(0)

    function handleTrigger(entry) {
        if (entry.handler)
            entry.handler();
        closeAll();
    }

    function closeAll() {
        closeSubmenusFrom(0);
        menu.close();
    }

    function openAt(posX, posY) {
        menu.buildMenu();
        menu.smartPlace({ preferredX: posX, preferredY: posY });
        menu.open();
    }

    function openSubmenu(entry, refItem, level) {
        closeSubmenusFrom(level);

        const submenu = getSubmenu(level);
        const anchorTopLeft = refItem.mapToItem(null, 0, 0);
        const anchorRect = {
            x: anchorTopLeft.x,
            y: anchorTopLeft.y,
            width: refItem.width,
            height: refItem.height
        };

        submenu.menuData = entry.children;
        submenu.buildMenu();

        const parentPlacement = level === 0 ? menu.lastHorizontalPlacement : submenus[level - 1].lastHorizontalPlacement;
        const preferLeft = parentPlacement === "left";
        const preferredX = preferLeft ? anchorRect.x - Theme.padding - submenu.width : anchorRect.x + anchorRect.width + Theme.padding;
        submenu.smartPlace({
            preferredX: preferredX,
            preferredY: anchorRect.y,
            anchorRect: anchorRect,
            preferLeft: preferLeft
        });
        submenu.open();
    }

    function closeSubmenusFrom(level) {
        for (let i = level; i < submenus.length; i++) {
            if (submenus[i])
                submenus[i].close();
        }
        submenus.length = level;
    }

    function getSubmenu(level) {
        if (!submenus[level]) {
            submenus[level] = submenuComponent.createObject(menu.parent, {
                width: menu.width,
                modal: false,
                focus: true,
                padding: menu.padding
            });

            submenus[level].itemTriggered.connect(handleTrigger);
            submenus[level].submenuRequested.connect(function(entry, refItem) {
                openSubmenu(entry, refItem, level + 1);
            });
            submenus[level].closed.connect(function() {
                closeSubmenusFrom(level);
            });
        }
        return submenus[level];
    }

    Component {
        id: submenuComponent
        MenuPopup { }
    }
}
