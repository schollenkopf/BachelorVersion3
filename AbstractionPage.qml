import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import "constants.js" as JS
Window{
    title: "Abstraction Tool"
    width: JS.width
    height: JS.height
    visible: true
    id: mainWindow
    //anchors.fill: parent
    color: JS.background
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
                property variant tabs: [0]
                property int deleted: 0
                id: bar
                width: parent.width - 50
                background: Rectangle {
                color: JS.tabborder
            }
            TabButton {
                contentItem: Text {
                text: "Original"
                color: JS.textColor
                horizontalAlignment: Text.AlignHCenter

            }
            background: Rectangle {
            width: parent.width - 5
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            color: bar.tabs[bar.currentIndex] == 0 ? JS.selectedtab: JS.unselectedtab
        }

    }
    onCurrentIndexChanged: {
        bi.running = true
        mergeButton.enabled = false
        reculateButton.enabled = false
        list.model.removeRows(0, list.model.rowCount() - 1);
        candidate_controller.changedtab(bar.currentIndex)

    }

}
Rectangle {
    width: 50


    anchors{
        top: parent.top
        bottom: parent.bottom
    }
    Button {
        background: Rectangle {
        color: JS.selectedtab
    }
    id: splitUpButton
    anchors.fill: parent
    onClicked: {
        var tabbut = tabbutton.createObject(bar, {number: bar.count + bar.deleted, name: "Tab " + (bar.count + bar.deleted)});
        var tab = abstab.createObject(stackLayout);

        bar.tabs = bar.tabs.concat(bar.count + bar.deleted - 1)
        console.log(bar.tabs)
        candidate_controller.addTab(bar.count-1);
        bar.addItem(tabbut);
        stackLayout.addItem(tab);

    }
    Text {

        anchors.centerIn: parent
        text: "+"
        color: JS.iconhovered
        font.pixelSize: 20
    }
}
}


}

