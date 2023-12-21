// SPDX-FileCopyrightText: 2023 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.4
import QtQuick.Window 2.15
import QtQml
import Qt.labs.platform as LP

import org.deepin.ds 1.0
import org.deepin.ds.dock 1.0
import org.deepin.dtk 1.0 as D

Window {
    id: dock
    visible: true
    property bool useColumnLayout: Applet.position % 2

    width: Applet.dockSize
    height: Applet.dockSize

    D.DWindow.enabled: true
    DLayerShellWindow.anchors: position2Anchors(Applet.position)
    DLayerShellWindow.layer: DLayerShellWindow.LayerTop
    DLayerShellWindow.exclusionZone: Applet.dockSize
    DLayerShellWindow.leftMargin: (useColumnLayout || Applet.displayMode === Dock.Efficient) ? 0 : (Screen.width - contentLoader.implicitWidth) / 2
    DLayerShellWindow.rightMargin: (useColumnLayout || Applet.displayMode === Dock.Efficient) ? 0 : (Screen.width - contentLoader.implicitWidth) / 2
    DLayerShellWindow.topMargin: (!useColumnLayout || Applet.displayMode === Dock.Efficient) ? 0 : (Screen.height - contentLoader.implicitHeight) / 2
    DLayerShellWindow.bottomMargin: (!useColumnLayout || Applet.displayMode === Dock.Efficient) ? 0 : (Screen.height - contentLoader.implicitHeight) / 2

    component EnumPropertyMenuItem: LP.MenuItem {
        required property string name
        required property string prop
        required property int value
        text: name
        onTriggered: {
            Applet[prop] = value
            checked = true
        }
        checked: Applet[prop] === value
    }
    component MutuallyExclusiveMenu: LP.Menu {
        id: menu
        LP.MenuItemGroup {
            id: group
            items: menu.items
        }
    }

    LP.Menu {
        id: dockMenu
        MutuallyExclusiveMenu {
            title: qsTr("Mode")
            EnumPropertyMenuItem {
                name: qsTr("Fashion Mode")
                prop: "displayMode"
                value: Dock.Fashion
            }
            EnumPropertyMenuItem {
                name: qsTr("Efficient Mode")
                prop: "displayMode"
                value: Dock.Efficient
            }
        }
        MutuallyExclusiveMenu {
            title: qsTr("Position")
            EnumPropertyMenuItem {
                name: qsTr("Top")
                prop: "position"
                value: Dock.Top
            }
            EnumPropertyMenuItem {
                name: qsTr("Bottom")
                prop: "position"
                value: Dock.Bottom
            }
            EnumPropertyMenuItem {
                name: qsTr("Left")
                prop: "position"
                value: Dock.Left
            }
            EnumPropertyMenuItem {
                name: qsTr("Right")
                prop: "position"
                value: Dock.Right
            }
        }
        MutuallyExclusiveMenu {
            title: qsTr("Status")
            EnumPropertyMenuItem {
                name: qsTr("Keep Shown")
                prop: "hideMode"
                value: Dock.KeepShowing
            }
            EnumPropertyMenuItem {
                name: qsTr("Keep Hidden")
                prop: "hideMode"
                value: Dock.KeepHidden
            }
            EnumPropertyMenuItem {
                name: qsTr("Smart Hide")
                prop: "hideMode"
                value: Dock.SmartHide
            }
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        gesturePolicy: TapHandler.WithinBounds
        onTapped: function(eventPoint, button) {
            let lastActive = MenuHelper.activeMenu
            MenuHelper.closeCurrent()
            if (button === Qt.RightButton && lastActive !== dockMenu) {
                MenuHelper.openMenu(dockMenu)
            }
        }
    }

    OverflowContainer {
        id: contentLoader
        anchors.fill: parent
        useColumnLayout: dock.useColumnLayout
        model: Applet.appletItems
        delegate: Control {
            contentItem: model.modelData
            Component.onCompleted: {
                contentItem.parent = this
            }
        }
    }

    function position2Anchors(position) {
        switch (position) {
        case Dock.Top:
            return DLayerShellWindow.AnchorLeft | DLayerShellWindow.AnchorRight | DLayerShellWindow.AnchorTop
        case Dock.Right:
            return DLayerShellWindow.AnchorTop | DLayerShellWindow.AnchorBottom | DLayerShellWindow.AnchorRight
        case Dock.Bottom:
            return DLayerShellWindow.AnchorLeft | DLayerShellWindow.AnchorRight | DLayerShellWindow.AnchorBottom
        case Dock.Left:
            return DLayerShellWindow.AnchorTop | DLayerShellWindow.AnchorBottom | DLayerShellWindow.AnchorLeft
        }
    }
}
