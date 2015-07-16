import QtQuick 2.0

Item {//电视剧部分导航面板
    id:root
    property string url: "http://v.baidu.com/commonapi/tvplay2level/?filter=false"+
                         "&type="+(typeStr==="全部"?"":typeStr)+
                         "&area="+(areaStr==="全部"?"":areaStr)+
                         "&actor="+(actorStr==="全部"?"":actorStr)+
                         "&start="+(startStr==="全部"?"":startStr)+
                         "&complete=&order="+orderStr+
                         "&rating=&prop="
    property string typeStr: "全部"//电视剧类型
    property string areaStr: "全部"//电视剧地区
    property string startStr: "全部"//电视剧年份
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
        //第四分类
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
                ListElement{
                    showText:"评价"
                    txtStr:"rating"
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
        var typeStrArray = ["全部","古装","战争","青春","偶像","喜剧","家庭","犯罪","动作","奇幻","剧情","历史","经典","乡村","情景","商战","其他"];
        var i=0;
        for (i=0;i<typeStrArray.length;i++)
        {
            tvTypeNavModel.append({"txtStr":typeStrArray[i]});
        }
        var areaStrArray = ["全部","内地","韩国","香港","台湾","日本","美国","泰国","英国","新加坡","其他"];
        for (i=0;i<areaStrArray.length;i++)
        {
            tvAreaNavModel.append({"txtStr":areaStrArray[i]});
        }
        var startStrArray = ["全部","2015","2014","2013","2012","2011","2010","2009","2008","2007","2006","2005","2005之前"];
        for (i=0;i<startStrArray.length;i++)
        {
            tvStartNavModel.append({"txtStr":startStrArray[i]});
        }
        var actorStrArray = ["全部","杨幂","霍建华","刘亦菲","范冰冰","王珞丹","黄晓明","陈乔恩","林依晨","郑元畅","林心如","贾静雯","赵薇","胡歌","周渝民","小沈阳","赵本山","孙俪","张卫健","欧阳震华","张涵予","杨丞琳","佟大为"];
        for (i=0;i<actorStrArray.length;i++)
        {
            tvActorNavModel.append({"txtStr":actorStrArray[i]});
        }
    }
}
