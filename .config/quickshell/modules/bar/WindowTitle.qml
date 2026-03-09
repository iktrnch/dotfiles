import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../services"

Item {
    id: root

    implicitWidth: Math.min(titleText.implicitWidth + Theme.barPadding * 2, 400)
    implicitHeight: Theme.barHeight

    readonly property string title: Hyprland.focusedMonitor?.activeWindow?.title ?? ""

    Text {
        id: titleText
        anchors.centerIn: parent
        width: Math.min(implicitWidth, parent.width - Theme.barPadding * 2)
        text: root.title
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeNormal
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter

        Behavior on text {
            SequentialAnimation {
                NumberAnimation {
                    target: titleText
                    property: "opacity"
                    to: 0
                    duration: 80
                    easing.type: Easing.InQuad
                }
                PropertyAction {
                    target: titleText
                    property: "text"
                }
                NumberAnimation {
                    target: titleText
                    property: "opacity"
                    to: 1
                    duration: 80
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}