Row {

    id: mainRow
    height: parent.height - 20
    anchors{
        left: parent.left
        right: parent.right
    }

    Column {
        id: processmodelcolumn
        anchors{
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width - 250
        Rectangle{
            color: JS.background
            id: titlRectangle
            height: 0.05 * parent.height
            anchors{
                left: parent.left
                right: parent.right
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
            height: 0.15 * parent.height
            color: JS.background
            anchors{
                left: parent.left
                right: parent.right
            }

            Row{
                id: topLeftRow
                anchors.fill: parent

                Rectangle {
                    color: JS.background
                    width: 0.7 * parent.width
                    id: sliderRectangle
                    anchors{
                        top: parent.top
                        bottom: parent.bottom
                    }

                    Slider {

                        snapMode: Slider.SnapOnRelease
                        id: slider
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
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
                    color: JS.background
                    width: 0.3 * parent.width
                    anchors{
                        top: parent.top
                        bottom: parent.bottom
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

                            id: pm_button
                            anchors{
                                top: parent.top
                                bottom: parent.bottom
                            }
                            width: parent.width * 0.34
                            background: Rectangle {
                            radius: 5
                            anchors.fill: parent
                            color: JS.button

                        }
                        icon.name: "table"
                        icon.source: "icons/process.png"
                        icon.width: 50
                        icon.height: 50


                        icon.color: if (mySwitch.position == 0){
                        JS.selected
                    }
else if (pm_button.hovered) 
                {
                        JS.iconhovered
                    }else {
                    JS.icon
                }
                onClicked: {
                    mySwitch.position = 0
                }
            }
            Button {

                id: at_button
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                }
                width: parent.width * 0.33

                background: Rectangle {
                radius: 5
                anchors.fill: parent
                color: JS.button

            }
            icon.name: "tree"
            icon.source: "icons/tree.webp"
            icon.width: 50
            icon.height: 30


            icon.color: if (mySwitch.position == 1){
            JS.selected
        }
else if (at_button.hovered) 
    {
            JS.iconhovered
        }else {
        JS.icon
    }

    onClicked: {
        mySwitch.position = 1
    }
}

Button {

    id: dl_button

    anchors{
        top: parent.top
        bottom: parent.bottom
    }
    width: parent.width * 0.33
    background: Rectangle {
    radius: 5
    anchors.fill: parent
    color: JS.button


}
icon.name: "table"
icon.source: "icons/tablegimp.png"
icon.width: 50
icon.height: 50
icon.color: if (mySwitch.position == 2){
JS.selected
}
else if (dl_button.hovered) 
{
    JS.iconhovered
}else {
JS.icon
}



//dl_button.hovered? JS.iconhovered: JS.icon


onClicked: {
    mySwitch.position = 2
}
}

}
}
}

}



Rectangle{
    color: JS.background
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
    color: JS.background
    id: rightColumnRectangle
    anchors{
        top: mainRow.top
        bottom: mainRow.bottom
    }
    width: 250

    Column{

        id: rightColumn
        anchors.fill: parent


        Rectangle{
            color: JS.background
            anchors {
                left: rightColumn.left
                right: rightColumn.right
            }
            height: 0.58 * parent.height

            id: mainMergeRectangle

            Column{

                id: mergeColumn
                anchors.fill: parent

                Rectangle {
                    //anchors.fill: parent
                    anchors {
                        left: mergeColumn.left
                        right: mergeColumn.right
                    }
                    height: 0.85 * parent.height
                    id: listRectangle
                    color: JS.background
                    ListView {

                        id: list
                        model: candidate_list_model
                        anchors.fill: parent
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        delegate: Item {
                        width: list.width; height: 40

                        Column{

                            anchors.fill: parent
                            Text {

                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: display
                                color: JS.textColor
                                font.pixelSize: 10

                            }
                            Text {

                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: metricsrole
                                color: JS.textColor
                                font.pixelSize: 10

                            }
                        }


                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                list.currentIndex = index
                            }
                        }


                    }
                    highlight: Rectangle { color: JS.highlight; radius: 5 }
                    focus: true
                    ScrollBar.vertical: vbar

                    ScrollBar {

                        id: vbar
                        hoverEnabled: true
                        active: hovered || pressed
                        orientation: Qt.Vertical

                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }

                }

                BusyIndicator {
                    id: bi
                    anchors.fill: parent
                    //visible: false
                    running: true
                }

            }

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
                        
                        Button {
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                            }
                            width: 0.5 * parent.width
                    
                            id: deleteRepetitions
                            
                            background: Rectangle {
                            radius: 5
                            anchors.fill: parent
                            color: JS.button
                                Text{
                                    anchors.centerIn: parent
                                    text: "DELETE REP."
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
                }
            
            
            }

    }
}

Rectangle{

    anchors {
        left: rightColumn.left
        right: rightColumn.right
    }
    height: 0.42 * parent.height

    id: abstractionTreeRectangle

    Column {
        anchors.fill: parent
        id: predictorColumn

        Rectangle {
            color: JS.background
            id: metricsBoundingRectangle
            anchors {
                left: predictorColumn.left
                right: predictorColumn.right
            }
            height: 0.9 * parent.height

            ListView {

                id: listModel
                model: metrics_list_model
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                delegate: Item {
                height: 40
                width: listModel.width;
                //anchors.left: parent.left
                //anchors.right: parent.right


                Rectangle {
                    id: firstMetric
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: parent.height
                    Row {
                        id: firstMetricRow
                        anchors.fill: parent

                        Rectangle {
                            color: JS.background
                            width: parent.width * 0.5
                            id: firstMetricSliderRectangle
                            anchors {
                                top: firstMetricRow.top
                                bottom: firstMetricRow.bottom
                            }
                            Slider {

                                id: firstMetricSlider
                                anchors.fill: parent
                                from: 0
                                value: valuemetric
                                to: 1
                                stepSize: 0.01

                                onValueChanged: {
                                    candidate_controller.change_hyperparameter(display, value)
                                }

                            }
                        }

                        Rectangle{
                            color: JS.background
                            width: parent.width * 0.5
                            id: firstMetricTextRectangle
                            anchors {
                                top: firstMetricRow.top
                                bottom: firstMetricRow.bottom
                            }
                            Text {
                                anchors.centerIn: parent
                                color: JS.textColor
                                font.pixelSize: 10
                                text: display +": " + firstMetricSlider.value
                            }
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
        color: JS.background
        height: 0.1 * parent.height
        Button {
            id: reculateButton
            anchors.fill: parent
            onClicked: {
                bi.running = true;
                mergeButton.enabled = false
                reculateButton.enabled = false
                candidate_controller.recalculateCandidates(slider.value)
                list.model.removeRows(0, list.model.rowCount() - 1);
                slider.to = slider.value

            }
            background: Rectangle {
            radius: 5
            anchors.fill: parent
            color: JS.button
            Text{
                anchors.centerIn: parent
                text: "RECALCULATE"
                color: JS.textColor
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
    function onUpdated(l, len, process_model_string, abstraction_level)
    {
        //console.log(len + 1)
        list.model.insertRows(0, len, l);
        vbar.size = listRectangle.height / ((list.model.rowCount()) * 40);
        //processModel.source =   process_model_string;
        bi.running = false
        slider.to = abstraction_level
        slider.value = abstraction_level
        mergeButton.enabled = true
        reculateButton.enabled = true
        if (len==0)
        {
            mergeButton.enabled = false;
        }

    }
}

Connections {
    target: candidate_controller
    function onTabchanged(abstraction_level)
    {
        slider.to = abstraction_level
        slider.value = abstraction_level

    }
}

Connections {
    target: candidate_controller
    function onMetricschanged(metrics_list, len_men)
    {
        metrics_list_model.removeRows(0, metrics_list_model.rowCount() - 1);
        metrics_list_model.insertRows(0, len_men, metrics_list)
    }
}

}






}
}