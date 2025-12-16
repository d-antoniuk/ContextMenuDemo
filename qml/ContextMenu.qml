import QtQuick
import QtQuick.Controls
import QtQml
import ContextMenu

MenuPopup {
    id: menu

    property var submenus: []
    property var checkedItems: ({})

    onItemTriggered: function (entry) {
        handleTrigger(entry);
    }
    onSubmenuRequested: function (entry, refItem) {
        openSubmenu(entry, refItem, 0);
    }
    onClosed: closeSubmenusFrom(0)

    function handleTrigger(entry) {
        toggleChecked(entry);

        if (entry.handler)
            entry.handler();
        closeAll();
    }

    function closeAll() {
        closeSubmenusFrom(0);
        menu.close();
    }

    function openAt(posX, posY) {
        applyCheckState(menu.menuData);
        menu.buildMenu();
        menu.smartPlace({
            preferredX: posX,
            preferredY: posY
        });
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

        applyCheckState(entry.children);
        submenu.menuData = entry.children;
        submenu.buildMenu();

        const parentPlacement = level === 0 ? menu.lastHorizontalPlacement : submenus[level - 1].lastHorizontalPlacement;
        const preferLeft = parentPlacement === "left";
        const preferredX = preferLeft ? anchorRect.x - submenu.width : anchorRect.x + anchorRect.width;
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
                modal: false,
                focus: true
            });

            submenus[level].itemTriggered.connect(handleTrigger);
            submenus[level].submenuRequested.connect(function (entry, refItem) {
                openSubmenu(entry, refItem, level + 1);
            });
            submenus[level].closed.connect(function () {
                closeSubmenusFrom(level);
            });
        }
        return submenus[level];
    }

    Component {
        id: submenuComponent
        MenuPopup {}
    }

    function toggleChecked(entry) {
        if (!entry || !entry.id)
            return;
        entry.checked = !checkedItems[entry.id];
        checkedItems[entry.id] = entry.checked;
    }

    function applyCheckState(list) {
        if (!list || !list.length)
            return;

        list.forEach(function (entry) {
            if (!entry)
                return;

            entry.checkable = entry.checkable === true;
            if (entry.checkable && entry.id) {
                const saved = checkedItems[entry.id];
                entry.checked = saved === undefined ? entry.checked === true : saved;
                if (saved === undefined)
                    checkedItems[entry.id] = entry.checked;
            }
            if (entry.children && entry.children.length)
                applyCheckState(entry.children);
        });
    }
}
