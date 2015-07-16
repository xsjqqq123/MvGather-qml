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
    height:150

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
        source: "qrc:/images/images/panel_bg.png"
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.top: backgroundItem.top
        anchors.bottom: backgroundItem.bottom
        border.left: 10; border.top: 10
        border.right: 30; border.bottom: 10
    }
    Column{
        //anchors.fill: backgroundItem
        anchors.bottom: backgroundItem.bottom
        anchors.horizontalCenter: backgroundItem.horizontalCenter
        spacing: 10
//        Rectangle {
//            width: backgroundItem.width - 40
//            height: 1
//            color: "#404040"
//        }
        Row{
            width: backgroundItem.width - 32
            height: 40
            spacing: 5
            Text{
                text:"清晰度等级："
                font.pixelSize: 28
                color: "white"
            }
            Slider{
                id:sliderId
                height: 30
                width:150
                minimumValue:1
                maximumValue: 10
                stepSize: 1
                value: settings.videoClarity
                //tickmarksEnabled:true
                updateValueWhileDragging:false
//                style: SliderStyle {
//                        groove: Rectangle {
//                            implicitWidth: 150
//                            implicitHeight: 15
//                            color: "gray"
//                            radius: 8
//                        }
//                        handle: Rectangle {
//                            anchors.centerIn: parent
//                            color: control.pressed ? "white" : "lightgray"
//                            border.color: "gray"
//                            border.width: 1
//                            implicitWidth: 15
//                            implicitHeight: 15
//                            radius: 6
//                        }
//                    }
                Connections{
                    target: sliderId
                    onValueChanged: {
                        settings.videoClarity = sliderId.value;
                        console.log(settings.videoClarity)
                    }
                }
            }
        }
        Rectangle {
            width: backgroundItem.width - 40
            height: 1
            color: "#404040"
        }
        Row{
            width: backgroundItem.width - 32
            height: 50
            spacing: 5
            Text{
                text:"粒子效果(占CPU)："
                font.pixelSize: 28
                color: "white"
            }
            Switch {
                height: 30
                width:50
                implicitWidth: 50
                implicitHeight: 30
                checked: settings.showParticles

                onCheckedChanged: {
                    settings.showParticles = checked;
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
