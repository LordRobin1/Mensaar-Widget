import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import "speiseplan.js" as SpeiseplanFetcher

Item {
    id: root
    width: units.gridUnit * 20
    height: units.gridUnit * 10

    readonly property int mensaIndex: Plasmoid.configuration.mensaOption
    onMensaIndexChanged: SpeiseplanFetcher.fetchSpeiseplan(setSpeiseplan, mensaIndex)


    ColumnLayout {
        anchors.fill: parent


        Item {
            id: header
            width: parent.width
            height: units.gridUnit * 2
            Layout.alignment: Qt.AlignHCenter
            // Layout.maximumWidth: parent.width 
            Layout.fillWidth: true
            Layout.margins: 20
            Layout.bottomMargin: parent.width < 225 ? 40 : parent.width < 300 ? 20 : 5
            Layout.topMargin: 5

            RowLayout {
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gridUnit

                Controls.Button {
                    Layout.maximumWidth: .2 * parent.width
                    text: "<"
                    font.bold: true
                    onClicked: {
                        if (currentTabIndex > 0) {
                            currentTabIndex--
                        }
                    }
                    enabled: currentTabIndex > 0
                }

                Controls.Label {
                    Layout.fillWidth: true
                    text: new Date(speiseplan[currentTabIndex].date).toLocaleDateString()
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pointSize: 12
                    wrapMode: Text.Wrap
                }


                Controls.Button {
                    Layout.maximumWidth: .2 * parent.width
                    text: ">"
                    font.bold: true
                    onClicked: {
                        if (currentTabIndex < speiseplan.length - 1) {
                            currentTabIndex++
                        }
                    }
                    enabled: currentTabIndex < speiseplan.length - 1
                }
            }
        }

        Controls.ScrollView {
            id: scrollArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            // ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            Kirigami.CardsListView {
                id: meals
                model: speiseplan[currentTabIndex].counters

                delegate: Kirigami.AbstractCard {
                    contentItem: Item {
                        implicitWidth: delegateLayout.implicitWidth
                        implicitHeight: delegateLayout.implicitHeight
                        GridLayout {
                            id: delegateLayout

                            anchors {
                                left: parent.left
                                top: parent.top
                                right: parent.right
                                // IMPORTANT: never put the bottom margin
                            }
                            rowSpacing: Kirigami.Units.largeSpacing
                            columnSpacing: Kirigami.Units.largeSpacing
                            columns: width > Kirigami.Units.gridUnit * 20 ? 4 : 2

                            ColumnLayout {
                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    font.pixelSize: 14
                                    font.bold: true 
                                    wrapMode: Text.Wrap
                                }
                                Kirigami.Separator {
                                    Layout.fillWidth: true
                                }
                                RowLayout {
                                    Layout.alignment: Qt.AlignLeft
                                    spacing:10
                                    Layout.fillWidth: true
                                    Kirigami.Chip {
                                        Layout.fillWidth: true
                                        closable:false
                                        checkable:false
                                        text: modelData.price
                                    }
                                    Kirigami.Chip {
                                        Layout.fillWidth: true
                                        closable: false
                                        checkable: false
                                        text: modelData.counter
                                        font.bold: true
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 2
                                            color: Qt.rgba(modelData.color.r/255, modelData.color.g/255, modelData.color.b/255, 1)
                                        }
                                    }
                                }
                            }

                        }
                    }

                }
            }
        }
    }
    property var speiseplan: []
    property int currentTabIndex: 0

    Plasmoid.toolTipMainText: "Mensaar"
    Plasmoid.toolTipSubText: "Mensaar Speiseplan"

    function setSpeiseplan(result) {
        speiseplan = result

        for (var i = 0; i < speiseplan.length; i++) {
            if (!speiseplan[i].isPast) {
                currentTabIndex = i
                break
            }
        }
    }

    // Initial load from SpeiseplanFetcher
    Component.onCompleted: {
        SpeiseplanFetcher.fetchSpeiseplan(setSpeiseplan, mensaIndex)
    }
}
