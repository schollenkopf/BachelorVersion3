import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    title: "Abstraction Tool"
    width: 900
    height: 600
    visible: true
    id: mainWindow
    
    Row {

        id:mainRow
        anchors.fill: parent

        Column {
            id: processmodelcolumn
            anchors{
                    top:mainRow.top
                    bottom:mainRow.bottom
                }
                width: 600
            Rectangle{
                id: titlRectangle
                height: 50
                anchors{
                    left:parent.left
                    right:parent.right
                }
                Text{
                    text: "Abstraction Level: "+slider.value
                    anchors.centerIn: parent      
                    color: "black"
                    font.pixelSize: 15
                }
            }

            Rectangle{
                id: topRowRectangle
                height: 50
                anchors{
                    left:parent.left
                    right:parent.right
                }
                
                Row{
                    id: topLeftRow
                    anchors.fill: parent
                
                    Rectangle {
                        width: 500
                        id: sliderRectangle
                        anchors{
                            top:parent.top
                            bottom:parent.bottom
                        }

                            Slider {
                                    
                                    snapMode: Slider.SnapOnRelease
                                    id: slider
                                    anchors.fill: parent
                                    from: 0
                                    value: 0
                                    to: 1
                                    stepSize: 1
                            }

                    }
                    Rectangle {
                        id: toggleRectangle
                        width: 100
                        anchors{
                            top:parent.top
                            bottom:parent.bottom
                        }
                        Item {
                            anchors.fill: parent
                            Switch {
                                anchors.fill: parent
                                id: mySwitch
                                
                            }
                            
                        }
                    }
                }

            }



            Rectangle {

                height: 500
                id: leftColumnRectangle
                anchors{
                    left:processmodelcolumn.left
                    right:processmodelcolumn.right
                }
                
                Image {
                    visible: mySwitch.position == false
                    fillMode: Image.PreserveAspectFit
                    id: processModel
                    anchors.fill: parent
                    source: "abstractions_process_models/Abstraction"+slider.value+".png"
                }
                Image {
                    visible: mySwitch.position == true
                    fillMode: Image.PreserveAspectFit
                    id: abstractionTree
                    anchors.fill: parent
                    source: "abstraction_tree/abstraction_tree"+slider.value+".png"
                }

            }
        }
        

        Rectangle {

            id : rightColumnRectangle
            anchors{
                top:mainRow.top
                bottom:mainRow.bottom
            }
            width: 300

            Column{

                id : rightColumn
                anchors.fill: parent


                Rectangle{

                    anchors {
                                left: rightColumn.left
                                right: rightColumn.right
                            }
                    height : 350

                    id : mainMergeRectangle

                    Column{

                        id : mergeColumn
                        anchors.fill: parent

                        Rectangle {
                            //anchors.fill: parent
                            anchors {
                                left: mergeColumn.left
                                right: mergeColumn.right
                            }
                            height : 300
                            id: listRectangle

                            ListView {
                                id: list
                                model: candidate_list_model
                                anchors.fill: parent
                                flickableDirection: Flickable.VerticalFlick
                                boundsBehavior: Flickable.StopAtBounds
                                delegate: Item {
                                    width: list.width; height: 40
                                    
                                    Text { 
                                        anchors.verticalCenter: parent.verticalCenter 
                                        anchors.left: parent.left
                                        text: display 
                                        color: "black"
                                        font.pixelSize: 10
                                        }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: { list.currentIndex = index }
                                    }
                                }
                                highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                                focus: true
                                ScrollBar.vertical: vbar

                                ScrollBar {
                                    id: vbar
                                    hoverEnabled: true
                                    active: hovered || pressed
                                    orientation: Qt.Vertical
                                    //size: listRectangle.height / ((list.model.rowCount() + 1) * 40)
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                }

                            }

                            BusyIndicator {
                                id:bi
                                anchors.fill: parent
                                //visible: false
                                running: true
                            }
                        
                        }

                        Rectangle {
                            
                            id: mergeButtonRectangle
                            anchors {
                                left: mergeColumn.left
                                right: mergeColumn.right
                            }
                            height : 50

                            Button {
                                
                                id : mergeButton
                                anchors.fill: parent
                                Text{
                                    anchors.centerIn: parent
                                    text: "MERGE"
                                    color: "black"
                                    font.pixelSize: 30
                                }
                                onClicked: { 
                                            bi.running = true; 
                                            mergeButton.enabled = false
                                            reculateButton.enabled = false
                                            candidate_controller.candidateSelected(list.currentIndex, [{"Median": firstMetricSlider.value},{"Stdev":secondMetricSlider.value},{"Direclty Follows Order=false":thirdMetricSlider.value}])
                                            list.model.removeRows(0, list.model.rowCount() - 1);
                                            }
                            }
                        }

                    }
                }

                Rectangle{

                    anchors {
                                left: rightColumn.left
                                right: rightColumn.right
                            }
                    height : 250

                    id : abstractionTreeRectangle

                    Column {
                        anchors.fill: parent
                        id: predictorColumn

                        Rectangle {
                            id: metricsBoundingRectangle
                            anchors {
                                left: predictorColumn.left
                                right: predictorColumn.right
                            }
                            height : 210

                            Column {
                                id: metricsColumn
                                anchors.fill: parent

                                Rectangle {
                                    id: firstMetric
                                    anchors {
                                        left: metricsColumn.left
                                        right: metricsColumn.right
                                    }
                                    height: 70
                                    Row {
                                        id: firstMetricRow
                                        anchors.fill: parent

                                        Rectangle {
                                            width: 200
                                            id: firstMetricSliderRectangle
                                            anchors {
                                                top: firstMetricRow.top
                                                bottom: firstMetricRow.bottom
                                            }
                                            Slider {
                                                
                                                id: firstMetricSlider
                                                anchors.fill: parent
                                                from: 0
                                                value: 0.5
                                                to: 1
                                                stepSize: 0.01
                                                
                                            }
                                        }

                                        Rectangle{
                                            width: 100
                                            id: firstMetricTextRectangle
                                            anchors {
                                                top: firstMetricRow.top
                                                bottom: firstMetricRow.bottom
                                            }
                                            Text {
                                                anchors.centerIn: parent
                                                color: "black"
                                                font.pixelSize: 10
                                                text: "Median: "+firstMetricSlider.value
                                            }
                                        }
                                        
                                    }
                                }
                                
                                Rectangle {
                                    id: secondMetric
                                    anchors {
                                        left: metricsColumn.left
                                        right: metricsColumn.right
                                    }
                                    height: 70
                                    Row {
                                        id: secondMetricRow
                                        anchors.fill: parent

                                        Rectangle {
                                            width: 200
                                            id: secondMetricSliderRectangle
                                            anchors {
                                                top: secondMetricRow.top
                                                bottom: secondMetricRow.bottom
                                            }
                                            Slider {
                                                
                                                id: secondMetricSlider
                                                anchors.fill: parent
                                                from: 0
                                                value: 0.5
                                                to: 1
                                                stepSize: 0.01
                                                
                                            }
                                        }

                                        Rectangle{
                                            width: 100
                                            id: secondMetricTextRectangle
                                            anchors {
                                                top: secondMetricRow.top
                                                bottom: secondMetricRow.bottom
                                            }
                                            Text {
                                                anchors.centerIn: parent
                                                color: "black"
                                                font.pixelSize: 10
                                                text: "Stdev: "+secondMetricSlider.value
                                            }
                                        }
                                        
                                    }
                                }

                                Rectangle {
                                    id: thirdMetric
                                    anchors {
                                        left: metricsColumn.left
                                        right: metricsColumn.right
                                    }
                                    height: 70
                                    Row {
                                        id: thirdMetricRow
                                        anchors.fill: parent

                                        Rectangle {
                                            width: 200
                                            id: thirdMetricSliderRectangle
                                            anchors {
                                                top: thirdMetricRow.top
                                                bottom: thirdMetricRow.bottom
                                            }
                                            Slider {
                                                
                                                id: thirdMetricSlider
                                                anchors.fill: parent
                                                from: 0
                                                value: 0.5
                                                to: 1
                                                stepSize: 0.01
                                                
                                            }
                                        }

                                        Rectangle{
                                            width: 100
                                            id: thirdMetricTextRectangle
                                            anchors {
                                                top: thirdMetricRow.top
                                                bottom: thirdMetricRow.bottom
                                            }
                                            Text {
                                                anchors.centerIn: parent
                                                color: "black"
                                                font.pixelSize: 10
                                                text: "DirectlyFollows: "+thirdMetricSlider.value
                                            }
                                        }
                                        
                                    }
                                }
                            }

                        }

                        Rectangle {
                            id: reculateButtonRectangle
                            anchors {
                                left: predictorColumn.left
                                right: predictorColumn.right
                            }
                            height : 40
                            Button {
                                id: reculateButton
                                anchors.fill: parent
                                onClicked: { 
                                            bi.running = true; 
                                            mergeButton.enabled = false
                                            reculateButton.enabled = false
                                            candidate_controller.recalculateCandidates(slider.value,[{"Median": firstMetricSlider.value},{"Stdev":secondMetricSlider.value},{"Direclty Follows Order=false":thirdMetricSlider.value}])
                                            list.model.removeRows(0, list.model.rowCount() - 1);
                                            slider.to = slider.value
                                            
                                            }

                                Text{
                                    anchors.centerIn: parent
                                    text: "RECALCULATE"
                                    color: "black"
                                    font.pixelSize: 30
                                }
                            }
                        }


                    }

                }

            }
        }
    
    }

    Connections {
        target: candidate_controller
        function onUpdated(l, len, process_model_string,abstraction_level) {
            console.log(len + 1)
            list.model.insertRows(0, len, l);
            vbar.size = listRectangle.height / ((list.model.rowCount()) * 40);
            //processModel.source =   process_model_string;
            bi.running = false
            slider.to = abstraction_level
            slider.value = abstraction_level
            mergeButton.enabled = true
            reculateButton.enabled = true
            if (len==0) {
                mergeButton.enabled = false;
            }
            
        }
    }


}
