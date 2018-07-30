import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtBluetooth 5.3
import QtCharts 2.2

import "convert.js" as Convert
import "monitor.js" as Monitor

ApplicationWindow {
    id: window
    width: 720
    height: 1280
    visible: true

    property string state: "begin"

    property string remoteDeviceName: ""
    property bool serviceFound: false

    property real phValue: 0.0
    property real tempValue: 0.0
    property string timeValue: ""

    property int timeIndex: 0

    property bool monitoring: false

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
            Convert.convertFromUART(socket.stringData);
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

    Page {
        id: page

        width: 600
        height: 400

        title: qsTr("Status")

        ScrollView {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.topMargin: 15

            Column {
                spacing: 20

                Label {
                    text: "Current Status"
                    font.pixelSize: 24
                    font.bold: true
                }

                Pane {
                    width: parent.width
                    height: 48

                    Label {
                        id: phText
                    }
                }

                Pane {
                    width: parent.width
                    height: 48

                    Label {
                        id: tempText
                    }
                }

                Pane {
                    width: parent.width
                    height: 48

                    Label {
                        id: timeText
                    }
                }

                Label {
                    text: "Monitoring"
                    font.pixelSize: 24
                    font.bold: true
                }

                Button {
                    id: monitoringButton
                    text: "Start Monitoring"
                    onClicked: {
                        if(!monitoring) {
                            monitoringButton.text = "Stop Monitoring";
                            monitoring = true;
                        } else {
                            monitoringButton.text = "Start Monitoring";
                            monitoring = false;
                        }
                    }
                }

                ChartView {
                    id: tempView

                    antialiasing: true
                    width: 300
                    height: 250

                    theme: ChartView.ChartThemeDark

                    LineSeries {
                        id: tempChart
                        name: "Temperature"
                        color: "#f44336"

                        Component.onCompleted: {
                            for(var i = 0; i < 15; i++) {
                                tempChart.append(i, i * 5);
                            }
                        }
                    }

                    Timer {
                        id: monitorTimer
                        interval: 5000;
                        repeat: true;
                        running: true;
                        onTriggered: {
                            if(monitoring) {
                                console.log("Adding to chart!!!");
                                console.log(timeIndex * 5, Convert.globalTemp);

                                timeIndex++;
                                tempChart.append(timeIndex * 5, timeIndex);
                            }
                        }
                    }
                }

                ChartView {
                    id: phView

                    antialiasing: true
                    width: 300
                    height: 250

                    theme: ChartView.ChartThemeDark

                    LineSeries {
                        id: phChart
                        name: "pH Level"
                        color: "#03A9F4"
                    }
                }
            }
        }

        Timer {
            interval: 100;
            repeat: true;
            running: true;
            onTriggered: {
                timeText.text = qsTr("Current RTC Time: " + Convert.globalTime.toLocaleString("en-GB"));
                tempText.text = qsTr("Current Temperature: " + Convert.globalTemp + "°C");
                phText.text = qsTr("Current pH Value: " + Convert.globalPH);
            }
        }
    }
}
