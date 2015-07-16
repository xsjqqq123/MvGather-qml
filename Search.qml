import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
Rectangle{
    id:root
    color: "transparent"
    property bool isShown: false
    opacity: 0
    visible: opacity
    width: 400
    height:80
    signal search(string keyword)

    function show() {
        isShown = true;
        hideAnimation.stop();
        showAnimation.restart();
    }
    function hide() {
        isShown = false;
        showAnimation.stop();
        hideAnimation.restart();
    }

    Item{
        id:backgroundItem
        anchors.centerIn: parent
        width: parent.width*0.95
        height: parent.height*0.95
    }
    BorderImage {
        id: borderImg
        source: "qrc:/images/images/panel_bg2.png"
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.top: backgroundItem.top
        anchors.bottom: backgroundItem.bottom
        border.left: 10; border.top: 10
        border.right: 30; border.bottom: 10
    }
    Row{
        anchors.centerIn: parent
        width: backgroundItem.width - 32
        height: 40
        spacing: 5
        Text{
            anchors.verticalCenter: parent.verticalCenter
            text:"搜索："
            font.pixelSize: 22
            color: "white"
        }
        TextField{
            id:textId
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            onAccepted:{
                root.hide();
                root.search(textId.text);
            }

            style: TextFieldStyle {
                    textColor: "white"

                    background: Rectangle {
                        radius: 3
                        implicitWidth: 160
                        implicitHeight: 30
                        border.color: "#50EEEEEE"
                        border.width: 1
                        color:"#50EEEEEE"
                    }
                }
        }
        Button{
            id:searchBtn
            text:"搜索"
            anchors.verticalCenter: parent.verticalCenter
            onClicked:{
                if(textId.text === "")
                {
                    textId.text = "请输入关键字"
                    return
                }
                root.hide();
                root.search(textId.text);
            }

            style: ButtonStyle {
                    background: Rectangle {
                        border.width: searchBtn.activeFocus ? 2 : 1
                        border.color: "#CC000000"
                        implicitWidth: 60
                        implicitHeight: 30
                        radius: 3
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: control.pressed ? "#50EEEEEE" : "#90EEEEEE" }
                            GradientStop { position: 1 ; color: control.pressed ? "#80EEEEEE" : "#90EEEEEE" }
                        }
                    }
                }
        }
    }

    SequentialAnimation {
        id: showAnimation
        //PropertyAction { target: root; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 1; duration: 250; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "scale"; to: 1; duration: 500; easing.type: Easing.OutBack }
        }
    }
    SequentialAnimation {
        id: hideAnimation
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "scale"; to: 0.6; duration: 500; easing.type: Easing.InOutQuad }
        }
        //PropertyAction { target: backgroundItem; property: "visible"; value: false }
    }
}
