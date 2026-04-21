import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../services"

PanelWindow {
    id: root

    required property var screen

    signal sidebarToggleRequested

    screen: root.screen

    anchors {
        top: true
        left: true
        right: true
    }

    // Height = pill height + top margin so the pill floats inside
    implicitHeight: Theme.barHeight + Theme.barMargin
    exclusiveZone: Theme.barHeight + Theme.barMargin
    color: "transparent"

    WlrLayershell.namespace: "quickshell:bar"
    WlrLayershell.layer: WlrLayer.Top

    Bar {
        anchors.fill: parent
        onSidebarToggleRequested: root.sidebarToggleRequested()
    }
}
