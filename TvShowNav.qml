import QtQuick 2.0

Item {//综艺部分导航面板
    id:root
    property string url: "http://v.baidu.com/commonapi/tvshow2level/?filter=false"+
                         "&type="+(typeStr==="全部"?"":typeStr)+
                         "&area="+(areaStr==="全部"?"":areaStr)+
                         "&actor="+(actorStr==="全部"?"":actorStr)+
                         "&complete=&order="+orderStr+
                         "&rating=&prop="
    property string typeStr: "全部"//综艺类型
    property string areaStr: "全部"//综艺地区
    property string actorStr: "全部"//演员
    property string orderStr: "hot"//排序
    signal selectChange
    Column{
        anchors.fill: parent
        spacing: 5
        //第一分类
        Text{
            text:"类型:"
            color:Qt.darker("white")
            height: tvAreaNavGrid.cellHeight
            font.pixelSize: tvTypeNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:tvTypeNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            contentWidth: width; contentHeight: height
            highlight: Rectangle { color: "#558BD9";radius:3 }
            //boundsBehavior:Flickable.StopAtBounds
//            flickableDirection:Flickable.HorizontalFlick
            model: ListModel {
                id:tvTypeNavModel
            }
            delegate: Rectangle{
                width: tvTypeNavGrid.cellWidth*0.9
                height:tvTypeNavGrid.cellHeight*0.9
                color:"transparent"
                Text{
                    text:txtStr
                    color:"white"
                    elide:Text.ElideRight
                    font.pixelSize: parent.width/(text.length*1.2)
                    anchors.fill: parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter


                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tvTypeNavGrid.currentIndex = index;
                        root.typeStr = tvTypeNavModel.get(index).txtStr
//                        console.log(root.typeStr)

                    }
                }

            }
        }

        //第二分类
        Text{
            text:"地区:"
            color:Qt.darker("white")
            height: tvAreaNavGrid.cellHeight
            font.pixelSize: tvTypeNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:tvAreaNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/20
            highlight: Rectangle { color: "#558BD9";radius:3 }
            contentWidth: width; contentHeight: height
//            boundsBehavior:Flickable.StopAtBounds
            model: ListModel {
                id:tvAreaNavModel
            }
            delegate: Rectangle{
                width: tvAreaNavGrid.cellWidth*0.9
                height:tvAreaNavGrid.cellHeight*0.9
                color:"transparent"
                Text{
                    text:txtStr
                    color:"white"
                    elide:Text.ElideRight
                    font.pixelSize: parent.width/(text.length*1.2)
                    anchors.fill: parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter


                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tvAreaNavGrid.currentIndex = index;
                        root.areaStr = tvAreaNavModel.get(index).txtStr
                        }
                }

            }
        }
        //

        //第三分类
        Text{
            text:"演员:"
            color:Qt.darker("white")
            height: tvActorNavGrid.cellHeight
            font.pixelSize: tvActorNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:tvActorNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            model: ListModel {
                id:tvActorNavModel
            }
            delegate: Rectangle{
                width: txt4.text.length*txt4.font.pixelSize
                height:tvActorNavGrid.cellHeight
                color:"transparent"
                Text{
                    id:txt4
                    text:txtStr
                    color:"white"
                    elide:Text.ElideRight
                    anchors.fill: parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter


                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tvActorNavGrid.currentIndex = index;
                        root.actorStr = tvActorNavModel.get(index).txtStr

                    }
                }

            }
        }
        //第四分类
        Text{
            text:"排序:"
            color:Qt.darker("white")
            height: tvOrderNavGrid.cellHeight
            font.pixelSize: tvOrderNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:tvOrderNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            currentIndex:1
            model: ListModel {
                id:tvOrderNavModel
                ListElement{
                    showText:"热门"
                    txtStr:"hot"
                }
                ListElement{
                    showText:"更新"
                    txtStr:"pubtime"
                }
            }
            delegate: Rectangle{
                width: tvTypeNavGrid.cellWidth*0.9
                height:tvOrderNavGrid.cellHeight*0.9
                color:"transparent"
                Text{
                    text:showText
                    color:"white"
                    elide:Text.ElideRight
                    font.pixelSize: parent.width/3*1.2
                    anchors.fill: parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tvOrderNavGrid.currentIndex = index;
                        root.orderStr = tvOrderNavModel.get(index).txtStr

                    }
                }

            }
        }
    }
    onUrlChanged: {
        root.selectChange();
    }

    Component.onCompleted: {
        var typeStrArray = ["全部","综艺","选秀","情感","访谈","播报","旅游","音乐","美食","纪实","曲艺","生活","游戏","互动","财经","求职"];
        var i=0;
        for (i=0;i<typeStrArray.length;i++)
        {
            tvTypeNavModel.append({"txtStr":typeStrArray[i]});
        }
        var areaStrArray = ["全部","港台","内地","日韩","欧美"];
        for (i=0;i<areaStrArray.length;i++)
        {
            tvAreaNavModel.append({"txtStr":areaStrArray[i]});
        }
        var actorStrArray = ["全部","徐熙娣","蔡康永","陈鲁豫","孟非","乐嘉","何炅","谢娜","罗志祥","陶晶莹","郭德纲","周立波","窦文涛","汪涵","陈建州","王刚","朱丹","吴宗宪","李静"];
        for (i=0;i<actorStrArray.length;i++)
        {
            tvActorNavModel.append({"txtStr":actorStrArray[i]});
        }
    }
}
