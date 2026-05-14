import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland // <-- Added native Hyprland integration
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme

PanelWindow {
    id: root

    // --- 1. OVERLAY & WAYLAND FIXES ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore

    implicitWidth: panelBg.width
    implicitHeight: panelBg.height
    color: "transparent"

    anchors {
        right: true
    }

    // --- CLICK OUTSIDE TO CLOSE (Native Hyprland) ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- HANDLE ESCAPE SHORTCUT ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }
    Shortcut {
        sequence: "L"
        enabled: root.isOpen
        onActivated: { powerProcess.command = ["bash", "-c", "pidof hyprlock || hyprlock"]; powerProcess.running = true; root.isOpen = false }
    }
    Shortcut {
        sequence: "E"
        enabled: root.isOpen
        onActivated: { powerProcess.command = ["hyprctl", "dispatch", "hl.dsp.exit()"]; powerProcess.running =true; root.isOpen = false }
    }
    Shortcut {
        sequence: "U"
        enabled: root.isOpen
        onActivated: { powerProcess.command = ["bash", "-c", "~/.config/hypr/scripts/power.sh suspend"]; powerProcess.running = true; root.isOpen = false }
    }
    Shortcut {
        sequence: "R"
        enabled: root.isOpen
        onActivated: { powerProcess.command = ["bash", "-c", "~/.config/hypr/scripts/power.sh reboot"]; powerProcess.running = true; root.isOpen = false }
    }
    Shortcut {
        sequence: "S"
        enabled: root.isOpen
        onActivated: { powerProcess.command = ["bash", "-c", "~/.config/hypr/scripts/power.sh shutdown"]; powerProcess.running = true; root.isOpen = false }
    }

    // --- 2. ANIMATION LOGIC (FIXED) ---
    property bool isOpen: false

    // Keep the window mapped to the screen while the animation is playing
    visible: isOpen || slideAnim.running

    margins {
        right: root.currentMargin
    }

    // Ternary operator: If open, set to 20. If closed, set to -150.
    property real currentMargin: isOpen ? 20 : -150

    // This automatically animates currentMargin whenever it changes!
    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint
        }
    }

    IpcHandler {
        target: "power"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   // <-- Added for Waybar safety
        function close(): void { root.isOpen = false } // <-- Added for Waybar safety

        // Action triggers
    function lock(): void     { powerProcess.command = ["bash", "-c", "pidof hyprlock || hyprlock"]; powerProcess.running = true; root.isOpen = false }
    function suspend(): void  { powerProcess.command = ["bash", "-c", "systemctl suspend"];  powerProcess.running = true; root.isOpen = false }
    function reboot(): void   { powerProcess.command = ["bash", "-c", "systemctl reboot"];   powerProcess.running = true; root.isOpen = false }
    function poweroff(): void { powerProcess.command = ["bash", "-c", "systemctl poweroff"]; powerProcess.running = true; root.isOpen = false }
    }

    Process {
        id: powerProcess
        running: false
    }

    // ==========================================
    // MAIN PANEL BACKGROUND (The Pill Shape)
    // ==========================================
    Item {
        id: panelBg
        implicitWidth: 80
        implicitHeight: buttonLayout.implicitHeight + 40

        Rectangle {
            anchors.fill: parent
            color: Theme.background
            border.color: Theme.primary
            border.width: 2
            radius: 40
            opacity: 0.9 // Only the background is transparent
        }

        // ==========================================
        // BUTTON LAYOUT
        // ==========================================
        ColumnLayout {
            id: buttonLayout
            anchors.centerIn: parent
            spacing: 20

            component PowerButton: Rectangle {
                id: btn
                property string iconTxt: ""
                property string cmd: ""

                implicitWidth: 50
                implicitHeight: 50
                radius: 25

                color: mouseArea.containsMouse ? Theme.primary : "transparent"
                border.color: Theme.primary
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: btn.iconTxt
                    font.family: "monospace"
                    font.pixelSize: 20
                    color: mouseArea.containsMouse ? Theme.background : Theme.primary
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        powerProcess.command = ["bash", "-c", btn.cmd]
                        powerProcess.running = true
                        root.isOpen = false // Trigger the slide-out animation!
                    }
                }
            }

            PowerButton { iconTxt: ""; cmd: "pidof hyprlock || hyprlock" }
            PowerButton { iconTxt: ""; cmd: "systemctl suspend" }
            PowerButton { iconTxt: ""; cmd: "hyprctl dispatch 'hl.dsp.exit()'" }
            PowerButton { iconTxt: ""; cmd: "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'" }
            PowerButton { iconTxt: ""; cmd: "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'" }
        }
    }
}
