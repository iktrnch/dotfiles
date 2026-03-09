import QtQuick
import "../../services"

Item {
    id: root

    implicitWidth: parent.width
    implicitHeight: vitalsColumn.implicitHeight

    Column {
        id: vitalsColumn
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 16

        // ── Section header ────────────────────────────────────────────────
        Text {
            text: "System"
            color: Theme.subtext0
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Bold
            leftPadding: 2
        }

        // ── Arc row ───────────────────────────────────────────────────────
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            ArcProgressBar {
                size: 82
                arcColor: Theme.mauve
                value: ResourceMonitor.cpuPercent / 100
                label: "CPU"
                valueText: ResourceMonitor.cpuPercent + "%"
            }

            ArcProgressBar {
                size: 82
                arcColor: Theme.blue
                value: ResourceMonitor.ramPercent / 100
                label: "RAM"
                valueText: ResourceMonitor.ramUsedGb + "G"
            }

            ArcProgressBar {
                size: 82
                arcColor: Theme.peach
                value: ResourceMonitor.diskPercent / 100
                label: "Disk"
                valueText: ResourceMonitor.diskPercent + "%"
            }
        }

        // ── Detail rows ───────────────────────────────────────────────────
        Column {
            anchors {
                left: parent.left
                right: parent.right
            }
            spacing: 6

            // CPU detail
            VitalRow {
                width: parent.width
                label: "CPU"
                valueText: ResourceMonitor.cpuPercent + "%"
                progress: ResourceMonitor.cpuPercent / 100
                barColor: Theme.mauve
            }

            // RAM detail
            VitalRow {
                width: parent.width
                label: "RAM"
                valueText: ResourceMonitor.ramUsedGb + " / " + ResourceMonitor.ramTotalGb + " GB"
                progress: ResourceMonitor.ramPercent / 100
                barColor: Theme.blue
            }

            // Disk detail
            VitalRow {
                width: parent.width
                label: "Disk"
                valueText: ResourceMonitor.diskUsedGb + " / " + ResourceMonitor.diskTotalGb + " GB"
                progress: ResourceMonitor.diskPercent / 100
                barColor: Theme.peach
            }
        }
    }
}
