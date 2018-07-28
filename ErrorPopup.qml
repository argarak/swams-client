import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4

Popup {
    id: popup
    x: 100
    y: 100
    width: 200
    height: 200
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    property string errorText: "Sorry! This default error message has not been changed."

    ColumnLayout {
        Text {
            text: errorText
        }

        Button {
            text: "OK"
            onClicked: popup.close()
        }
    }
}
