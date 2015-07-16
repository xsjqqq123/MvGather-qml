import QtQuick 2.0

Item {//动漫部分导航面板
    id:root
    property string url: "http://v.baidu.com/commonapi/comic2level/?filter=false"+
                         "&type="+(typeStr==="全部"?"":typeStr)+
                         "&area="+(areaStr==="全部"?"":areaStr)+
                         "&start="+(startStr==="全部"?"":startStr)+
                         "&complete=&order="+orderStr+
                         "&rating=&prop="
    property string typeStr: "全部"//动漫类型
    property string areaStr: "全部"//动漫地区
    property string startStr: "全部"//动漫年份
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
            text:"年代:"
            color:Qt.darker("white")
            height: tvStartNavGrid.cellHeight
            font.pixelSize: tvStartNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:tvStartNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            model: ListModel {
                id:tvStartNavModel
            }
            delegate: Rectangle{
                width: tvStartNavGrid.cellWidth*0.9
                height:tvStartNavGrid.cellHeight*0.9
                color:"transparent"
                Text{
                    text:txtStr
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
                        tvStartNavGrid.currentIndex = index;
                        root.startStr = tvStartNavModel.get(index).txtStr

                    }
                }

            }
        }

        //第五分类
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
        var typeStrArray = ["全部","情感","科幻","热血","推理","搞笑","冒险","萝莉","校园","动作","机战","运动","战争","少年","少女","社会","原创","亲子","益智","励志","其他"];
        var i=0;
        for (i=0;i<typeStrArray.length;i++)
        {
            tvTypeNavModel.append({"txtStr":typeStrArray[i]});
        }
        var areaStrArray = ["全部","日本","欧美","国产","其他"];
        for (i=0;i<areaStrArray.length;i++)
        {
            tvAreaNavModel.append({"txtStr":areaStrArray[i]});
        }
        var startStrArray = ["全部","2015","2014","2013","2012","2011","2010","2009","2008","2007","2006","2005","2005之前"];
        for (i=0;i<startStrArray.length;i++)
        {
            tvStartNavModel.append({"txtStr":startStrArray[i]});
        }
    }
}
