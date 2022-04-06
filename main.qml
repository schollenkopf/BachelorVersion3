import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    title: "HelloApp"
    width: 900
    height: 600
    visible: true
    id: mainWindow

    Row {

        id:mainRow
        anchors.fill: parent

        Rectangle {

            id: leftColumnRectangle
            anchors{
                top:mainRow.top
                bottom:mainRow.bottom
            }
            width: 600
            Image {
                id: processModel
                anchors.fill: parent
                source: "abstractions_process_models/Abstraction0.png"
            }

        }

        Rectangle {

            id : rightColumnRectangle
            anchors{
                top:mainRow.top
                bottom:mainRow.bottom
            }
            width: 300

            Column{

                id : rightColumn
                anchors.fill: parent


                Rectangle{

                    anchors {
                                left: rightColumn.left
                                right: rightColumn.right
                            }
                    height : 350

                    id : mainMergeRectangle

                    Column{

                        id : mergeColumn
                        anchors.fill: parent

                        Rectangle {
                            //anchors.fill: parent
                            anchors {
                                left: mergeColumn.left
                                right: mergeColumn.right
                            }
                            height : 300
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
                                        onClicked: { list.currentIndex = index }
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
                                running: true
                            }
                        
                        }

                        Rectangle {
                            
                            id: mergeButtonRectangle
                            anchors {
                                left: mergeColumn.left
                                right: mergeColumn.right
                            }
                            height : 50

                            Button {
                                id : mergeButton
                                anchors.fill: parent
                                Text{
                                    text: "MERGE"
                                    color: "black"
                                    font.pixelSize: 30
                                }
                                onClicked: { 
                                            bi.running = true; 
                                            candidate_controller.candidateSelected(list.currentIndex)
                                            list.model.removeRows(0, list.model.rowCount() - 1);
                                            }
                            }
                        }

                    }
                }

                Rectangle{

                    anchors {
                                left: rightColumn.left
                                right: rightColumn.right
                            }
                    height : 250

                    id : abstractionTreeRectangle

                    Text{
                        text: "ABSTRACTION TREE"
                        color: "black"
                        font.pixelSize: 40
                    }

                }

            }
        }
    
    }

    Connections {
        target: candidate_controller
        function onUpdated(l, len, process_model_string) {
            console.log(len + 1)
            list.model.insertRows(0, len, l);
            vbar.size = listRectangle.height / ((list.model.rowCount()) * 40);
            processModel.source =   process_model_string;
            bi.running = false
        }
    }


}
