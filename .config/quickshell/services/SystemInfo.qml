pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string username: ""
    property string uptime: ""

    // ── Username via $USER env ────────────────────────────────────────────
    Process {
        id: envProc
        command: ["bash", "-c", "echo $USER"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.trim() !== "")
                    root.username = line.trim();
            }
        }
    }

    // ── Uptime via `uptime -p` ────────────────────────────────────────────
    Process {
        id: uptimeProc
        command: ["uptime", "-p"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                // "up 2 hours, 15 minutes" → strip leading "up "
                var s = line.trim();
                if (s.startsWith("up "))
                    s = s.substring(3);
                root.uptime = s;
            }
        }
    }

    // Poll every 30 seconds
    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: uptimeProc.running = true
    }
}
