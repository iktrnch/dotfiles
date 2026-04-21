import QtQuick
import "../../services"

Item {
    id: root

    signal clicked

    property string label: ""
    property string icon: ""
    property color iconColor: Theme.text

    // Grow to fill equal share of parent Row width (3 buttons, 2 gaps of 8px)
    implicitWidth: (parent.width - 16) / 3
    implicitHeight: 40

    readonly property bool hovered: area.containsMouse

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: root.hovered ? Qt.rgba(root.iconColor.r, root.iconColor.g, root.iconColor.b, 0.18) : Theme.surface0

        Behavior on color {
            ColorAnimation {
                duration: Theme.animDuration
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 3

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.icon
                font.family: Theme.fontFamily
                font.pixelSize: 16
                color: root.iconColor
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: root.hovered ? Theme.text : Theme.subtext0

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animDuration
                    }
                }
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
