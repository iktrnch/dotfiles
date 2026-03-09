pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import "../../services"

PanelWindow {
    id: root

    required property var screen

    property bool isOpen: false

    function open() {
        visible = true;
        isOpen = true;
    }

    function close() {
        isOpen = false;
    }

    function toggle() {
        if (isOpen)
            close();
        else
            open();
    }

    screen: root.screen

    anchors {
        top: true
        right: true
    }

    margins {
        top: Theme.barHeight + 4
        right: 4
    }

    implicitWidth: 264
    implicitHeight: panel.implicitHeight
    color: "transparent"
    exclusiveZone: -1

    WlrLayershell.namespace: "quickshell:volume-popup"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region {
        item: panel
    }

    // Hide layer window after slide-out animation
    onIsOpenChanged: {
        if (!isOpen)
            hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: Theme.animDuration + 20
        repeat: false
        onTriggered: {
            if (!root.isOpen)
                root.visible = false;
        }
    }

    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: root.close()
    }

    Rectangle {
        id: panel

        readonly property real targetY: root.isOpen ? 0 : -(implicitHeight + 16)

        y: targetY
        width: root.implicitWidth
        implicitHeight: popupColumn.implicitHeight + 20

        radius: Theme.radius
        color: Theme.mantle
        border.color: Theme.surface1
        border.width: 1

        Behavior on y {
            NumberAnimation {
                duration: Theme.animDuration
                easing.type: Easing.OutCubic
            }
        }

        Column {
            id: popupColumn
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10
            }
            spacing: 0

            // ── Header ────────────────────────────────────────────────────
            Text {
                text: "Audio Output"
                color: Theme.subtext0
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Bold
                topPadding: 4
                bottomPadding: 6
            }

            // ── Volume slider ─────────────────────────────────────────────
            Item {
                width: parent.width
                height: 28

                Text {
                    id: sliderIcon
                    anchors.verticalCenter: parent.verticalCenter
                    // nf-md-volume_high
                    text: "\udb81\udd7e"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.mauve
                    width: 18
                }

                Rectangle {
                    id: sliderTrack
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: sliderIcon.right
                    anchors.leftMargin: 6
                    anchors.right: sliderPctLabel.left
                    anchors.rightMargin: 6
                    height: 4
                    radius: 2
                    color: Theme.surface1

                    Rectangle {
                        width: parent.width * Math.min(1, AudioService.volume)
                        height: parent.height
                        radius: parent.radius
                        color: Theme.mauve

                        Behavior on width {
                            NumberAnimation {
                                duration: 80
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mouse => {
                            AudioService.setVolume(mouse.x / parent.width);
                        }
                        onPositionChanged: mouse => {
                            if (mouse.buttons & Qt.LeftButton)
                                AudioService.setVolume(Math.max(0, Math.min(1, mouse.x / parent.width)));
                        }
                    }
                }

                Text {
                    id: sliderPctLabel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    text: AudioService.volumePct + "%"
                    color: Theme.subtext0
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    width: 36
                    horizontalAlignment: Text.AlignRight
                }
            }

            // ── Separator ─────────────────────────────────────────────────
            Item {
                width: parent.width
                height: 9
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Theme.surface0
                }
            }

            // ── Sink list ─────────────────────────────────────────────────
            Repeater {
                model: Pipewire.nodes

                delegate: Item {
                    id: sinkItem
                    required property var modelData

                    visible: modelData.isAudioSink
                    height: visible ? 30 : 0
                    width: parent.width

                    readonly property bool isDefault: Pipewire.defaultAudioSink === modelData
                    readonly property bool itemHovered: sinkMouse.containsMouse

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.radiusSmall
                        color: sinkItem.isDefault ? Qt.rgba(Theme.mauve.r, Theme.mauve.g, Theme.mauve.b, 0.15) : sinkItem.itemHovered ? Theme.surface0 : "transparent"

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 6

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: sinkItem.isDefault ? "\uf111" : "\uf1db"
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                            color: sinkItem.isDefault ? Theme.mauve : Theme.overlay0
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 20
                            text: (sinkItem.modelData.description ?? "") !== "" ? sinkItem.modelData.description : (sinkItem.modelData.name ?? "Unknown Device")
                            color: sinkItem.isDefault ? Theme.text : Theme.subtext0
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: sinkItem.isDefault ? Font.Medium : Font.Normal
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        id: sinkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Pipewire.preferredDefaultAudioSink = sinkItem.modelData
                    }
                }
            }

            // ── Separator ─────────────────────────────────────────────────
            Item {
                width: parent.width
                height: 9
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Theme.surface0
                }
            }

            // ── Open pavucontrol ──────────────────────────────────────────
            Item {
                id: pavuRow
                width: parent.width
                height: 30

                readonly property bool rowHovered: pavuMouse.containsMouse

                Rectangle {
                    anchors.fill: parent
                    radius: Theme.radiusSmall
                    color: pavuRow.rowHovered ? Theme.surface0 : "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    spacing: 6

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        // nf-md-tune
                        text: "\udb81\udf56"
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        color: Theme.subtext0
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Open Volume Control"
                        color: Theme.subtext0
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

                MouseArea {
                    id: pavuMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Quickshell.execDetached(["pavucontrol"]);
                        root.close();
                    }
                }
            }
        }
    }
}
