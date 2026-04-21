import QtQuick
import Quickshell
import Quickshell.Wayland
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
        bottom: true
        right: true
    }

    implicitWidth: Theme.sidebarWidth + Theme.sidebarMargin * 2
    color: "transparent"
    exclusiveZone: -1

    WlrLayershell.namespace: "quickshell:sidebar"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region {
        item: panel
    }

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

    // ── Panel rectangle ──────────────────────────────────────────────────
    Rectangle {
        id: panel

        readonly property int openX: Theme.sidebarMargin
        readonly property int closedX: root.width + 10

        x: root.isOpen ? openX : closedX
        y: Theme.barHeight + Theme.barMargin + Theme.sidebarMargin
        width: Theme.sidebarWidth
        height: root.height - y - Theme.sidebarMargin

        radius: Theme.radius
        color: Theme.mantle
        border.color: Theme.surface0
        border.width: 1
        clip: true

        Behavior on x {
            NumberAnimation {
                duration: Theme.animDuration
                easing.type: Easing.OutCubic
            }
        }

        // ── Shadow ────────────────────────────────────────────────────────
        Rectangle {
            z: -1
            anchors.fill: parent
            anchors.margins: -1
            radius: parent.radius + 1
            color: "transparent"
            border.color: Qt.rgba(0, 0, 0, 0.4)
            border.width: 2
        }

        // ── Scrollable content (top) ──────────────────────────────────────
        Flickable {
            id: flickable

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: footer.top
            }
            anchors.margins: 16
            anchors.bottomMargin: 0

            contentHeight: contentColumn.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: contentColumn
                width: flickable.width
                spacing: 20

                // ── Header ────────────────────────────────────────────────
                Row {
                    width: parent.width
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\udb81\udcd5"  // nf-md-view_dashboard
                        font.family: Theme.fontFamily
                        font.pixelSize: 18
                        color: Theme.mauve
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Dashboard"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Bold
                    }
                }

                // ── Divider ───────────────────────────────────────────────
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.surface0
                }

                // ── Network Speed ─────────────────────────────────────────
                NetworkSpeed {
                    width: parent.width
                }

                // ── Divider ───────────────────────────────────────────────
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.surface0
                }

                // ── System Vitals ─────────────────────────────────────────
                SystemVitals {
                    width: parent.width
                }
            }
        }

        // ── Footer (pinned to bottom) ─────────────────────────────────────
        Rectangle {
            id: footer

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: footerColumn.implicitHeight + 24
            color: "transparent"

            // top separator
            Rectangle {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: 16
                    rightMargin: 16
                }
                height: 1
                color: Theme.surface0
            }

            Column {
                id: footerColumn
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: 16
                    leftMargin: 16
                    rightMargin: 16
                }
                spacing: 4

                // ── User row ──────────────────────────────────────────────
                Row {
                    spacing: 8

                    // Avatar circle
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 16
                        color: Theme.surface0
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            // nf-fa-user
                            text: "\uf007"
                            font.family: Theme.fontFamily
                            font.pixelSize: 14
                            color: Theme.mauve
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 1

                        Text {
                            text: SystemInfo.username
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeNormal
                            font.weight: Font.Bold
                        }

                        Text {
                            text: SystemInfo.uptime
                            color: Theme.subtext0
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                        }
                    }
                }

                // ── Power buttons row ─────────────────────────────────────
                Row {
                    width: parent.width
                    spacing: 8
                    topPadding: 4

                    // Power Off
                    PowerButton {
                        label: "Power Off"
                        icon: "\udb80\udc06"   // nf-md-power
                        iconColor: Theme.red
                        onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
                    }

                    // Reboot
                    PowerButton {
                        label: "Reboot"
                        icon: "\udb81\udc1b"   // nf-md-restart
                        iconColor: Theme.peach
                        onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                    }

                    // Logout / lock
                    PowerButton {
                        label: "Logout"
                        icon: "\udb80\udd4d"   // nf-md-logout
                        iconColor: Theme.yellow
                        onClicked: Quickshell.execDetached(["hyprlock"])
                    }
                }
            }
        }
    }
}
