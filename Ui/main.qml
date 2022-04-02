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
    property QtObject button_yes
    property QtObject button_no
    property QtObject backend
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
                onClicked: button_yes.yes()
                
                                
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
                onClicked: button_no.no()
            }
        
        }
        
        
        
    }
    Connections {
        target: backend
        function onUpdated(msg) {
            nextmerge = msg;
        }
    }


}
