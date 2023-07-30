import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.FormLayout {
    id: page
    property alias cfg_mensaOption: mensaOption.currentIndex 

    Controls.ComboBox {
        id: mensaOption
        editable: true
        Kirigami.FormData.label: "Mensa:"

        model: ListModel {
            id: model
            ListElement { text: "Saarbrücken"}
            ListElement { text: "Mensagarten"}
            ListElement { text: "Café B4.ar1sta"}
            ListElement { text: "Homburg"}
            ListElement { text: "HTW Göttelborn"}
            ListElement { text: "HTW Saar CAS"}
            ListElement { text: "HTW Saar CRB"}
            ListElement { text: "Cafeteria Musik Saar"}
        }

        onAccepted: {
            if (find(editText) === -1) {
                model.append({text: editText})
            }
        }
    }
}
