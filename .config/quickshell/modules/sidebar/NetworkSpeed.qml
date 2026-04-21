import QtQuick
import "../../services"

Item {
    id: root

    implicitWidth: parent?.width ?? 280
    implicitHeight: netColumn.implicitHeight

    Column {
        id: netColumn
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 10

        // ── Section header ────────────────────────────────────────────────
        Text {
            text: "Network"
            color: Theme.subtext0
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Bold
            leftPadding: 2
        }

        // ── Speed cards ───────────────────────────────────────────────────
        Row {
            anchors {
                left: parent.left
                right: parent.right
            }
            spacing: 8

            // Download card
            Rectangle {
                id: downCard
                width: (parent.width - parent.spacing) / 2
                height: 56
                radius: Theme.radius
                color: Theme.surface0

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    // Arrow icon (down)
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        // nf-md-arrow_down_bold
                        text: "\udb81\udc5c"
                        font.family: Theme.fontFamily
                        font.pixelSize: 20
                        color: Theme.green
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: "DOWN"
                            color: Theme.subtext0
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                            font.weight: Font.Bold
                            font.letterSpacing: 0.8
                        }

                        Text {
                            text: ResourceMonitor.netDownText
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeNormal
                            font.weight: Font.Bold
                        }
                    }
                }
            }

            // Upload card
            Rectangle {
                id: upCard
                width: (parent.width - parent.spacing) / 2
                height: 56
                radius: Theme.radius
                color: Theme.surface0

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    // Arrow icon (up)
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        // nf-md-arrow_up_bold
                        text: "\udb81\udc4d"
                        font.family: Theme.fontFamily
                        font.pixelSize: 20
                        color: Theme.blue
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: "UP"
                            color: Theme.subtext0
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                            font.weight: Font.Bold
                            font.letterSpacing: 0.8
                        }

                        Text {
                            text: ResourceMonitor.netUpText
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeNormal
                            font.weight: Font.Bold
                        }
                    }
                }
            }
        }

        // ── Mini sparkline-style activity bar (down) ──────────────────────
        Column {
            anchors {
                left: parent.left
                right: parent.right
            }
            spacing: 4

            // Download bar
            Item {
                width: parent.width
                height: 16

                Text {
                    id: downBarLabel
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: "\udb81\udc5c"
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    color: Theme.green
                    width: 16
                }

                Rectangle {
                    id: downTrack
                    anchors {
                        left: downBarLabel.right
                        leftMargin: 6
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    height: 4
                    radius: 2
                    color: Theme.surface1

                    // Normalise against 10 MB/s ceiling for visual feedback
                    readonly property real normValue: Math.min(1.0, ResourceMonitor.netDownKbps / 10240)

                    Rectangle {
                        width: Math.max(downTrack.radius * 2, downTrack.width * downTrack.normValue)
                        height: parent.height
                        radius: parent.radius
                        color: Theme.green

                        Behavior on width {
                            NumberAnimation {
                                duration: Theme.animDuration
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }

            // Upload bar
            Item {
                width: parent.width
                height: 16

                Text {
                    id: upBarLabel
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: "\udb81\udc4d"
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    color: Theme.blue
                    width: 16
                }

                Rectangle {
                    id: upTrack
                    anchors {
                        left: upBarLabel.right
                        leftMargin: 6
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    height: 4
                    radius: 2
                    color: Theme.surface1

                    readonly property real normValue: Math.min(1.0, ResourceMonitor.netUpKbps / 10240)

                    Rectangle {
                        width: Math.max(upTrack.radius * 2, upTrack.width * upTrack.normValue)
                        height: parent.height
                        radius: parent.radius
                        color: Theme.blue

                        Behavior on width {
                            NumberAnimation {
                                duration: Theme.animDuration
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}
