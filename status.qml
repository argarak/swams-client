import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtBluetooth 5.3

Page {
    id: page

    width: 600
    height: 400

    title: qsTr("Status")

    ListView {
        id: statusList
        anchors.fill: parent
        model: ListModel {
            ListElement { title: "Current Temperature"; field: "label"; subField: "" }
            ListElement { title: "Current PH Level"; field: "label"; subField: "" }
            ListElement { title: "Current RTC Time"; field: "lastOnline"; subField: "" }
            ListElement { title: "RTC Offset"; field: "firmware"; subField: "version" }
            ListElement { title: "Firmware Version"; field: "firmware"; subField: "type" }
        }

        delegate: ItemDelegate {
            text: model.title
            width: parent.width
        }

        //valueText: getValueText(model.field, model.subField);

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
