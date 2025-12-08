import QtQuick
import QtQuick.Controls
import QtQml
import ContextMenu

MenuPopup {
    id: menu

    onItemTriggered: function (entry) {
        if (entry.handler)
            entry.handler();
        menu.close();
    }

    onSubmenuRequested: function (entry, refItem) {
        openSubmenu(entry, refItem);
    }

    function openSubmenu(entry, refItem) {
        if (submenu.visible)
            submenu.close();

        const globalPos = refItem.mapToItem(null, refItem.width, 0);

        submenu.menuData = entry.children;
        submenu.buildMenu();

        submenu.x = globalPos.x + Theme.padding;
        submenu.y = globalPos.y;

        submenu.open();
    }

    MenuPopup {
        id: submenu
        parent: menu.parent
        width: menu.width
        modal: false
        focus: true
        padding: menu.padding

        onItemTriggered: function (entry) {
            if (entry.handler)
                entry.handler();
            submenu.close();
            menu.close();
        }

        onSubmenuRequested: function (entry, refItem) {
            openSubmenu(entry, refItem);
        }
    }
}
