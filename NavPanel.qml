import QtQuick 2.0
import "qrc:/navMenu"
Item {//导航主面板
    id:root
    property string urlExcludePageNum: "http://v.baidu.com/commonapi/movie2level/?filter=false&type=&area=&actor=&start=&complete=&order=pubtime&rating=&prop="
    property bool isShown: false
    opacity: 0
    visible: opacity
    state: "movie"

    function show() {
        root.isShown = true;
        showAnimation.restart();
    }
    function hide() {
        root.isShown = false;
        hideAnimation.restart();
    }
    Rectangle {
        id: backgroundItem
        anchors.centerIn: parent
        width: Math.min(620, parent.width - 32)
        height: Math.min(840, parent.height - 32)
        border.color: "#808080"
        border.width: 1
        opacity: 0.8
        radius : 5
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#101010" }
            GradientStop { position: 0.3; color: "#404040" }
            GradientStop { position: 1.0; color: "#090909" }
        }
    }
    Flickable {
        anchors.top: backgroundItem.top
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.bottom: backgroundItem.bottom
        Column{
            spacing: 10
            width: backgroundItem.width*0.95
            anchors.horizontalCenter: parent.horizontalCenter
            GridView {
                id:navGrid
                width: backgroundItem.width*0.95; height: backgroundItem.height/10
                cellWidth: backgroundItem.width*0.95/4
                cellHeight: backgroundItem.height/10
//                anchors.top: backgroundItem.top
//                anchors.horizontalCenter: backgroundItem.horizontalCenter
                highlight: Rectangle { color: "yellow"; }
                boundsBehavior:Flickable.StopAtBounds
                model: ListModel {
                    ListElement {
                        type: "movie"//电影
                        txtStr:"电影"
                    }
                    ListElement {
                        type: "tv"//电视剧
                        txtStr:"电视剧"
                    }
                    ListElement {
                        type: "show"//综艺
                        txtStr:"综艺"
                    }
                    ListElement {
                        type: "comic"//动漫
                        txtStr:"动漫"
                    }
                }
                delegate: Rectangle{
                    width: navGrid.cellWidth
                    height:navGrid.cellHeight*0.9
                    color:"#80393755"
                    Text{
                        anchors.centerIn: parent
                        text:txtStr
                        color:"white"
                        font.pixelSize: parent.height*0.6
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        navGrid.currentIndex = navGrid.indexAt(mouseX,mouseY);
                        switch(navGrid.currentIndex)
                        {
                        case 0:
                            root.state = "movie"
                            break;
                        case 1:
                            root.state = "tv"
                            break;
                        case 2:
                            root.state = "show"
                            break;
                        case 3:
                            root.state = "comic"
                            break;
                        default:
                        }
                    }
                }
            }
            MovieNav{
                id:movieNav
                width: backgroundItem.width
                height:backgroundItem.height*0.95
            }
            TvNav{
                id:tvNav
                width: backgroundItem.width
                height:backgroundItem.height*0.95
            }
            TvShowNav{
                id:showNav
                width: backgroundItem.width
                height:backgroundItem.height*0.95
            }
            ComicNav{
                id:comicNav
                width: backgroundItem.width
                height:backgroundItem.height*0.95
            }
        }
    }
    states: [//用于实现类似tab功能
        State {
            name: "movie"
            PropertyChanges {
                target: movieNav
                visible:true
            }
            PropertyChanges {
                target: tvNav
                visible:false
            }
            PropertyChanges {
                target: showNav
                visible:false
            }
            PropertyChanges {
                target: comicNav
                visible:false
            }
        },
        State {
            name: "tv"
            PropertyChanges {
                target: tvNav
                visible:true
            }
            PropertyChanges {
                target: movieNav
                visible:false
            }
            PropertyChanges {
                target: showNav
                visible:false
            }
            PropertyChanges {
                target: comicNav
                visible:false
            }
        },
        State {
            name: "show"
            PropertyChanges {
                target: showNav
                visible:true
            }
            PropertyChanges {
                target: tvNav
                visible:false
            }
            PropertyChanges {
                target: movieNav
                visible:false
            }
            PropertyChanges {
                target: comicNav
                visible:false
            }
        },
        State {
            name: "comic"
            PropertyChanges {
                target: comicNav
                visible:true
            }
            PropertyChanges {
                target: showNav
                visible:false
            }
            PropertyChanges {
                target: tvNav
                visible:false
            }
            PropertyChanges {
                target: movieNav
                visible:false
            }

        }
    ]
    onStateChanged: {
        if(root.state === "movie")
        {
            root.urlExcludePageNum = movieNav.url
        }else if(root.state === "tv")
        {
            root.urlExcludePageNum = tvNav.url

        }else if(root.state === "show")
        {
            root.urlExcludePageNum = showNav.url
        }else if(root.state === "comic")
        {
            root.urlExcludePageNum = comicNav.url
        }
    }

    Connections{
        target: movieNav
        onUrlChanged:root.urlExcludePageNum = movieNav.url
    }
    Connections{
        target: tvNav
        onUrlChanged:root.urlExcludePageNum = tvNav.url
    }
    Connections{
        target: showNav
        onUrlChanged:root.urlExcludePageNum = showNav.url
    }
    Connections{
        target: comicNav
        onUrlChanged:root.urlExcludePageNum = comicNav.url
    }

    ParallelAnimation {//显示动画
        id: showAnimation
        NumberAnimation { target: root; property: "opacity"; to: 1.0; duration: 300; easing.type: Easing.InOutQuad }
        NumberAnimation { target: root; property: "scale"; to: 1.0; duration: 300; easing.type: Easing.InOutQuad }
    }
    ParallelAnimation {//隐藏动画
        id: hideAnimation
        NumberAnimation { target: root; property: "opacity"; to: 0; duration: 300; easing.type: Easing.InOutQuad }
        NumberAnimation { target: root; property: "scale"; to: 0.6; duration: 300; easing.type: Easing.InOutQuad }

    }
}
