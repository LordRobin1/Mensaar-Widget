import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import "speiseplan.js" as MensaarFetcher

Item {
    id: root
    width: units.gridUnit * 20
    height: units.gridUnit * 10

    readonly property int mensaIndex: mensaOption.currentIndex
    onMensaIndexChanged: MensaarFetcher.fetchSpeiseplan(setSpeiseplan, mensaIndex)
    readonly property bool useColor: Plasmoid.configuration.useColor
    readonly property bool showComponents: Plasmoid.configuration.showComponents
    readonly property bool showLocationTip: Plasmoid.configuration.showLocationTip
    readonly property bool showPriceTip: Plasmoid.configuration.showPriceTip

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: config
            width: parent.width
            height: units.gridUnit * 2
            Layout.fillWidth: true
            Layout.margins: 20
            Layout.bottomMargin: 5
            Layout.topMargin: 5

            RowLayout {
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gridUnit

                Controls.ComboBox {
                    Layout.fillWidth: true
                    id: mensaOption
                    currentIndex: 0

                    model: ListModel {
                        id: model
                        ListElement { text: "Saarbrücken" }
                        ListElement { text: "Mensagarten" }
                        ListElement { text: "Café B4.ar1sta" }
                        ListElement { text: "Homburg" }
                        ListElement { text: "HTW Göttelborn" }
                        ListElement { text: "HTW Saar CAS" }
                        ListElement { text: "HTW Saar CRB" }
                        ListElement { text: "Cafeteria Musik Saar" }
                    }

                    PlasmaCore.ToolTipArea {
                        visible: showLocationTip
                        anchors.fill: parent
                        mainText: baseData.locations[mensen[mensaIndex]].displayName
                        subText: baseData.locations[mensen[mensaIndex]].description
                    }
                }
                PlasmaComponents.ToolButton {
                    Layout.minimumHeight: 20
                    Kirigami.Theme.colorSet: Kirigami.Theme.Button
                    Kirigami.Theme.inherit: false
                    Layout.fillWidth: true
                    iconSource: "refreshstructure"
                    enabled: true
                    onClicked: {
                        MensaarFetcher.fetchSpeiseplan(setSpeiseplan, mensaIndex);
                        MensaarFetcher.fetchBaseData(setBaseData);
                    }
                }
            }
        }

        Item {
            id: header
            width: parent.width
            height: units.gridUnit * 2
            Layout.alignment: Qt.AlignHCenter
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
                                
                                Column {
                                    visible: showComponents && modelData.components.length > 0
                                    // Layout.fillWidth: true
                                    // Layout.alignment: Qt.AlignLeft
                                    Repeater {
                                        id: components
                                        model: modelData.components
                                        RowLayout {
                                            visible: modelData.name != ""
                                            Layout.alignment: Qt.AlignLeft
                                            spacing:5
                                            Layout.fillWidth: true
                                            Text {
                                                Layout.fillWidth: true
                                                text: "• "
                                                color: Kirigami.Theme.textColor
                                                wrapMode: Text.Wrap
                                            }
                                            Controls.Label {
                                                Layout.fillWidth: true
                                                text: modelData.name
                                                wrapMode: Text.Wrap
                                            }
                                        }
                                    }
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
                                        text: modelData.prices != undefined ? `${modelData.prices.s}€` : "N/A"

                                        PlasmaCore.ToolTipArea {
                                            visible: showPriceTip
                                            anchors.fill: parent
                                            mainText: "Preise"
                                            subText: `Studenten: ${modelData.prices != undefined ? `${modelData.prices.s}€` : "N/A"}`
                                                        +`\nBedienstete: ${modelData.prices != undefined ? `${modelData.prices.m}€` : "N/A"}`
                                                        +`\nGäste: ${modelData.prices != undefined ? `${modelData.prices.g}€` : "N/A"}`
                                        }

                                        Kirigami.Theme.colorSet: Kirigami.Theme.Button
                                        Kirigami.Theme.inherit: false
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 2
                                            color: Kirigami.Theme.backgroundColor
                                        }
                                    }

                                    Kirigami.Chip {
                                        Layout.fillWidth: true
                                        closable: false
                                        checkable: false
                                        text: modelData.counter
                                        font.bold: true
                                        Kirigami.Theme.colorSet: Kirigami.Theme.Button
                                        Kirigami.Theme.inherit: false
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 2
                                            color: useColor 
                                                    ? Qt.rgba(modelData.color.r/255, modelData.color.g/255, modelData.color.b/255, 1) 
                                                    : Kirigami.Theme.backgroundColor
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
    property var mensen: ["sb", "mensagarten", "b4r1sta", "hom", "htwgtb", "htwcas", "htwcrb", "musiksb"] 
    property var speiseplan: []
    property var baseData: {}
    property int currentTabIndex: 0

    Plasmoid.toolTipMainText: "Mensaar"
    Plasmoid.toolTipSubText: "Mensaar Speiseplan"

    function setSpeiseplan(result) {
        speiseplan = result;

        for (var i = 0; i < speiseplan.length; i++) {
            if (!speiseplan[i].isPast) {
                currentTabIndex = i;
                break;
            }
        }
    }
    function setBaseData(result) {
        baseData = result;
    }

    // Initial load from MensaarFetcher
    Component.onCompleted: {
        MensaarFetcher.fetchSpeiseplan(setSpeiseplan, mensaIndex);
        MensaarFetcher.fetchBaseData(setBaseData)
    }
}
