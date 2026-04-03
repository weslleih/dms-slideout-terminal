pragma ComponentBehavior: Bound
import QtQuick
import QMLTermWidget
import QtQuick.Controls

import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

Item {
    id: root

    anchors.fill: parent

    required property var settingsData

    signal sessionEnd(SlideoutTerminal terminal)

    onVisibleChanged: {
        if (visible) {
            terminalWidget.forceActiveFocus();
        }
    }

    onHeightChanged: {
        //Prevents a bug that occurs when the height value becomes less than 0.
        if (height > 0) {
            terminalWidget.height = height;
        }
    }

    Action {
        onTriggered: terminalWidget.pasteClipboard()
        shortcut: "Ctrl+Shift+V"
    }

    Action {
        onTriggered: terminalWidget.copyClipboard()
        shortcut: "Ctrl+Shift+C"
    }

    QMLTermWidget {
        id: terminalWidget

        width: parent.width
        height: parent.height

        font.family: "Monospace"
        font.pointSize: settingsData.fontSize || 10

        colorScheme: settingsData.colorScheme || "BreezeModified"

        session: QMLTermSession {
            id: mainsession
            initialWorkingDirectory: "$HOME"
            onFinished: {
                root.sessionEnd(root)
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
    }
}
