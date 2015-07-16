import QtQuick 2.0

Item {//电影部分导航面板
    id:root
    property string url: "http://v.baidu.com/commonapi/movie2level/?filter=false"+"&type="+(typeStr==="全部"?"":typeStr)+
                         "&area="+(areaStr==="全部"?"":areaStr)+
                         "&actor="+(actorStr==="全部"?"":actorStr)+
                         "&start="+(startStr==="全部"?"":startStr)+
                         "&complete="+(completeStr==="全部"?"":completeStr)+
                         "&order="+orderStr
    property string typeStr: "全部"//电影类型
    property string areaStr: "全部"//电影地区
    property string startStr: "全部"//电影年份
    property string actorStr: "全部"//演员
    property string completeStr: "正片"//资源
    property string orderStr: "pubtime"//资源
    signal selectChange
    Column{
        anchors.fill: parent
        spacing: 5
        //第一分类
        Text{
            text:"类型:"
            color:Qt.darker("white")
            height: movieAreaNavGrid.cellHeight
            font.pixelSize: movieTypeNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:movieTypeNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            contentWidth: width; contentHeight: height
            highlight: Rectangle { color: "#558BD9";radius:3 }
            //boundsBehavior:Flickable.StopAtBounds
//            flickableDirection:Flickable.HorizontalFlick
            clip:true
            model: ListModel {
                id:movieTypeNavModel
            }
            delegate: Rectangle{
                width: movieTypeNavGrid.cellWidth*0.9
                height:movieTypeNavGrid.cellHeight*0.9
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
                        movieTypeNavGrid.currentIndex = index;
                        root.typeStr = movieTypeNavModel.get(index).txtStr
//                        console.log(root.typeStr)

                    }
                }

            }
        }

        //第二分类
        Text{
            text:"地区:"
            color:Qt.darker("white")
            height: movieAreaNavGrid.cellHeight
            font.pixelSize: movieTypeNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:movieAreaNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
            contentWidth: width; contentHeight: height
//            boundsBehavior:Flickable.StopAtBounds
            clip:true
            model: ListModel {
                id:movieAreaNavModel
            }
            delegate: Rectangle{
                width: movieAreaNavGrid.cellWidth*0.9
                height:movieAreaNavGrid.cellHeight*0.9
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
                        movieAreaNavGrid.currentIndex = index;
                        root.areaStr = movieAreaNavModel.get(index).txtStr
                        }
                }

            }
        }
        //
        //第三分类
        Text{
            text:"年代:"
            color:Qt.darker("white")
            height: movieStartNavGrid.cellHeight
            font.pixelSize: movieStartNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:movieStartNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/20
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            clip:true
            model: ListModel {
                id:movieStartNavModel
            }
            delegate: Rectangle{
                width: movieStartNavGrid.cellWidth*0.9
                height:movieStartNavGrid.cellHeight*0.9
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
                        movieStartNavGrid.currentIndex = index;
                        root.startStr = movieStartNavModel.get(index).txtStr

                    }
                }

            }
        }
        //第四分类
        Text{
            text:"演员:"
            color:Qt.darker("white")
            height: movieActorNavGrid.cellHeight
            font.pixelSize: movieActorNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:movieActorNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            clip:true
            model: ListModel {
                id:movieActorNavModel
            }
            delegate: Rectangle{
                width: txt4.text.length*txt4.font.pixelSize
                height:movieActorNavGrid.cellHeight
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
                        movieActorNavGrid.currentIndex = index;
                        root.actorStr = movieActorNavModel.get(index).txtStr

                    }
                }

            }
        }
        //第五分类
        Text{
            text:"资源:"
            color:Qt.darker("white")
            height: movieCompleteNavGrid.cellHeight
            font.pixelSize: movieCompleteNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:movieCompleteNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            currentIndex:1
            clip:true
            model: ListModel {
                id:movieCompleteNavModel
                ListElement{
                    txtStr:"全部"
                }
                ListElement{
                    txtStr:"正片"
                }
                ListElement{
                    txtStr:"花絮"
                }
            }
            delegate: Rectangle{
                width: movieTypeNavGrid.cellWidth*0.9
                height:movieCompleteNavGrid.cellHeight*0.9
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
                        movieCompleteNavGrid.currentIndex = index;
                        root.completeStr = movieCompleteNavModel.get(index).txtStr

                    }
                }

            }
        }
        //第六分类
        Text{
            text:"排序:"
            color:Qt.darker("white")
            height: movieOrderNavGrid.cellHeight
            font.pixelSize: movieOrderNavGrid.cellHeight*0.6
            verticalAlignment: Text.AlignBottom
        }
        GridView {
            id:movieOrderNavGrid
            cellWidth: root.width/13
            cellHeight: cellWidth/2
            width: root.width*0.95;
            height: root.height/10
            highlight: Rectangle { color: "#558BD9";radius:3 }
//            boundsBehavior:Flickable.StopAtBounds
            contentWidth: width; contentHeight: height
            currentIndex:1
            clip:true
            model: ListModel {
                id:movieOrderNavModel
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
                width: movieTypeNavGrid.cellWidth*0.9
                height:movieOrderNavGrid.cellHeight*0.9
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
                        movieOrderNavGrid.currentIndex = index;
                        root.orderStr = movieOrderNavModel.get(index).txtStr

                    }
                }

            }
        }
    }
    onUrlChanged: {
        root.selectChange();
    }

    Component.onCompleted: {
        var typeStrArray = ["全部","喜剧","恐怖","爱情","动作","科幻","战争","犯罪","惊悚","动画","剧情","古装","奇幻","武侠","冒险","悬疑","传记","运动","音乐"];
        var i=0;
        for (i=0;i<typeStrArray.length;i++)
        {
            movieTypeNavModel.append({"txtStr":typeStrArray[i]});
        }
        var areaStrArray = ["全部","内地","美国","香港","台湾","韩国","日本","法国","英国","德国","泰国","印度","欧洲地区","东南亚地区","其他地区"];
        for (i=0;i<areaStrArray.length;i++)
        {
            movieAreaNavModel.append({"txtStr":areaStrArray[i]});
        }
        var startStrArray = ["全部","2015","2014","2013","2012","2011","2010","00年代","90年代","80年代"];
        for (i=0;i<startStrArray.length;i++)
        {
            movieStartNavModel.append({"txtStr":startStrArray[i]});
        }
        var actorStrArray = ["全部","成龙","葛优","吴京","黄渤","范冰冰","林正英","周润发","周星驰","甄子丹","古天乐","李连杰","刘德华","吴彦祖","梁朝伟","周杰伦","林心如","张曼玉","刘亦菲","林青霞","王祖贤","林志玲","王宝强"];
        for (i=0;i<actorStrArray.length;i++)
        {
            movieActorNavModel.append({"txtStr":actorStrArray[i]});
        }
    }
}
