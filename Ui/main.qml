import QtQuick
import QtQuick.Controls.Basic


ApplicationWindow {
    visible: true
    width: 900
    height: 600
    
    x: screen.desktopAvailableWidth - width - 12
    y: screen.desktopAvailableHeight - height - 48
    title: "HelloApp"
    //Qt.FramelessWindowHint |
    flags:  Qt.Window
    property string nextmerge: "Loading"
    property QtObject yes_no_button
    Rectangle {
        anchors.fill: parent
        color: "#131424"
         Text {
                anchors {
                    top: parent.top
                }
                text: nextmerge
                font.pixelSize: 30
                color: "white"
            }
            Rectangle {
            id: frame
            clip: true
            width: 160
            height: 80
            border.color: "black"
            anchors.centerIn: parent
            
            
            

            ListView {
                anchors.fill: parent
                model: ListModel {
                            ListElement {
                                name: "Bill Smith"
                                number: "555 3264"
                            }
                            ListElement {
                                name: "John Brown"
                                number: "555 8426"
                            }
                            ListElement {
                                name: "Sam Wise"
                                number: "555 0473"
                            }
                        }
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                delegate: Item {
                    width: 160; height: 40
                    Column {
                        Text { text: '<b>Name:</b> ' + name }
                        Text { text: '<b>Number:</b> ' + number }
                    }
                }
                highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                focus: true
                ScrollBar.vertical: vbar
                
            }

            

            ScrollBar {
                id: vbar
                hoverEnabled: true
                active: hovered || pressed
                orientation: Qt.Vertical
                size: frame.height / content.height
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }

            
        }
        Row {
            anchors {
                    bottom: parent.bottom
                    
                }
            
            spacing: (parent.width - 2 * 100)
            Button {
                background: Rectangle {
                    color: "#65b53e"
                    border.width: 1
                    border.color: "#1a2614"
                    radius: 10
                }
                width: 100
                height: 50
                text: "YES"
                onClicked: yes_no_button.yes()
                
                                
            }
            Button {
                background: Rectangle {
                    color: "#b5463e"
                    border.width: 1
                    border.color: "#1a2614"
                    radius: 10
                }
                width: 100
                height: 50
                text: "NO"
                onClicked: yes_no_button.no()
            }
        
        }
        
        
        
        
    }
    Connections {
        target: yes_no_button
        function onUpdated(msg) {
            nextmerge = msg;
        }
    }


}
