

import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS



Rectangle {

                        
                        id: leftColumnRectangle
                        
                        
                        Image {
                            visible: mySwitch.position == false
                            fillMode: Image.PreserveAspectFit
                            id: processModel
                            anchors.fill: parent
                            source: "tab"+bar.currentIndex+"/abstractions_process_models/Abstraction"+slider.value+".png"
                        }
                        Image {
                            visible: mySwitch.position == true
                            fillMode: Image.PreserveAspectFit
                            id: abstractionTree
                            anchors.fill: parent
                            source: "tab"+bar.currentIndex+"/abstraction_tree/abstraction_tree"+slider.value+".png"
                        }

                    }