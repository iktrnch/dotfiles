import QtQuick
import "../../services"

Item {
    id: root

    implicitWidth: 36
    implicitHeight: Theme.barHeight

    readonly property bool hovered: hoverArea.containsMouse

    Rectangle {
        anchors.centerIn: parent
        width: 26
        height: 26
        radius: Theme.radiusSmall
        color: root.hovered ? Theme.surface0 : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Theme.animDuration
            }
        }

        Text {
            anchors.centerIn: parent
            // nf-linux-archlinux
            text: "\uf303"
            font.family: Theme.fontFamily
            font.pixelSize: 18
            color: Theme.blue
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
