import QtQuick 
import QtQuick.Controls 
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS

Rectangle{
    anchors.fill: parent

Component {
        id: tabbutton
        TabWithClose { }
    }
    

    Component {
        id: abstab
        AbstractionTab { }
    }

    
    Column {
                        
                            anchors.fill: parent
                            Row {
                                id: tabbarrow
                                height: 20
                                anchors {
                                left: parent.left
                                right: parent.right
                            }
                                TabBar {
                                    id: bar
                                    width: parent.width - 50
                                    TabButton {
                                        text: qsTr("Original")
                                    }
                                    onCurrentIndexChanged:{ 
                                        bi.running = true
                                        mergeButton.enabled = false
                                        reculateButton.enabled = false
                                        list.model.removeRows(0, list.model.rowCount() - 1);
                                        candidate_controller.changedtab(bar.currentIndex,[{"Median": firstMetricSlider.value},{"Stdev":secondMetricSlider.value},{"Direclty Follows Order=false":thirdMetricSlider.value}])
                                        
                                    }
                                    
                                }
                                Rectangle {
                                                    width: 50
                                                    anchors{
                                                        top:parent.top
                                                        bottom:parent.bottom
                                                    }
                                                    Button {
                                                        id: splitUpButton
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            var tabbut = tabbutton.createObject(bar, {number: bar.count, text: "Tab " + bar.count});
                                                            var tab = abstab.createObject(stackLayout);
                                                            
                                                            
                                                            candidate_controller.addTab(bar.count-1,[{"Median": firstMetricSlider.value},{"Stdev":secondMetricSlider.value},{"Direclty Follows Order=false":thirdMetricSlider.value}]);
                                                            bar.addItem(tabbut);
                                                            stackLayout.addItem(tab);

                                                        }
                                                        Text {
                                                            
                                                            anchors.centerIn: parent
                                                            text: "+"
                                                            color: "black"
                                                            font.pixelSize: 20
                                                        }
                                                    }
                                                }

                            }

    Row {
                
                id:mainRow
                height: parent.height - 20
                anchors{
                    left: parent.left
                    right: parent.right
                }

                Column {
                    id: processmodelcolumn
                    anchors{
                            top:parent.top
                            bottom:parent.bottom
                        }
                        width: parent.width - 250
                    Rectangle{
                        id: titlRectangle
                        height:  0.1 * parent.height
                        anchors{
                            left:parent.left
                            right:parent.right
                        }
                        Text{
                            text: "Abstraction Level: "+ slider.value
                            anchors.centerIn: parent      
                            color: JS.textColor
                            font.pixelSize: 15
                        }
                    }

                    Rectangle{
                        id: topRowRectangle
                        height: 0.1 * parent.height
                        anchors{
                            left:parent.left
                            right:parent.right
                        }
                        
                        Row{
                            id: topLeftRow
                            anchors.fill: parent
                        
                            Rectangle {
                                width: 0.8 * parent.width
                                id: sliderRectangle
                                anchors{
                                    top:parent.top
                                    bottom:parent.bottom
                                }

                                    Slider {
                                            
                                            snapMode: Slider.SnapOnRelease
                                            id: slider
                                            anchors{
                                                top:parent.top
                                                bottom:parent.bottom
                                                right: parent.right
                                            }
                                            width: 0.95 * parent.width
                                            from: 0
                                            value: 0
                                            to: 1
                                            stepSize: 1
                                            onValueChanged: {
                                                table_model.setDataFrame(bar.currentIndex, slider.value)
                                            }
                                    }

                            }
                            
                                
                                
                                    
                            
                                
                                
                            
                            Rectangle {
                                width: 0.2 * parent.width
                                anchors{
                                    top:parent.top 
                                    bottom:parent.bottom
                                }
                                /**
                                Item {
                                    anchors.fill: parent
                                    Switch {
                                        anchors.fill: parent
                                        id: mySwitch
                                        
                                    }
                                
                                }**/
                                Row{
                                    id: mySwitch
                                    anchors.fill: parent
                                    property int position: 0
                                    Button {
                                        
                                        id : pm_button
                                        anchors{
                                            top:parent.top 
                                            bottom:parent.bottom
                                        }
                                        width : parent.width * 0.34
                                        Text{
                                            text: "PM"
                                        }
                                        
                                        onClicked: { 
                                                    mySwitch.position = 0
                                                    }
                                    }
                                    Button {
                                        
                                        id : at_button
                                        anchors{
                                            top:parent.top 
                                            bottom:parent.bottom
                                        }
                                        width : parent.width * 0.33
                                        Text{
                                            text: "AT"
                                        }
                                        
                                        onClicked: { 
                                                    mySwitch.position = 1
                                                    }
                                    }
                                    Button {
                                        
                                        id : dl_button
                                        anchors{
                                            top:parent.top 
                                            bottom:parent.bottom
                                        }
                                        width : parent.width * 0.33
                                        Text{
                                            text: "DL"
                                        }
                                        
                                        onClicked: { 
                                                    mySwitch.position = 2
                                                    }
                                    }

                                }
                            }
                        }

                    }



        Rectangle{      
            height: 0.75 * parent.height
            anchors {
                left: parent.left
                right: parent.right
            }      
        
        StackLayout {  
            
            currentIndex: bar.currentIndex
            id: stackLayout
            anchors.fill: parent
            
                
            AbstractionTab {
            }
            
        }

        }
    
                }
                

                Rectangle {

                    id : rightColumnRectangle
                    anchors{
                        top:mainRow.top
                        bottom:mainRow.bottom
                    }
                    width: 250

                    Column{

                        id : rightColumn
                        anchors.fill: parent


                        Rectangle{

                            anchors {
                                        left: rightColumn.left
                                        right: rightColumn.right
                                    }
                            height : 0.58 * parent.height

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
                                    height : 0.85 * parent.height
                                    id: listRectangle

                                    ListView {
                                        id: list
                                        model: candidate_list_model
                                        anchors.fill: parent
                                        flickableDirection: Flickable.VerticalFlick
                                        boundsBehavior: Flickable.StopAtBounds
                                        clip: true
                                        delegate: Item {
                                            width: list.width; height: 40
                                            
                                            
                                                Text { 
                                                anchors.verticalCenter: parent.verticalCenter 
                                                anchors.left: parent.left
                                                text: display 
                                                color: JS.textColor
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
                                    height : 0.15 * parent.height

                                    Button {
                                        
                                        id : mergeButton
                                        anchors.fill: parent
                                        Text{
                                            anchors.centerIn: parent
                                            text: "MERGE"
                                            color: JS.textColor
                                            font.pixelSize: 30
                                        }
                                        onClicked: { 
                                                    bi.running = true; 
                                                    mergeButton.enabled = false
                                                    reculateButton.enabled = false
                                                    candidate_controller.candidateSelected(list.currentIndex, bar.currentIndex, [{"Median": firstMetricSlider.value},{"Stdev":secondMetricSlider.value},{"Direclty Follows Order=false":thirdMetricSlider.value}])
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
                            height : 0.42 * parent.height

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
                                    height : 0.9 * parent.height

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
                                                    width: 150
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
                                                    width: 150
                                                    id: firstMetricTextRectangle
                                                    anchors {
                                                        top: firstMetricRow.top
                                                        bottom: firstMetricRow.bottom
                                                    }
                                                    Text {
                                                        anchors.centerIn: parent
                                                        color: JS.textColor
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
                                                    width: 150
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
                                                    width: 150
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
                                                    width: 150
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
                                                    width: 150
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
                                    height : 0.1 * parent.height
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
            
            Connections {
        target: candidate_controller
        function onUpdated(l, len, process_model_string,abstraction_level) {
            //console.log(len + 1)
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

     Connections {
        target: candidate_controller
        function onTabchanged(abstraction_level,m1,m2,m3) { 
            slider.to = abstraction_level
            slider.value = abstraction_level
            firstMetricSlider.value = m1 
            secondMetricSlider.value = m2
            thirdMetricSlider.value = m3
            //console.log("connected")
            
        }
    }
            
            }



    


}
}