import QtQuick 2.0

Rectangle {
    id:root
    color:"#60000000"
    property int count:1 //表示视频的分片数
    property int index:0 //正在播放的索引
    property real percent:0//视频播放进度百分比

    property string playState:"pause" //state_str:play/pause

    signal playStateExchange()
    signal seekSiganl(int index,real percent)

    onPercentChanged: {
        handler.x = progressBar.width/root.count*(root.index +root.percent)
    }
    function emitPlayStateExchange(){
        root.playStateExchange()
    }

    Rectangle{
        id:playBtn
        width: 30
        height: 30
        anchors.left: root.left
        anchors.leftMargin: 30
        anchors.verticalCenter:  root.verticalCenter
        color: "transparent"
        Image {
            id: bt
            anchors.fill: parent
            source: {
                if(root.playState === "play")
                {
                    return "qrc:/images/images/play-start.png";
                }else
                {
                    return "qrc:/images/images/play-pause.png";
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                root.playStateExchange()
            }
        }

    }
    Rectangle {//视频由多片组成，将整个progressBar分成多段
        id:progressBar
        anchors.left: playBtn.right
        anchors.leftMargin: 30
        anchors.verticalCenter:  playBtn.verticalCenter
        width: parent.width*0.5; height: 10
        color: "#40FFFFFF"
        radius: 5

        MouseArea{
            id:progressBarMouseArea
            anchors.fill: parent
            onClicked: {
                handler.x = mouseX-handler.width/2
                for(var i = 0;i<root.count;i++)
                {
                    var singleSlicePixel = progressBar.width/root.count;
                    if(handler.x>(i*singleSlicePixel) && handler.x<(i+1)*singleSlicePixel)
                    {
                        root.seekSiganl(i,(handler.x-i*singleSlicePixel)/(singleSlicePixel))
                    }
                }

                //console.log(root.count,root.index,root.percent)
            }
        }
        Rectangle {//已播放填充
            color: "#806E6D07"
            x: 0
            y : 0
            height: 10
            anchors.left: parent.left
            anchors.right: handler.horizontalCenter
            radius: 5
        }
        Rectangle {
            id:handler
            color: "#FFFFFF"
            x: 0
            y : 0
            width: 10; height: 10
            radius: 4
            MouseArea {
                anchors.fill: parent
                drag.target: handler;
                drag.axis: "XAxis"
                drag.minimumX: 0
                drag.maximumX: progressBar.width - handler.width
                drag.filterChildren: true
                onReleased: {
                    handler.x = handler.x-handler.width/2
                    for(var i = 0;i<root.count;i++)
                    {
                        var singleSlicePixel = progressBar.width/root.count;
                        if(handler.x>(i*singleSlicePixel) && handler.x<(i+1)*singleSlicePixel)
                        {
                            root.seekSiganl(i,(handler.x-i*singleSlicePixel)/(singleSlicePixel))
                        }
                    }
                    //console.log(root.count,root.index,root.percent)
                }

            }
        }


    }
    Rectangle{//切换全屏按钮
        id:tabScreen
        width: 30
        height: 30
        anchors.right: root.right
        anchors.rightMargin: 30
        anchors.verticalCenter:  root.verticalCenter
        color: "transparent"
        Image {
            anchors.fill: parent
            source: {
                if(mainWindow.isFullScreen)
                {
                    return "qrc:/images/images/fullScreen.png";
                }else
                {
                    return "qrc:/images/images/normal.png";
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                mainWindow.isFullScreen = !mainWindow.isFullScreen;
            }
        }

    }
}
