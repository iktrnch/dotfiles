pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../../services"

Item {
    id: root

    implicitWidth: row.implicitWidth + Theme.barPadding * 2
    implicitHeight: Theme.barHeight

    readonly property bool hovered: mouseArea.containsMouse

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: AudioService.muted ? "\uf6a9" : AudioService.volumePct >= 66 ? "\udb81\udd7e" : AudioService.volumePct >= 33 ? "\udb81\udd7d" : "\udb81\udd7c"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeIcon
            color: AudioService.muted ? Theme.overlay0 : Theme.mauve
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: AudioService.volumeLabel
            color: AudioService.muted ? Theme.overlay0 : Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.weight: Font.Medium
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                AudioService.toggleMute();
            } else {
                Quickshell.execDetached(["pavucontrol"]);
            }
        }

        onWheel: wheel => {
            AudioService.adjustVolume(wheel.angleDelta.y > 0 ? 0.05 : -0.05);
        }
    }
}
