pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    // ── Catppuccin Mocha ────────────────────────────────────────────────
    readonly property color crust: "#11111b"
    readonly property color mantle: "#181825"
    readonly property color base: "#1e1e2e"

    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"

    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay2: "#9399b2"

    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"
    readonly property color text: "#cdd6f4"

    readonly property color rosewater: "#f5e0dc"
    readonly property color flamingo: "#f2cdcd"
    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color maroon: "#eba0ac"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sky: "#89dceb"
    readonly property color sapphire: "#74c7ec"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"

    // ── Semantic aliases ────────────────────────────────────────────────
    readonly property color bg: base
    readonly property color bgDark: mantle
    readonly property color bgDarker: crust
    readonly property color fg: text
    readonly property color fgMuted: subtext0
    readonly property color border: surface1
    readonly property color accent: mauve
    readonly property color accentAlt: blue
    readonly property color workspaceActive: mauve
    readonly property color workspaceOccupied: subtext0
    readonly property color workspaceEmpty: surface1

    // ── Sizing & layout ─────────────────────────────────────────────────
    readonly property int barHeight: 30
    readonly property int barMargin: 5
    readonly property int barPadding: 8
    readonly property int radius: 8
    readonly property int radiusSmall: 4
    readonly property int sidebarWidth: 320
    readonly property int sidebarMargin: 8

    // ── Typography ───────────────────────────────────────────────────────
    readonly property string fontFamily: "JetBrains Mono NL"
    readonly property int fontSizeNormal: 13
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeLarge: 15
    readonly property int fontSizeIcon: 16

    // ── Animation ────────────────────────────────────────────────────────
    readonly property int animDuration: 200
}
