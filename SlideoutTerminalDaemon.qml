pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    signal sessionEnd(SlideoutTerminal terminal)

    function toggle() {
        terminalSlideout.toggle();
    }

    DankSlideout {
        id: terminalSlideout
        slideoutWidth: root.pluginData.minWidth || 900
        expandable: true
        expandedWidthValue: root.pluginData.maxWidth || 1200

        content: Column {
            anchors.fill: parent
            spacing: Theme.spacingM

            Row {
                width: parent.width
                height: 36
                spacing: Theme.spacingXS

                ScrollView {
                    width: parent.width - newTabButton.width - Theme.spacingXS
                    height: parent.height
                    clip: true

                    ScrollBar.horizontal.visible: false
                    ScrollBar.vertical.visible: false

                    Row {
                        spacing: Theme.spacingXS

                        Repeater {
                            model: listTerminals.children

                            delegate: Item {
                                id: delegateItem
                                required property int index
                                required property SlideoutTerminal modelData

                                readonly property bool isActive: modelData.visible
                                readonly property bool isHovered: tabMouseArea.containsMouse && !closeMouseArea.containsMouse

                                width: 80
                                height: 32
                                z: 0

                                Item {
                                    id: tabVisual

                                    anchors.fill: parent

                                    Rectangle {
                                        id: tabRect
                                        z: 1
                                        anchors.fill: parent
                                        radius: Theme.cornerRadius
                                        color: delegateItem.isActive ? Theme.primaryPressed : delegateItem.isHovered ? Theme.primaryHoverLight : Theme.withAlpha(Theme.primaryPressed, 0)
                                        border.width: isActive ? 0 : 1
                                        border.color: Theme.outlineMedium
                                        clip: true

                                        Row {
                                            id: tabContent
                                            anchors.fill: parent
                                            anchors.leftMargin: Theme.spacingM
                                            anchors.rightMargin: Theme.spacingM
                                            spacing: Theme.spacingXS

                                            StyledText {
                                                id: tabText
                                                width: parent.width - (tabCloseButton.visible ? tabCloseButton.width + Theme.spacingXS : 0)
                                                text: ">_  " + (index + 1)
                                                font.pixelSize: Theme.fontSizeSmall
                                                color: isActive ? Theme.primary : Theme.surfaceText
                                                font.weight: isActive ? Font.Medium : Font.Normal
                                                elide: Text.ElideMiddle
                                                maximumLineCount: 1
                                                wrapMode: Text.NoWrap
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Rectangle {
                                                id: tabCloseButton
                                                width: 20
                                                height: 20
                                                radius: Theme.cornerRadius
                                                color: closeMouseArea.containsMouse ? Theme.surfaceTextHover : Theme.withAlpha(Theme.surfaceTextHover, 0)
                                                anchors.verticalCenter: parent.verticalCenter

                                                DankIcon {
                                                    name: "close"
                                                    size: 14
                                                    color: Theme.surfaceTextMedium
                                                    anchors.centerIn: parent
                                                }

                                                MouseArea {
                                                    id: closeMouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    z: 100

                                                    onClicked: listTerminals.tabClose(index)
                                                }
                                            }
                                        }
                                    }

                                    MouseArea {
                                        id: tabMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onClicked: listTerminals.tabChange(index)
                                    }
                                }
                            }
                        }
                    }
                }

                DankActionButton {
                    id: newTabButton
                    width: 32
                    height: 32
                    iconName: "add"
                    iconSize: Theme.iconSize - 4
                    iconColor: Theme.surfaceText
                    onClicked: listTerminals.tabAdd()
                }
            }

            Item {
                id: listTerminals

                height: parent.height - 36 - Theme.spacingM
                width: parent.width

                onChildrenChanged: {
                    if (this.children.length == 0) {
                        tabAdd();
                    }
                }

                function tabAdd() {
                    var component = Qt.createComponent("SlideoutTerminal.qml");
                    var obj = component.createObject(this, {
                        settingsData: root.pluginData
                    });

                    obj.sessionEnd.connect(function (terminal) {
                        var index = listTerminals.children.indexOf(terminal)
                        console.log(index)
                        tabClose(index)
                    });

                    this.tabChange(this.children.length - 1);
                }

                function tabClose(index) {
                    if (this.children[index].visible) {
                        this.children[index].visible = false;
                        if (index > 0) {
                            this.children[index - 1].visible = true;
                        } else if (this.children.length > 1) {
                            this.children[index + 1].visible = true;
                        }
                    }

                    this.children[index].destroy();
                }

                function tabChange(index) {
                    this.children.forEach(e => e.visible = false);

                    this.children[index].visible = true;
                }

                Component.onCompleted: {
                    tabAdd();
                }
            }
        }
    }
}
