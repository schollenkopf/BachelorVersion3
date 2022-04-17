import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS

Rectangle {
    color: JS.background
    id: mergeButtonRectangle
    anchors {
        left: parent.left
        right: parent.right
    }
    height: 0.15 * parent.height

    Column{
        anchors.fill: parent
        
        Row{
            id:main_buttons
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 0.5 * parent.height
    
            Button {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                width: 0.5 * parent.width
        
                id: one_event_action
                background: Rectangle {
                radius: 5
                anchors.fill: parent
                color: JS.button
                    Text{
                        anchors.centerIn: parent
                        text: "ONE EVENT ACTION"
                        color: JS.textColor
                        font.pixelSize: 10
                    }
                }
                onClicked: {
                    two_event_row.visible = false
                    one_event_row.visible = true
                }
            }
            Button {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                width: 0.5 * parent.width
        
                id: two_event_action
                background: Rectangle {
                radius: 5
                anchors.fill: parent
                color: JS.button
                    Text{
                        anchors.centerIn: parent
                        text: "TWO EVENT ACTION"
                        color: JS.textColor
                        font.pixelSize: 10
                    }
                }
                onClicked: {
                    one_event_row.visible = false
                    two_event_row.visible = true
                }
            }
        }
    
        Row{
            id:two_event_row
            visible: true
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 0.5 * parent.height
    
            Button {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                width: 0.5 * parent.width
        
                id: mergeButton
                
                background: Rectangle {
                radius: 5
                anchors.fill: parent
                color: JS.button
                    Text{
                        anchors.centerIn: parent
                        text: "MERGE"
                        color: JS.textColor
                        font.pixelSize: 30
                    }
                }
                onClicked: {
                    bi.running = true;
                    mergeButton.enabled = false
                    reculateButton.enabled = false
                    candidate_controller.candidateSelected(list.currentIndex, bar.currentIndex)
                    list.model.removeRows(0, list.model.rowCount() - 1);
                }
            }
        }
    
        Row{
            id:one_event_row
            visible: false
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 0.5 * parent.height
    
    
        }
    }


}