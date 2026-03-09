import QtQuick
import "../../services"

Item {
    id: root

    signal sidebarToggleRequested

    anchors.fill: parent

    // ── Floating pill ─────────────────────────────────────────────────────
    Rectangle {
        id: pill

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: Theme.barMargin
            leftMargin: Theme.barMargin
            rightMargin: Theme.barMargin
        }

        height: Theme.barHeight
        radius: Theme.radius
        color: Theme.crust
        border.color: Theme.surface0
        border.width: 1

        // ── Left section ──────────────────────────────────────────────────
        Row {
            id: leftSection
            anchors {
                left: parent.left
                leftMargin: Theme.barPadding
                verticalCenter: parent.verticalCenter
            }
            spacing: 4

            ArchLogo {}
            Clock {}
            Workspaces {}
        }

        // ── Center section ────────────────────────────────────────────────
        Item {
            anchors.centerIn: parent
            width: Math.min(400, parent.width / 3)
            height: parent.height

            WindowTitle {
                anchors.centerIn: parent
                width: parent.width
            }
        }

        // ── Right section ─────────────────────────────────────────────────
        Row {
            id: rightSection
            anchors {
                right: parent.right
                rightMargin: Theme.barPadding
                verticalCenter: parent.verticalCenter
            }
            spacing: 4
            layoutDirection: Qt.RightToLeft

            HamburgerButton {
                onClicked: root.sidebarToggleRequested()
            }
            Tray {}
            Volume {}
        }
    }
}
