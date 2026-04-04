pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

import QMLTermWidget

import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

Item {
    id: root

    anchors.fill: parent

    required property var settingsData

    signal sessionEnd(SlideoutTerminal terminal)

    Action {
        onTriggered: terminalWidget.pasteClipboard()
        shortcut: "Ctrl+Shift+V"
    }

    Action {
        onTriggered: terminalWidget.pasteClipboard()
        shortcut: "Shift+Insert"
    }

    Action {
        onTriggered: terminalWidget.copyClipboard()
        shortcut: "Ctrl+Shift+C"
    }

    Action {
        onTriggered: terminalWidget.copyClipboard()
        shortcut: "Ctrl+Inset"
    }

    QMLTermWidget {
        id: terminalWidget

        anchors.fill: parent

        font.family: settingsData.font || "Monospace"
        font.pointSize: settingsData.fontSize || 10

        colorScheme: settingsData.colorScheme || "BreezeModified"

        session: QMLTermSession {
            id: mainsession
            initialWorkingDirectory: "$HOME"
            onFinished: {
                root.sessionEnd(root);
            }
        }

        Component.onCompleted: {
            mainsession.startShellProgram();
            terminalWidget.forceActiveFocus();
        }

        QMLTermScrollbar {
            id: scrollbar
            terminal: terminalWidget
            width: 20
            Rectangle {
                opacity: 0.4
                anchors.margins: 5
                radius: width * 0.5
                anchors.fill: parent
            }
        }

        onVisibleChanged:{
            if(visible){
                terminalWidget.forceActiveFocus();
                //Prevents a visual glitch simulating pressing the down arrow key.
                terminalWidget.simulateKeyPress(16777237, 0, false, 0, "")
            }
        }
    }
}
