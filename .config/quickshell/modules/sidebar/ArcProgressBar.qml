import QtQuick
import "../../services"

// Draws a circular arc progress bar.
// Usage:
//   ArcProgressBar {
//       value: 0.72          // 0.0 – 1.0
//       label: "CPU"
//       valueText: "72%"
//       arcColor: Theme.mauve
//   }
Item {
    id: root

    property real value: 0        // 0.0 – 1.0
    property string label: ""
    property string valueText: ""
    property color arcColor: Theme.mauve
    property int arcWidth: 6
    property int size: 80

    implicitWidth: size
    implicitHeight: size + labelText.implicitHeight + 4

    // ── Arc canvas ───────────────────────────────────────────────────────
    Canvas {
        id: canvas
        width: root.size
        height: root.size
        anchors.horizontalCenter: parent.horizontalCenter

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = height / 2;
            var r = (Math.min(width, height) - root.arcWidth) / 2;

            // Start at ~225° (bottom-left), sweep 270° clockwise
            var startAngle = (225) * Math.PI / 180;
            var sweepAngle = 270 * Math.PI / 180;
            var endFull = startAngle + sweepAngle;
            var endValue = startAngle + sweepAngle * Math.max(0, Math.min(1, root.value));

            // Track (background arc)
            ctx.beginPath();
            ctx.arc(cx, cy, r, startAngle, endFull, false);
            ctx.strokeStyle = Qt.rgba(Theme.surface1.r, Theme.surface1.g, Theme.surface1.b, 0.6);
            ctx.lineWidth = root.arcWidth;
            ctx.lineCap = "round";
            ctx.stroke();

            // Value arc
            if (root.value > 0) {
                ctx.beginPath();
                ctx.arc(cx, cy, r, startAngle, endValue, false);
                ctx.strokeStyle = root.arcColor;
                ctx.lineWidth = root.arcWidth;
                ctx.lineCap = "round";
                ctx.stroke();
            }
        }

        // Redraw when value or color changes
        Connections {
            target: root
            function onValueChanged() {
                canvas.requestPaint();
            }
            function onArcColorChanged() {
                canvas.requestPaint();
            }
            function onArcWidthChanged() {
                canvas.requestPaint();
            }
        }

        // Centre text
        Column {
            anchors.centerIn: parent
            spacing: 1

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.valueText
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall + 1
                font.weight: Font.Bold
            }
        }
    }

    // ── Label below arc ──────────────────────────────────────────────────
    Text {
        id: labelText
        anchors {
            top: canvas.bottom
            topMargin: 4
            horizontalCenter: parent.horizontalCenter
        }
        text: root.label
        color: Theme.subtext0
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        font.weight: Font.Medium
    }
}
