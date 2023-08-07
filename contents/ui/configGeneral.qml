import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.FormLayout {
    id: page
    property alias cfg_useColor: useColor.checked 
    property alias cfg_showComponents: showComponents.checked
    property alias cfg_showLocationTip: showLocationTip.checked
    property alias cfg_showPriceTip: showPriceTip.checked

    Controls.CheckBox {
        id: useColor
        text: "Farben anzeigen"
        checked: true
    }
    Controls.CheckBox {
        id: showComponents
        text: "Beilagen anzeigen"
        checked: true
    }
    Controls.CheckBox {
        id: showLocationTip
        text: "Location-Info anzeigen (onhover)"
        checked: true
    }
    Controls.CheckBox {
        id: showPriceTip
        text: "Preis-Info anzeigen (onhover)"
        checked: true
    }
}
