import QtQuick

Rectangle {
    width: 360
    height: 360
    Text {
        anchors.centerIn: parent
        text: "Main Page"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            ld.source="main.qml"
        }
    }
    Loader{
        id:ld;
        anchors.fill: parent;
    }
}