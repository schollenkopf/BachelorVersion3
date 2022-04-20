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
                anchors {
                    left: parent.left
                    right:parent.right
                }
                height: 40
                color: JS.background
                
                Row {
                        anchors {
                                left: parent.left
                                right: parent.right
                            }
                        
                        height: 40
                        Rectangle {
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                            }
                            color: JS.inputBackColor
                            width: parent.width - 100
                            radius: 20

                            TextInput{

                                anchors {
                                    //leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                                id: cluster_name
                                //anchors.verticalCenter: parent.verticalCenter

                                
                                focus: true
                                text: "cluster_name"
                                
                                
                                color: JS.colorInText
                                font.pixelSize: JS.inputTextHeight
                                
                            }
                        }
                        Button {
                            
                            id: create_cluster_button
                            width: 50
                            background: Rectangle {
                                        anchors.fill: parent
                                        color: JS.button

                                    }
                            icon.color: create_cluster_button.hovered ? JS.iconhovered : JS.icon
                            icon.name: "create"
                            icon.source: "icons/create_cluster.png"
                            icon.width: 30
                            icon.height: 30
                            onClicked: {
                                manager.create_cluster(cluster_name.text)
                                manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                            
                            }
                        }
                        Button {
                            
                            id: forget_selection_button
                                width: 50
                                background: Rectangle {
                                            anchors.fill: parent
                                            color: JS.button

                                        }
                                icon.color: forget_selection_button.hovered ? JS.iconhovered : JS.icon
                                icon.name: "forget"
                                icon.source: "icons/forget.png"
                                icon.width: 30
                                icon.height: 30
                            onClicked: {
                                manager.forget_selection()
                                manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                            
                            }
                        }
                    }
            }

        Rectangle {
            color: JS.background
            
            
            height: parent.height - 140
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
            
            Rectangle {
                    //anchors.fill: parent
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: parent.height - 450
                    id: listRectangle
                    color: JS.background
                    ListView {

                        id: list
                        model: cluster_list_model
                        anchors.fill: parent
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        delegate: Item {
                        width: list.width; height: 40

                        Row{

                            anchors.fill: parent
                            Text {
                                width: 210
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                text: display
                                color: JS.textColor
                                font.pixelSize: 10

                            }
                            Rectangle {
                                width: 30
                                height : 30
                                
                                
                                radius: 5
                                color: colorrole
                                

                            }
                        }


                        // MouseArea {
                        //     anchors.fill: parent
                        //     onClicked: {
                        //         list.currentIndex = index
                        //     }
                        // }


                    }
                    //highlight: Rectangle { color: JS.highlight; radius: 5 }
                    //focus: true
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


            }

            Rectangle {
                height: 30
                anchors {
                    left: parent.left
                    right: parent.right
                }
                color: JS.background
            Row {
                anchors.fill: parent
                ComboBox {
                    anchors.verticalCenter: parent.verticalCenter
                    id: x_axis
                    currentIndex: 2
                    model: [ "Banana", "Apple", "Coconut" ]
                    width: 180
                    onCurrentIndexChanged: console.log(x_axis.model[currentIndex])
                    
                }
                CheckBox {
                    anchors.verticalCenter: parent.verticalCenter
                    id: number_x
                    checked: true

                    
                }
                    Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: JS.textColor
                            text: "Number"
                        }
            }
            }
            Rectangle {
                height: 30
                anchors {
                    left: parent.left
                    right: parent.right
                }
                color: JS.background
                Row {
                    anchors.fill: parent
                    ComboBox {
                        anchors.verticalCenter: parent.verticalCenter
                        id: y_axis
                        currentIndex: 2
                        model: [ "Banana", "Apple", "Coconut" ]
                        width: 180
                        onCurrentIndexChanged: console.log(y_axis.model[currentIndex])
                    }
                    CheckBox {
                        anchors.verticalCenter: parent.verticalCenter
                        id: number_y
                        checked: true
                        
                        
                    }
                    Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: JS.textColor
                            text: "Number"
                        }
                }
            }
            Button {
                width: 250
                height: 50
                background: Rectangle {
                            radius: 5
                            anchors.fill: parent
                            color: JS.button
                }
                Text {
                    anchors.centerIn: parent
                    color: JS.textColor
                    font.pixelSize: 10
                    text: "Generate Plot"
                }
                onClicked: {
                    manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                }
            }
            ComboBox {
                    height: 50
                    id: sort_option
                    currentIndex: 2
                    model: [ "Banana", "Apple", "Coconut" ]
                    width: 200
                    onCurrentIndexChanged: console.log(sort_option.model[currentIndex])
                }
            Button {
                width: 250
                height: 50
                background: Rectangle {
                            radius: 5
                            anchors.fill: parent
                            color: JS.button
                }
                Text {
                    anchors.centerIn: parent
                    color: JS.textColor
                    font.pixelSize: 10
                    text: "Sort by Col"
                }
                onClicked: {
                    manager.color_by_column(sort_option.model[sort_option.currentIndex])
                    manager.draw_scatter(x_axis.model[x_axis.currentIndex],number_x.checked,y_axis.model[y_axis.currentIndex],number_y.checked,plot.width,plot.height,plotbuttons.width,bottomlabel.height,leftlabel.width)
                }
            }
            

            
            

            

        
        Button {
                id: loadbutton
                width: 250
                height: 50
                background: Rectangle {
                            radius: 5
                            anchors.fill: parent
                            color: JS.button
                }
                Text {
                    anchors.centerIn: parent
                    color: JS.textColor
                    font.pixelSize: 10
                    text: "LOAD ABSTRACTION TOOL"
                }
                
                onClicked: {
                    
                    
                    manager.init_abstraction_page()
                    ld2.source="AbstractionPage.qml"
                    table_model.first_setUp(7, 8114)
                    //candidate_controller.updater()

                    //table_model.first_setUp(numColsInput.text, numRowsInput.text)
                    openFile.enabled = false
                    loadbutton.enabled = false
                    
                    candidate_controller.get_metrics()
                    candidate_controller.updater()
                    mainWindow.close()
                    
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
        function onUpdate_clusters(clusters_list, number_clusters)
    {
        cluster_list_model.removeRows(0, cluster_list_model.rowCount() - 1);
        cluster_list_model.insertRows(0, number_clusters, clusters_list)
    }

    }
    
}
Loader{
        id: ld2;
        anchors.fill: parent;
    }
}