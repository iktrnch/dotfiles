pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../services"

Item {
    id: root

    readonly property int btnSize: 22
    readonly property int btnSpacing: 4

    implicitWidth: row.implicitWidth + Theme.barPadding * 2
    implicitHeight: Theme.barHeight

    function isOccupied(id) {
        if (!Hyprland.workspaces)
            return false;
        for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
            if (Hyprland.workspaces.values[i].id === id)
                return true;
        }
        return false;
    }

    function isActive(id) {
        return Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === id;
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.btnSpacing

        Repeater {
            model: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

            delegate: Item {
                id: btn
                required property int modelData

                readonly property bool active: root.isActive(modelData)
                readonly property bool occupied: {
                    if (Hyprland.workspaces) {
                        var _t = Hyprland.workspaces.values;
                    }
                    return root.isOccupied(modelData);
                }
                readonly property bool hovered: hoverArea.containsMouse

                width: root.btnSize
                height: root.btnSize

                Rectangle {
                    id: dot
                    anchors.centerIn: parent

                    readonly property real targetSize: btn.active ? 18 : btn.occupied ? 8 : 5
                    readonly property color idleColor: btn.active ? Theme.mauve : btn.occupied ? Theme.subtext0 : Theme.surface1

                    width: targetSize
                    height: targetSize
                    radius: btn.active ? Theme.radiusSmall : width / 2

                    color: btn.hovered && !btn.active ? Theme.overlay1 : idleColor

                    Behavior on width {
                        NumberAnimation {
                            duration: Theme.animDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: Theme.animDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on radius {
                        NumberAnimation {
                            duration: Theme.animDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animDuration
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: btn.active
                        text: btn.modelData.toString()
                        color: Theme.crust
                        font.family: Theme.fontFamily
                        font.pixelSize: 10
                        font.weight: Font.Bold
                    }
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + btn.modelData)
                }
            }
        }
    }
}
