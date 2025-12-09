import QtQuick
import QtQuick.Controls
import QtQml
import ContextMenu

MenuPopup {
    id: menu

    property var submenus: []

    onItemTriggered: handleTrigger
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

    function openSubmenu(entry, refItem, level) {
        closeSubmenusFrom(level);

        const submenu = getSubmenu(level);
        const globalPos = refItem.mapToItem(null, refItem.width, 0);

        submenu.menuData = entry.children;
        submenu.buildMenu();

        submenu.x = globalPos.x + Theme.padding;
        submenu.y = globalPos.y;
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
