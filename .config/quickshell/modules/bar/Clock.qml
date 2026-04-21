import QtQuick
import Quickshell
import "../../services"

Item {
    id: root

    implicitWidth: timeText.implicitWidth + Theme.barPadding * 2
    implicitHeight: Theme.barHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeNormal
        font.weight: Font.Medium
    }
}
