pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import "../../services"

Item {
    id: root

    // Grab the first playing player, fall back to first available
    readonly property MprisPlayer activePlayer: {
        var players = Mpris.players.values;
        for (var i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing)
                return players[i];
        }
        return players.length > 0 ? players[0] : null;
    }

    readonly property bool hasPlayer: activePlayer !== null
    readonly property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing

    // Hide entirely when nothing is running
    visible: hasPlayer
    implicitWidth: hasPlayer ? inner.implicitWidth + Theme.barPadding * 2 : 0
    implicitHeight: Theme.barHeight

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Theme.animDuration
            easing.type: Easing.OutCubic
        }
    }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 6

        // ── Next ──────────────────────────────────────────────────────────
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "•"   // nf-md-skip_next
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeIcon
            color: (root.activePlayer?.canGoNext ?? false) ? Theme.subtext0 : Theme.surface2
        }

        // ── Track title ───────────────────────────────────────────────────
        Text {
            id: trackLabel
            anchors.verticalCenter: parent.verticalCenter

            readonly property string title: root.activePlayer?.trackTitle ?? ""
            readonly property string artist: root.activePlayer?.trackArtist ?? ""
            readonly property string display: artist !== "" ? artist + " – " + title : title

            text: display
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.weight: Font.Medium
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 180)

            Behavior on text {
                SequentialAnimation {
                    NumberAnimation {
                        target: trackLabel
                        property: "opacity"
                        to: 0
                        duration: 80
                    }
                    PropertyAction {}
                    NumberAnimation {
                        target: trackLabel
                        property: "opacity"
                        to: 1
                        duration: 80
                    }
                }
            }
        }
    }
}
