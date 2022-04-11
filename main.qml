import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS

Window {
    title: "Abstraction Tool"
    width: JS.width
    height: JS.height
    visible: true
    id: mainWindow

    Rectangle {
    anchors.fill: parent
    Text {
        anchors.centerIn: parent
        text: "Main Page"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            ld.source="AbstractionPage.qml"
            candidate_controller.updater()
        }
    }
    Loader{
        id:ld;
        anchors.fill: parent;
    }
}

}
