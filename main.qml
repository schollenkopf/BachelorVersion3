import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS

Window {
    title: "Abstraction Tool"
    width: JS.width
    height: JS.height
    visible: true
    id: mainWindow

    Component {
        id: tabButton
        TabButton { }
    }

    Component {
        id: abstab
        AbstractionTab { }
    }

    Column {
        anchors.fill: parent
        TabBar {
            id: bar
            width: parent.width
            TabButton {
                text: qsTr("Original")
            }
            
        }


        StackLayout {  
            height: parent.height - bar.height
            width: parent.width
            currentIndex: bar.currentIndex
            id: stackLayout
            anchors {
                top: bar.bottom
                left: mainWindow.left
                right: mainWindow.right
                bottom: mainWindow.bottom
            }
            
                
            AbstractionTab {

            }
            
        }
    }

    


}
