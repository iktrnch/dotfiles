pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../../services"

Item {
    id: root

    implicitWidth: trayRow.implicitWidth + Theme.barPadding * 2
    implicitHeight: Theme.barHeight

    // Single shared menu anchor — we set .menu before calling .open()
    QsMenuAnchor {
        id: sharedMenuAnchor
        anchor {
            gravity: Edges.Bottom | Edges.Right
            edges: Edges.Bottom | Edges.Right
        }
    }

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItem
                required property SystemTrayItem modelData

                width: 22
                height: 22

                readonly property bool itemHovered: itemMouse.containsMouse
                readonly property string tipText: modelData.tooltipTitle !== "" ? modelData.tooltipTitle : modelData.title

                // Hover background
                Rectangle {
                    anchors.fill: parent
                    radius: Theme.radiusSmall
                    color: trayItem.itemHovered ? Theme.surface0 : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animDuration
                        }
                    }
                }

                // Icon
                Image {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    source: {
                        var icon = trayItem.modelData.icon;
                        if (!icon || icon === "")
                            return "image://icon/system-run";
                        if (icon.startsWith("/"))
                            return "file://" + icon;
                        if (icon.startsWith("file://") || icon.startsWith("image://"))
                            return icon;
                        return "image://icon/" + icon;
                    }

                    onStatusChanged: {
                        if (status === Image.Error)
                            source = "image://icon/system-run";
                    }
                }

                // Tooltip
                Rectangle {
                    id: tipRect
                    visible: trayItem.itemHovered && tipTimer.triggered_
                    z: 999
                    anchors.top: parent.bottom
                    anchors.topMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: tipLabel.implicitWidth + 12
                    height: tipLabel.implicitHeight + 8
                    radius: Theme.radiusSmall
                    color: Theme.mantle
                    border.color: Theme.surface1
                    border.width: 1

                    Text {
                        id: tipLabel
                        anchors.centerIn: parent
                        text: trayItem.tipText
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

                Timer {
                    id: tipTimer
                    property bool triggered_: false
                    interval: 600
                    repeat: false
                    running: trayItem.itemHovered && trayItem.tipText !== ""
                    onTriggered: triggered_ = true
                    onRunningChanged: if (!running)
                        triggered_ = false
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        if (trayItem.modelData.menu) {
                            // Point the shared anchor at this item and open
                            sharedMenuAnchor.anchor.item = trayItem;
                            sharedMenuAnchor.menu = trayItem.modelData.menu;
                            sharedMenuAnchor.open();
                        } else {
                            trayItem.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
