import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    title: "HelloApp"
    width: 900
    height: 600
    visible: true
    id: mainWindow

    Rectangle {
        anchors.fill: parent
        id: listRectangle

        ListView {
            id: list
            model: candidate_list_model
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            delegate: Item {
                width: list.width; height: 40
                Column {
                    Text { text: display }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { list.currentIndex = index; 
                                 bi.running = true; 
                                 candidate_controller.candidateSelected(index)
                                 list.model.removeRows(0, list.model.rowCount() - 1);
                                 }
                }
            }
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true
            ScrollBar.vertical: vbar

            ScrollBar {
                id: vbar
                hoverEnabled: true
                active: hovered || pressed
                orientation: Qt.Vertical
                //size: listRectangle.height / ((list.model.rowCount() + 1) * 40)
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }

        }

        BusyIndicator {
            id:bi
            anchors.fill: parent
            //visible: false
            running: false
        }

        
    
    }

    Connections {
        target: candidate_controller
        function onUpdated(l, len) {
            console.log(len + 1)
            list.model.insertRows(0, len, l);
            vbar.size = listRectangle.height / ((list.model.rowCount()) * 40)
            bi.running = false
        }
    }


}
