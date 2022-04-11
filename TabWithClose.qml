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
                                console.log(bar.Item)
                                var _removeItem = bar.itemAt(number);
                                bar.removeItem(_removeItem);
                                stackLayout.children[number].destroy()
                                }

                }
                }  
    
