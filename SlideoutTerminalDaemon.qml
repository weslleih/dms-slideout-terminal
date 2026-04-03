import QtQuick
import Quickshell

import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    function toggle() {
        terminalSlideout.toggle();
    }

    DankSlideout {
        id: terminalSlideout
        title: I18n.tr("Terminal")
        slideoutWidth: root.pluginData.minWidth || 900
        expandable: true
        expandedWidthValue: root.pluginData.maxWidth || 1200

        content: Component {
            SlideoutTerminal {
                settingsData: root.pluginData
                implicitHeight: terminalSlideout.container.height > 0 ? terminalSlideout.container.height : 440
            }
        }
    }
}
