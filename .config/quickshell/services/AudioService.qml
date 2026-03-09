pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property bool micMuted: source?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property int volumePct: Math.round(volume * 100)
    readonly property string volumeLabel: muted ? "Muted" : volumePct + "%"

    // Icon selection (Nerd Font codepoints)
    readonly property string volumeIcon: {
        if (muted)
            return "\uf6a9";       // nf-fa-volume_off
        if (volumePct >= 66)
            return "\udb81\udd7e"; // nf-md-volume_high   (󰕾)
        if (volumePct >= 33)
            return "\udb81\udd7d"; // nf-md-volume_medium (󰖀)
        return "\udb81\udd7c";     // nf-md-volume_low    (󰕿)
    }

    // Keep sink & source tracked so property bindings stay live
    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    function setVolume(val) {
        if (!root.sink?.audio)
            return;
        root.sink.audio.volume = Math.max(0, Math.min(1.5, val));
    }

    function adjustVolume(delta) {
        setVolume(root.volume + delta);
    }

    function toggleMute() {
        if (root.sink?.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }

    function toggleMicMute() {
        if (root.source?.audio)
            root.source.audio.muted = !root.source.audio.muted;
    }
}
