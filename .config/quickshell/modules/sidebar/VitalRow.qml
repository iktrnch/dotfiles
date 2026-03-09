import QtQuick
import "../../services"

// A single horizontal row: label | progress bar | value text
Item {
    id: root

    property string label: ""
    property string valueText: ""
    property real progress: 0   // 0.0 – 1.0
    property color barColor: Theme.mauve

    implicitWidth: parent?.width ?? 200
    implicitHeight: 20

    // Label
    Text {
        id: labelText
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        text: root.label
        color: Theme.subtext0
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        width: 32
    }

    // Track
    Rectangle {
        id: track
        anchors {
            left: labelText.right
            leftMargin: 8
            right: valueLabel.left
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }
        height: 4
        radius: 2
        color: Theme.surface1

        // Fill
        Rectangle {
            id: fill
            width: Math.max(track.radius * 2, track.width * Math.max(0, Math.min(1, root.progress)))
            height: parent.height
            radius: parent.radius
            color: root.barColor

            Behavior on width {
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
        }
    }

    // Value text
    Text {
        id: valueLabel
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        text: root.valueText
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        font.weight: Font.Medium
        width: 90
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }
}
