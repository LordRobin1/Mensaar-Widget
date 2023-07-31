import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.FormLayout {
    id: page
    property alias cfg_useColor: useColor.checked 

    Controls.CheckBox {
        id: useColor
        // Kirigami.FormData.label: "Use color:"
        text: "Use color"
        checked: true
    }
}
