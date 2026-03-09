//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick

import "./services"
import "./modules/bar"
import "./modules/sidebar"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        delegate: Scope {
            id: screenScope
            required property var modelData

            BarWindow {
                id: barWindow
                screen: screenScope.modelData
                onSidebarToggleRequested: sidebar.toggle()
            }

            Sidebar {
                id: sidebar
                screen: screenScope.modelData
                visible: false
            }
        }
    }
}
