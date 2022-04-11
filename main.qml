import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Dialogs
import "constants.js" as JS

Window {
    title: "Abstraction Tool"
    width: JS.width
    height: JS.height
    visible: true
    id: mainWindow

    Column{
        anchors.fill: parent
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 100
            Button {
                anchors.fill: parent
                Text{
                    anchors.centerIn: parent
                    text: "Open: " + fileDialog.selectedFile 
                }
                onClicked: {
                    fileDialog.open()
                }
            }
            FileDialog {
                id: fileDialog
                title: "Please choose a datalog csv file"
                //currentFolder: "C:\\Users\\39327\\Desktop"
                nameFilters: ["Csv files (*.csv)"]
                onAccepted: {
                    loadbutton.enabled = true
                    console.log("You chose: " + selectedFile)
                    
                }
                onRejected: {
                    console.log("Canceled")
                    
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 100
            
            Button {
                id: loadbutton
                anchors.fill: parent
                Text {
                    anchors.centerIn: parent
                    text: "Load Abstraction Tool"
                }
                enabled: false
                onClicked: {
                    candidate_controller.init_abstraction_controller(fileDialog.selectedFile, "%Y-%m-%dT%H:%M:%S.%f", 6, 8114, ";", 3, 26, false, 5, 0)
                    table_model.first_setUp(6, 8114)
                    ld.source="AbstractionPage.qml"
                    candidate_controller.updater()
                }
            }
    
        }
    }
    Loader{
        id: ld;
        anchors.fill: parent;
    }

}
