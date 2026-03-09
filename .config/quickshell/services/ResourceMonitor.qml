pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // ── CPU ─────────────────────────────────────────────────────────────
    property real cpuPercent: 0
    property var _lastCpu: ({
            user: 0,
            nice: 0,
            system: 0,
            idle: 0,
            iowait: 0,
            irq: 0,
            softirq: 0
        })

    // ── RAM ─────────────────────────────────────────────────────────────
    property real ramPercent: 0
    property real ramUsedGb: 0
    property real ramTotalGb: 0

    // ── Disk (root mount) ────────────────────────────────────────────────
    property real diskPercent: 0
    property real diskUsedGb: 0
    property real diskTotalGb: 0

    // ── Network speed ────────────────────────────────────────────────────
    property real netUpKbps: 0
    property real netDownKbps: 0
    property string netUpText: "0 KB/s"
    property string netDownText: "0 KB/s"
    property var _lastNet: ({
            rx: 0,
            tx: 0
        })

    // ── Helpers ──────────────────────────────────────────────────────────
    function _formatSpeed(kbps) {
        if (kbps >= 1024)
            return (kbps / 1024).toFixed(1) + " MB/s";
        return kbps.toFixed(0) + " KB/s";
    }

    // ── Polling timer ────────────────────────────────────────────────────
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            netProc.running = true;
        }
    }

    // Run disk check less frequently (every 10 s)
    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: diskProc.running = true
    }

    // ── /proc/stat → CPU ─────────────────────────────────────────────────
    Process {
        id: cpuProc
        command: ["bash", "-c", "head -1 /proc/stat"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                var p = line.trim().split(/\s+/);
                if (p.length < 8 || p[0] !== "cpu")
                    return;
                var user = parseInt(p[1]);
                var nice = parseInt(p[2]);
                var system = parseInt(p[3]);
                var idle = parseInt(p[4]);
                var iowait = parseInt(p[5]);
                var irq = parseInt(p[6]);
                var softirq = parseInt(p[7]);

                var prev = root._lastCpu;
                var prevIdle = prev.idle + prev.iowait;
                var curIdle = idle + iowait;
                var prevTotal = prev.user + prev.nice + prev.system + prev.idle + prev.iowait + prev.irq + prev.softirq;
                var curTotal = user + nice + system + idle + iowait + irq + softirq;
                var dTotal = curTotal - prevTotal;
                var dIdle = curIdle - prevIdle;

                root.cpuPercent = dTotal > 0 ? Math.round(((dTotal - dIdle) / dTotal) * 100) : 0;
                root._lastCpu = {
                    user,
                    nice,
                    system,
                    idle,
                    iowait,
                    irq,
                    softirq
                };
            }
        }
    }

    // ── /proc/meminfo → RAM ──────────────────────────────────────────────
    Process {
        id: memProc
        command: ["bash", "-c", "grep -E '^(MemTotal|MemAvailable):' /proc/meminfo"]
        running: false

        property int memTotal: 0
        property int memAvail: 0

        stdout: SplitParser {
            onRead: line => {
                var p = line.trim().split(/\s+/);
                if (p[0] === "MemTotal:")
                    memProc.memTotal = parseInt(p[1]);
                if (p[0] === "MemAvailable:")
                    memProc.memAvail = parseInt(p[1]);
            }
        }

        onExited: {
            if (memProc.memTotal > 0) {
                var used = memProc.memTotal - memProc.memAvail;
                root.ramPercent = Math.round((used / memProc.memTotal) * 100);
                root.ramUsedGb = parseFloat((used / 1048576).toFixed(1));
                root.ramTotalGb = parseFloat((memProc.memTotal / 1048576).toFixed(1));
            }
        }
    }

    // ── df -BG / → Disk ──────────────────────────────────────────────────
    Process {
        id: diskProc
        command: ["bash", "-c", "df -BG / | tail -1"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                var p = line.trim().split(/\s+/);
                if (p.length < 6)
                    return;
                var total = parseInt(p[1]);
                var used = parseInt(p[2]);
                root.diskPercent = Math.round((used / total) * 100);
                root.diskUsedGb = used;
                root.diskTotalGb = total;
            }
        }
    }

    // ── /proc/net/dev → Network speed ────────────────────────────────────
    Process {
        id: netProc
        // Sum all non-loopback interfaces
        command: ["bash", "-c", "grep -v -E '(lo|Inter|face)' /proc/net/dev | awk '{rx+=$2; tx+=$10} END{print rx, tx}'"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                var p = line.trim().split(/\s+/);
                if (p.length < 2)
                    return;
                var rx = parseFloat(p[0]);
                var tx = parseFloat(p[1]);

                var prev = root._lastNet;
                if (prev.rx > 0 || prev.tx > 0) {
                    var downKbps = Math.max(0, (rx - prev.rx) / 1024);
                    var upKbps = Math.max(0, (tx - prev.tx) / 1024);
                    root.netDownKbps = downKbps;
                    root.netUpKbps = upKbps;
                    root.netDownText = root._formatSpeed(downKbps);
                    root.netUpText = root._formatSpeed(upKbps);
                }
                root._lastNet = {
                    rx,
                    tx
                };
            }
        }
    }
}
