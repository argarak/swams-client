import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: window
    width: 720
    height: 1280
    visible: true

    header: ToolBar {
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

        y: header.height
        width: window.width * 0.6
        height: window.height - header.height

        Label {
            text: "Content goes here!"
            anchors.centerIn: parent
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
    }
}
