import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts





    TabButton   {
                property int number
                    
                Button {
                    anchors {
                        right: parent.right
                    }
                    Text {
                        anchors.centerIn: parent
                        text:"X"
                        color: "red"
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
    
