import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS




    
    TabButton   {
                property int number
                property string name
                background: Row {


                anchors.fill: parent
                Rectangle {
                        width: parent.width - 5
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        color: enabled? JS.selectedtab : JS.unselectedtab
                        
                    }
                Rectangle {
                    width: 5
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        color: "white"

                }
                }
                contentItem: Text {
                    text: parent.name
                    color: JS.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                
                Button {
                    height: parent.height
                    anchors {
                        right: parent.right
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        color: enabled? JS.selectedtab : JS.unselectedtab
                    }
                    contentItem: Text {
                        anchors.centerIn: parent
                        text:"X |"
                        color: JS.textColor
                    }
                    onClicked: { 
                                var tabs = bar.tabs;
                                console.log(tabs.length)
                                var newtabs = []
                                for (var i = 0;i<tabs.length;i++){
                                    console.log("hi")
                                    console.log(tabs[i])
                                    
                                    if (tabs[i] == number){
                                        console.log("jojo")
                                        var _removeItem = bar.itemAt(i);
                                        bar.removeItem(_removeItem);
                                        stackLayout.children[i].destroy();
                                        candidate_controller.deletetab(i)
                                        
                                    }else {
                                        newtabs = newtabs.concat(tabs[i])
                                    }
                                }
                                bar.deleted = bar.deleted + 1
                                bar.tabs = newtabs
                                console.log(bar.tabs)
                                
                                
                                }

                }
                }  
    
