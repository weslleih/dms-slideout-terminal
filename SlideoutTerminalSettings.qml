import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

import QMLTermWidget

PluginSettings {
    id: root
    pluginId: "slideoutTerminal"

    property list<string> colorSchemes
    property list<string> fonts: Qt.fontFamilies()

    readonly property string commandStr: "dms ipc call plugins toggle slideoutTerminal"

    QMLTermWidget {
        id: auxTerminal
        session: QMLTermSession {
            id: auxSession
            initialWorkingDirectory: "$HOME"
        }
        Component.onCompleted: {
            auxSession.startShellProgram();
            colorSchemes = auxTerminal.availableColorSchemes;
        }
    }

    function copyToClipboard() {
        clipboardHelper.text = root.commandStr;
        clipboardHelper.selectAll();
        clipboardHelper.copy();
        ToastService.showInfo("Copied");
    }

    StyledText {
        width: parent.width
        text: "Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    Row {
        width: parent.width
        anchors.margins: Theme.spacingL
        StringSetting {
            settingKey: "minWidth"
            label: "Minimum width"
            placeholder: "920"
            defaultValue: "920"
            width: parent.width / 2
        }

        StringSetting {
            settingKey: "maxWidth"
            label: "Maximum width"
            placeholder: "1200"
            defaultValue: "1200"
            width: parent.width / 2
        }
    }

    SelectionSetting {
        settingKey: "colorScheme"
        label: "Color Scheme"
        description: "Select one of the color schemes available in the system."
        options: colorSchemes
        defaultValue: "BreezeModified"
    }

    SelectionSetting {
        settingKey: "font"
        label: "Font"
        description: "Select one of the fonts available in the system."
        options: fonts
        defaultValue: "Monospace"
    }

    SliderSetting {
        settingKey: "fontSize"
        label: "Font size"
        defaultValue: 10
        minimum: 5
        maximum: 32
        unit: "px"
        leftIcon: "text_format"
    }

    StyledRect {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "To configure a keyboard shortcut, add the following shell command to the keyboard shortcuts section."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    DankTextField {
        id: textCommand
        width: parent.width
        text: root.commandStr

        onTextEdited: {
            textCommand.text = root.commandStr;
        }
    }

    DankButton {
        id: copyButton
        text: 'Copy'
        iconName: "content_copy"
        anchors.right: parent.right
        onClicked: copyToClipboard()
    }

    TextEdit {
        id: clipboardHelper
        visible: false
    }
}
