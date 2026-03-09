import QtQuick
import "../../services"

Item {
    id: root

    signal clicked

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

        Column {
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: 3
                Rectangle {
                    width: 14
                    height: 2
                    radius: 1
                    color: Theme.text
                }
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
