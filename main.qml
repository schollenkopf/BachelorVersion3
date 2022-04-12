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
                    text: "OPEN DATALOG FILE"
                }
                Text{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    text: fileDialog.selectedFile
                }
                onClicked: {
                    fileDialog.open()
                }
            }

            FileDialog {
                id: fileDialog
                title: "Please choose a datalog csv file"
                //currentFolder: "C: \\Users\\39327\\Desktop"
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
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Number of columns"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: numColsInput
                        anchors.verticalCenter: parent.verticalCenter

                        validator: IntValidator{bottom: 0;}
                        focus: true
                        text: "6"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Number of rows"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom

                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor

                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: numRowsInput
                        anchors.verticalCenter: parent.verticalCenter

                        validator: IntValidator{bottom: 0;}
                        focus: true
                        text: "8114"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Index of Timestamp column"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: timestampColIndex
                        anchors.verticalCenter: parent.verticalCenter

                        validator: IntValidator{bottom: 0; top: numColsInput.text - 1;}
                        focus: true
                        text: "3"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }

                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Index of Action column"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: actionColIndex
                        anchors.verticalCenter: parent.verticalCenter

                        validator: IntValidator{bottom: 0; top: numColsInput.text - 1;}
                        focus: true
                        text: "5"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Index of TraceID column"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: traceColIndex
                        anchors.verticalCenter: parent.verticalCenter

                        validator: IntValidator{bottom: 0; top: numColsInput.text - 1;}
                        focus: true
                        text: "0"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Number of chars in Timestamp string"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: charsTimeInput
                        anchors.verticalCenter: parent.verticalCenter

                        validator: IntValidator{bottom: 0;}
                        focus: true
                        text: "26"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Timestamp String"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: timestampStringInput
                        anchors.verticalCenter: parent.verticalCenter

                        focus: true
                        text: "%Y-%m-%dT%H: %M: %S.%f"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: JS.heightButtonInputPage
            Row{
                anchors.fill: parent
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    Text {
                        anchors {
                            right: parent.right
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Separator"
                        color: JS.colorQuesText
                        font.pixelSize: JS.inputQuestionTextHeight
                        anchors.rightMargin: 10
                    }
                }
                Rectangle{
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: JS.inputBackColor
                    width: parent.width * 0.5
                    radius: 20
                    TextInput{
                        id: separatorInput
                        anchors.verticalCenter: parent.verticalCenter

                        focus: true
                        text: ";"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: JS.colorInText
                        font.pixelSize: JS.inputTextHeight
                    }
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
                    text: "LOAD ABSTRACTION TOOL"
                }
                enabled: false
                onClicked: {
                    candidate_controller.init_abstraction_controller(fileDialog.selectedFile, timestampStringInput.text, numColsInput.text, numRowsInput.text, separatorInput.text, timestampColIndex.text, charsTimeInput.text, false, actionColIndex.text, traceColIndex.text)
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
