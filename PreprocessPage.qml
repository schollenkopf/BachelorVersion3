import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtCharts
import QtQuick.Layouts
import "constants.js" as JS

Window {

    title: "Abstraction Tool"
    width: JS.width
    height: JS.height
    visible: true
    id: mainWindow
    color: "white"
     
    
    Row {
        anchors.fill: parent

        Rectangle {
            color: "green"
            width: 100
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            id: leftlabel
        }
        Column{
            width: parent.width - 350
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

        Rectangle {
            color: JS.background
            
            
            height: parent.height - 100
            anchors {
                left: parent.left
                right: parent.right
            }
            id: plot
            //anchors.fill: parent

            Rectangle {
                id: selectionRect
                visible: false
                x: 0
                y: 0
                z: 99
                width: 0
                height: 0
                rotation: 0
                color: "#5F227CEB"
                border.width: 1
                border.color: "#103A6E"
                transformOrigin: Item.TopLeft
            }

            
            

            MouseArea {
                id: selectionMouseArea
                property int initialXPos
                property int initialYPos
                property bool justStarted

                anchors.fill: parent
                z: 2 // make sure we're above other elements
                // mouse.button == Qt.LeftButton && mouse.modifiers & Qt.ShiftModifier
                onPressed: (mouse)=>{
                    if (true)
                    {
                        console.log("Mouse area shift-clicked !")
                        // initialize local variables to determine the selection orientation
                        initialXPos = mouse.x
                        initialYPos = mouse.y
                        justStarted = true

                        selectionRect.x = mouse.x
                        selectionRect.y = mouse.y
                        selectionRect.width = 0
                        selectionRect.height = 0
                        selectionRect.visible = true
                    }
                }
                onPositionChanged: (mouse)=>{
                    if (selectionRect.visible == true)
                    {
                    

                        
                        if (mouse.x >= initialXPos)
                            {
                                if (mouse.y >= initialYPos)
                                selectionRect.rotation = 0
                                else
                                selectionRect.rotation = -90
                            }
                            else
                            {
                                if (mouse.y >= initialYPos)
                                    selectionRect.rotation = 90
                                else
                                    selectionRect.rotation = -180
                            }
                        selectionRect.width = Math.abs(mouse.x - selectionRect.x)
                        selectionRect.height = Math.abs(mouse.y - selectionRect.y)
                        if (selectionRect.rotation == 0 || selectionRect.rotation == -180)
                        {
                        }
                        else
                        {
                            selectionRect.width = Math.abs(mouse.y - selectionRect.y)
                            selectionRect.height = Math.abs(mouse.x - selectionRect.x)
                        }
                    }
                    manager.color_points(selectionRect.height, selectionRect.width, selectionRect.rotation, selectionRect.x, selectionRect.y)
                }

                onReleased: {
                    
                    selectionRect.visible = false
                    
                }


                Repeater{
                    id: repeater
                    model: manager.model
                    Point {
                        id_point: model.point_id
                        color: model.display
                        x: model.xpos
                        y: model.ypos
                    }
                }

            }
        }
        Rectangle {
            color: "blue"
            height: 100
            anchors {
                left: parent.left
                right: parent.right
            }
            id: bottomlabel
        }

        }


        Column {
            id: plotbuttons
            width: 250
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            
            Row {

                ComboBox {
                    id: x_axis
                    currentIndex: 2
                    model: [ "Banana", "Apple", "Coconut" ]
                    width: 200
                    onCurrentIndexChanged: console.log(x_axis.model[currentIndex])
                }
                CheckBox {
                    id: number_x
                    checked: true
                    text: qsTr("Number")
                }
            }
            Row {

                ComboBox {
                    id: y_axis
                    currentIndex: 2
                    model: [ "Banana", "Apple", "Coconut" ]
                    width: 200
                    onCurrentIndexChanged: console.log(y_axis.model[currentIndex])
                }
                CheckBox {
                    id: number_y
                    checked: true
                    text: qsTr("Number")
                }
            }
            Button {
                width: 200
                Text {
                    text: "Generate Plot"
                }
                onClicked: {
                    manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                }
            }
            ComboBox {
                    id: sort_option
                    currentIndex: 2
                    model: [ "Banana", "Apple", "Coconut" ]
                    width: 200
                    onCurrentIndexChanged: console.log(sort_option.model[currentIndex])
                }
            Button {
                width: 200
                Text {
                    text: "Sort by Col"
                }
                onClicked: {
                    manager.color_by_column(sort_option.model[sort_option.currentIndex])
                    manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                }
            }
            TextInput{
                        id: cluster_name
                        //anchors.verticalCenter: parent.verticalCenter

                        
                        focus: true
                        text: "cluster_name"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                        
                    }
            Button {
                width: 200
                Text {
                    text: "Create Cluster"
                }
                onClicked: {
                    manager.create_cluster(cluster_name.text)
                    manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                
                }
            }
            Button {
                width: 200
                Text {
                    text: "Forget Selection"
                }
                onClicked: {
                    manager.forget_selection()
                    manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                
                }
            }
            ListView {
                                    
                                    id: clusters
                                    model: ["no_cluster"]
                                    width: 200
                                    height: 100
                                    flickableDirection: Flickable.VerticalFlick
                                    boundsBehavior: Flickable.StopAtBounds
                                    clip: true
                                //     ScrollBar.vertical: vbar

                                // ScrollBar {
                                    
                                //     id: vbar
                                //     hoverEnabled: true
                                //     active: hovered || pressed
                                //     orientation: Qt.Vertical
                                
                                //     anchors.top: parent.top
                                //     anchors.right: parent.right
                                //     anchors.bottom: parent.bottom
                                // }

                                    

        }
        Button {
                id: loadbutton
                width: 200
                Text {
                    //anchors.centerIn: parent
                    text: "LOAD ABSTRACTION TOOL"
                }
                
                onClicked: {
                    
                    
                    ld2.source="AbstractionPage.qml"
                    manager.init_abstraction_page()
                    table_model.first_setUp(7, 8114)
                    candidate_controller.updater()
                    
                }
            }


    }
    Connections {
        target: manager
        function onInit(a)
        {
            x_axis.model= a;
            y_axis.model= a;
            sort_option.model = a

        }
    }
    Connections {
        target: manager
        function onUpdate_clusters(a){
            clusters.model = a
        }

    }
    
}
Loader{
        id: ld2;
        anchors.fill: parent;
    }
}