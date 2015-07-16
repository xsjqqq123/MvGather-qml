import QtQuick 2.0
import QtQuick.LocalStorage 2.0
Item {
    id: root

    property bool isShown: false
    property string image//图片地址
    property string title//名称
    property string date:""//上映时间
    property string director:""//导演
    property string actor:""//演员
    property string intro:""//介绍
    property alias rating: ratingsItem.rating//评分

    property string storeId//存储百度分配的唯一一个ID
    property string videoType//类型，有movie、tv等
    property string storeVideoJson//用于存储当前显示详细信息的视频所对应的所有集数地址信息

    signal colectNewVideo()

    anchors.fill: parent
    opacity: 0
    visible: opacity
    scale: 0.3

    function show() {
        root.isShown = true;
        showAnimation.restart();
    }
    function hide() {
        hideAnimation.restart();
    }
    function getVideoSiteUrls(videoId) {
        var xmlhttp = new XMLHttpRequest();
        //console.log(videoId)
        xmlhttp.onreadystatechange=function(){
            if(xmlhttp.readyState!==4) return;
            if(xmlhttp.status!==200)
            {
                console.log("Problem retrieving json data");
                return;
            }
            selectSource.m_model.clear();
            root.storeVideoJson = xmlhttp.responseText.toString();
            var json = JSON.parse(root.storeVideoJson);
            if(root.videoType === "movie")
            {
                for(var i=0;i<json.length;i++)
                {
                    var o = json[i];
                    //var link = "http://v.baidu.com"+o.link
                    var logo = o.logo;
                    var name = o.name
                    var site = o.site
                    selectSource.m_model.append({"logo":logo,"name":name,"site":site})
                    //console.log(name,logo)
                }


            }else// if(root.videoType === "tv"||root.videoType == "show")
            {
                for(var i1=0;i1<json.length;i1++)
                {
                    var o1 = json[i1];
                    //var link = "http://v.baidu.com"+o.link
                    var logo1 = o1.site_info.logo;
                    var name1 = o1.site_info.name
                    var site1 = o1.site_info.site
                    selectSource.m_model.append({"logo":logo1,"name":name1,"site":site1})
                    //console.log(name1,logo1,site)
                }
            }

        };
        if(root.videoType == "movie")
        {
            xmlhttp.open("GET","http://v.baidu.com/movie_intro/?dtype=playUrl&service=json&e=1&id="+root.storeId+"&frp=browse",true);
        }else if(root.videoType == "tv")
        {
            xmlhttp.open("GET","http://v.baidu.com/tv_intro/?dtype=tvPlayUrl&e=1&service=json&id="+root.storeId,true);
        }else if(root.videoType == "show")
        {
            xmlhttp.open("GET","http://v.baidu.com/show_intro/?dtype=tvshowPlayUrl&service=json&id="+root.storeId,true);
        }else if(root.videoType == "comic")
        {
            xmlhttp.open("GET","http://v.baidu.com/comic_intro/?dtype=comicPlayUrl&service=json&id="+root.storeId,true);//加+"&site=*"可使其只返回一个来源
        }

        xmlhttp.send(null);
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
        width: Math.min(620, parent.width - 32)
        height: Math.min(840, parent.height - 32)
        border.color: "#808080"
        border.width: 1
        opacity: 0.8
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#101010" }
            GradientStop { position: 0.3; color: "#404040" }
            GradientStop { position: 1.0; color: "#090909" }
        }
        MouseArea{
            anchors.fill: parent
        }
    }

    Flickable {
        anchors.top: backgroundItem.top
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.bottom: bottomSeparator.top
        anchors.margins: 1
        anchors.bottomMargin: 0

        contentWidth: backgroundItem.width
        contentHeight: ratingsItem.y + descriptionTextItem.height + 64
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Image {
            id: movieImageItem
            x: 8
            y: 24
            width: 192
            height: 192
            source: root.image
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Column {
            id: topColumn
            y: 20
            anchors.left: movieImageItem.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 26
            spacing: 8
            Text {
                id: titleTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: text.length < 12 ? settings.fontL  : settings.fontMM
                text: root.title
            }
            Text {
                id: dateTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: settings.fontS
                text: "上映日期: " + root.date
            }
            Text {
                id: directorsTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: settings.fontS
                text: "导演: " + root.director
            }
            Text {
                id: actorTextItem
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ffffff"
                font.pixelSize: settings.fontS
                text: "演员: " + root.actor
            }
        }

        RatingsItem {//
            id: ratingsItem
            x: 10
            y: Math.max(topColumn.height, movieImageItem.height) + 40
            rating: root.rating
        }

        Text {
            id: descriptionTextItem
            anchors.top: ratingsItem.bottom
            anchors.topMargin: 16
            width: parent.width - 32
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            color: "#ffffff"
            font.pixelSize: settings.fontS
            text: "介绍: " + root.intro
        }
    }

    Rectangle {
        id: bottomSeparator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: backgroundItem.bottom
        anchors.bottomMargin: 80
        width: backgroundItem.width - 16
        height: 1
        color: "#808080"
    }
    SelectSource{
        id:selectSource
        anchors.bottom: backgroundItem.bottom
        anchors.bottomMargin: 8
        anchors.left: backgroundItem.left
        anchors.leftMargin: 32
        width: parent.width-100
        height:50
    }

    Button{
        text:"收藏"
        anchors.bottom: backgroundItem.bottom
        anchors.bottomMargin: 8
        anchors.right: backgroundItem.right
        anchors.rightMargin: 32
        effectsOn: false
        visible: selectSource.m_model.count
        onClicked: {
            //            console.log("收藏")
            root.hide();
            var sourceName = selectSource.m_model.get(selectSource.gridA.currentIndex).name;
            storeSpecialSiteVideoJson(sourceName);


        }
    }
    function storeSpecialSiteVideoJson(sourceName){
        var site = selectSource.m_model.get(selectSource.gridA.currentIndex).site;
        var xmlhttp = new XMLHttpRequest();
        //console.log(videoId)
        xmlhttp.onreadystatechange=function(){
            if(xmlhttp.readyState!==4) return;
            if(xmlhttp.status!==200)
            {
                console.log("Problem retrieving json data");
                return;
            }
            root.storeVideoJson = xmlhttp.responseText.toString();

            var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
            db.transaction(
                        function(tx) {
                            //表格Series(id TEXT, videoType TEXT,videoName TEXT, videosUrl TEXT, selectSourceName TEXT,selectSite TEXT,  historyEpisode TEXT)

                            tx.executeSql('INSERT INTO Series VALUES(?, ?,? ,? ,?,?,?)', [ root.storeId, root.videoType,root.title,root.storeVideoJson,sourceName.toString(),site.toString(), "0" ]);

                        }
                        )
            root.colectNewVideo();
        };
        if(root.videoType == "movie")//加入&site=指定来源,movie无效
        {
            xmlhttp.open("GET","http://v.baidu.com/movie_intro/?dtype=playUrl&service=json&e=1&id="+root.storeId+"&site="+site,true);
        }else if(root.videoType == "tv")
        {
            xmlhttp.open("GET","http://v.baidu.com/tv_intro/?dtype=tvPlayUrl&e=1&service=json&id="+root.storeId+"&site="+site,true);
        }else if(root.videoType == "show")
        {
            xmlhttp.open("GET","http://v.baidu.com/show_intro/?dtype=tvshowPlayUrl&service=json&id="+root.storeId+"&site="+site,true);
        }else if(root.videoType == "comic")
        {
            xmlhttp.open("GET","http://v.baidu.com/comic_intro/?dtype=comicPlayUrl&service=json&id="+root.storeId+"&site="+site,true);
        }

        xmlhttp.send(null);


    }


}
