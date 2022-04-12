

import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS



Rectangle {

                        color: JS.background
                        id: leftColumnRectangle
                        
                        
                        Image {
                            visible: mySwitch.position == 0
                            fillMode: Image.PreserveAspectFit
                            id: processModel
                            anchors.fill: parent
                            source: "tab"+bar.currentIndex+"/abstractions_process_models/Abstraction"+slider.value+".png"
                        }
                        Image {
                            visible: mySwitch.position == 1
                            fillMode: Image.PreserveAspectFit
                            id: abstractionTree
                            anchors.fill: parent
                            source: "tab"+bar.currentIndex+"/abstraction_tree/abstraction_tree"+slider.value+".png"
                        }

                        
                        

                        TableView {
                            id: tableView
                            visible: mySwitch.position == 2
                            clip: true
                            columnWidthProvider: function (column) { return 150; }
                            rowHeightProvider: function (column) { return 60; }
                            
                            topMargin: columnsHeader.implicitHeight
                            height: 200
                            anchors.fill: parent
                                                            
                            model: table_model
                            delegate: Rectangle {
                                //color: parseFloat(display) > 50 ? 'green' : 'red'
                                Text {
                                    text: display
                                    clip: true
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    //color: 'white'
                                    font.pixelSize: 15
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Rectangle { // mask the headers
                                z: 3
                                color: "#222222"
                                y: tableView.contentY
                                x: tableView.contentX
                                width: tableView.leftMargin
                                height: tableView.topMargin
                            }

                            Row {
                                id: columnsHeader
                                y: tableView.contentY
                                z: 2
                                Repeater {
                                    model: tableView.columns > 0 ? tableView.columns : 1
                                    Label {
                                        width: tableView.columnWidthProvider(modelData)
                                        height: 35
                                        text: table_model.headerData(modelData, Qt.Horizontal)
                                        color: '#aaaaaa'
                                        font.pixelSize: 15
                                        padding: 10
                                        verticalAlignment: Text.AlignVCenter

                                        background: Rectangle { color: "#333333" }
                                    }
                                }
                            }/**
                            Column {
                                id: rowsHeader
                                x: tableView.contentX
                                z: 2
                                Repeater {
                                    model: tableView.rows > 0 ? tableView.rows : 1
                                    Label {
                                        width: 40
                                        height: tableView.rowHeightProvider(modelData)
                                        text: table_model.headerData(modelData, Qt.Vertical)
                                        color: '#aaaaaa'
                                        font.pixelSize: 15
                                        padding: 10
                                        verticalAlignment: Text.AlignVCenter

                                        background: Rectangle { color: "#333333" }
                                    }
                                }
                            }**/

                            ScrollIndicator.horizontal: ScrollIndicator { }
                            ScrollIndicator.vertical: ScrollIndicator { }
                        }

                    }