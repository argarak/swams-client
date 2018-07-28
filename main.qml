import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtBluetooth 5.3

ApplicationWindow {
    id: window
    width: 720
    height: 1280
    visible: true

    property string state: "begin"

    property string remoteDeviceName: ""
    property bool serviceFound: false

    ErrorPopup {
        id: popup
    }

    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.FullServiceDiscovery

        onRunningChanged: {
            if (!btModel.running && page.state === "begin" && !serviceFound) {
                popup.errorText = "No service found. Make sure SWAMS is running and restart the app.";
                popup.open();
            }
        }

        onErrorChanged: {
            if (error != BluetoothDiscoveryModel.NoError && !btModel.running) {
                popup.errorText = "Discovery failed. Please ensure Bluetooth is avaliable.";
                popup.open();
            }
        }

        onServiceDiscovered: {
            if (serviceFound)
                return

            serviceFound = true
            console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);

            remoteDeviceName = service.deviceName
            socket.setService(service)
        }

        uuidFilter: "00001101-0000-1000-8000-00805F9B34FB"
    }

    BluetoothSocket {
        id: socket
        connected: true

        onSocketStateChanged: {
            switch (socketState) {
            case BluetoothSocket.Unconnected:
            case BluetoothSocket.NoServiceSet:
                popup.errorText = "Connection failed. Please restart the app.";
                popup.open();
                page.state = "begin";
                break;
            case BluetoothSocket.Connected:
                console.log("Bluetooth connected!");
                page.state = "monitor";
                break;
            case BluetoothSocket.Connecting:
            case BluetoothSocket.ServiceLookup:
            case BluetoothSocket.Closing:
            case BluetoothSocket.Listening:
            case BluetoothSocket.Bound:
                break;
            }
        }

        onStringDataChanged: {
            console.log(socket.stringData);
        }
    }

    header: ToolBar {
        background: Rectangle {
            implicitHeight: 40
            color: "#f44336"
        }

        RowLayout {
            anchors.fill: parent

            Label {
                text: "Status"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                icon.source: "icons/navigation_menu.svg"
                onClicked: drawer.open()
            }
        }
    }

    Drawer {
        id: drawer

        edge: Qt.RightEdge
        width: window.width * 0.6
        height: window.height

        Label {
            text: "Content goes here!"
            anchors.centerIn: parent
        }
    }

    StackView {
        id: stack
        initialItem: "status.qml"
        anchors.fill: parent
    }
}
