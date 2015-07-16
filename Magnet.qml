import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
Item {
    id: root

    property bool isShown: false
    anchors.fill: parent
    opacity: 0
    visible: opacity
    scale: 0.3
    focus: true
    function reloadPlayerList(){
        playerListLoader.reloadList();
    }

    function show() {
        root.isShown = true;
        showAnimation.restart();
    }
    function hide() {
        hideAnimation.restart();
    }
    ParallelAnimation {
        id: showAnimation
        NumberAnimation { target: root; property: "opacity"; to: 1.0; duration: 300; easing.type: Easing.InOutQuad }
        NumberAnimation { target: root; property: "scale"; to: 1.0; duration: 300; easing.type: Easing.InOutQuad }
    }
    SequentialAnimation {
        id: hideAnimation
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 300; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "scale"; to: 0.6; duration: 300; easing.type: Easing.InOutQuad }
        }
        PropertyAction { target: root; property: "isShown"; value: false }
    }

    Rectangle {
        id: backgroundItem
        anchors.centerIn: parent
        width: mainWindow.isFullScreen?parent.width:Math.min(880, parent.width)
        height: mainWindow.isFullScreen?parent.height:Math.min(620, parent.height)
        border.color: "#80808080"
        border.width: 1
        opacity: 0.95
        //color: "black"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#101010" }
            GradientStop { position: 0.4; color: "#404040" }
            GradientStop { position: 1.0; color: "#090909" }
        }
    }

    Row{
        id:headerId
        anchors.top: backgroundItem.top
        anchors.horizontalCenter: backgroundItem.horizontalCenter
        width: backgroundItem.width - 32
        height: 40
        spacing: 5
        Text{
            anchors.verticalCenter: parent.verticalCenter
            text:"磁力链搜索："
            font.pixelSize: 22
            color: "white"
        }
        TextField{
            id:textId
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            onAccepted:{
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
                }else{
                    searchMagnet(textId.text)
                }
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
    Rectangle {//分隔线
        id:separationLineId
        anchors.top: headerId.bottom
        anchors.horizontalCenter: backgroundItem.horizontalCenter
        width: backgroundItem.width - 40
        height: 1
        color: "#404040"
    }
    ListView {
        id:magnetListId
        anchors.top: separationLineId.bottom
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.bottom: backgroundItem.bottom
        model: model
        clip:true
        delegate: Rectangle {
            color: "transparent"
            width: backgroundItem.width - 40
            height:120
            Row {
                anchors.centerIn: parent
                spacing: 10
                Column{
                    spacing: 3
                    Text { text: name;font.pixelSize:22;width: backgroundItem.width*0.8;elide:Text.ElideRight;color:"white"}
                    Text { text: info; font.pixelSize:22;width: backgroundItem.width*0.8;elide:Text.ElideRight;color:"white"}
                    Text { text: magnetLink ;font.pixelSize:22;width: backgroundItem.width*0.8;elide:Text.ElideRight;color:"white"}
                }
                Button{
                    text:"下载"
                    onClicked:{
                        worker.openLocalMagnetLink(magnetLink)
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

        }
    }
    ListModel {
        id:model
    }

    Component {
        id: myComponent
        Text { text: modelIndex }
    }

    function getMp4BaMagnet()
    {
        model.clear();
    }
    function searchMagnet(keyword)//引擎http://brisk.eu.org/api/magnet.php?q=关键字&n=页数
    {
        model.clear();
        var returnJson = worker.searchMagnets(keyword);////返回 [{"title":"info","magnet":""},{"":"","":""}]
        //console.log(returnJson);
        var json = JSON.parse(returnJson);
        for(var i=0;i<json.data.length;i++)
        {
            var title = json.data[i].title;
            var info = json.data[i].info;
            var magnet = json.data[i].magnet;
            model.append({name:title,info:info,magnetLink:magnet})
        }
    }
    Component.onCompleted: {
        //model.append({name:"hello",magnetLink:"link"})
    }
}
