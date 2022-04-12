import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS




    
    TabButton   {
                property int number
                property string name
                background: Rectangle {
                        width: parent.width - 5
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        
                        color: bar.tabs[bar.currentIndex] == number ? JS.selectedtab : JS.unselectedtab
                        
                    }
                
                
                contentItem: Row {
                                //anchors {
                                //        top: parent.top
                                //        bottom: parent.bottom
                                //    }
                                
                                width: parent.width - 20
                                Rectangle {
                                    width: parent.width - 20
                                    anchors {
                                        top: parent.top
                                        bottom: parent.bottom
                                    }
                                    color: bar.tabs[bar.currentIndex] == number ? JS.selectedtab : JS.unselectedtab
                                Text {
                                    text: name
                                    color: JS.textColor
                                    horizontalAlignment: Text.AlignHCenter
                                    
                                }
                                }
                                
                                Button {
                                    width: 15
                                    anchors {
                                        top: parent.top
                                        bottom: parent.bottom
                                    }
                                    background: Rectangle {
                                        anchors.fill: parent
                                        
                                        color: bar.tabs[bar.currentIndex] == number ? JS.selectedtab : JS.unselectedtab
                                    }
                                    
                                    
                                    icon.source: "icons/close.webp"
                                    icon.width: 12
                                    icon.height: 12
                                    icon.color: hovered? JS.iconhovered : JS.icon
                                    //icon.color: hovered? JS.iconhovered : JS.icon
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
                
                }  
    
