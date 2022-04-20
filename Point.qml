import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtCharts
import QtQuick.Layouts
import "constants.js" as JS





Rectangle {
    property int id_point
    id: point
    radius: 3
    x: 100
    y: 100
    width: 5
    height: 5
    color: "red"

    
    MouseArea {
        anchors.fill: parent
        onPressed: {
            point.color= "blue"
            console.log(point.x,point.y)
        }
    }

    Connections {
        target: manager
        function onPointsselected(x1,y1,x2,y2)
        {
            if (x1 <= x && x2 >= x && y1 <= y && y2 >= y){
                point.color = "black";
                manager.add_to_current_selection(point.id_point)
            } 

        }
    }
    

    
    
}