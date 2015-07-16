import QtQuick 2.0
import QtAV 1.5
import QtQuick.LocalStorage 2.0
Item {
    id: root

    property bool isShown: false
    anchors.fill: parent
    opacity: 0
    visible: opacity
    scale: 0.3
    focus: true
    //some state imformation
    property bool isWorkerBusy:false;//Worker类是否在解析
    property bool isPlayBuffing:false;//播放器是否正在缓冲
    property bool isSyncData:false;//是否正在同步播放列表
    //存储正在播放视频的信息
    property string episodeId//视频唯一ID
    property string episodeNum//集数
    property string url//来源播放页

    onEpisodeIdChanged: {
        worker.setEpisodeId(episodeId)
    }
    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            mainWindow.isFullScreen = !mainWindow.isFullScreen;
        }else if(event.key === Qt.Key_Space)
        {
            //readyPlayerList.playingIndex%2===0?(player1.)
            controlPanel.playStateExchange()
        }
    }
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
        border.color: mainWindow.isFullScreen?"transparent":"#80808080"
        border.width: 1
        opacity: 0.95
        //color: "black"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#101010" }
            GradientStop { position: 0.4; color: "#404040" }
            GradientStop { position: 1.0; color: "#090909" }
        }
    }

    Item {
        id:playerWin
        anchors.top: backgroundItem.top
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.bottom: backgroundItem.bottom
        anchors.margins: 1
        anchors.bottomMargin: 0
        clip: true
        MouseArea{
            id:winMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onMouseXChanged: {
                hideTimer.stop()
                winMouseArea.cursorShape = Qt.ArrowCursor
                controlPanel.visible = true
                playerListLoader.visible = true
                //console.log(mouseX,playerListLoader.x,mouseY,controlPanel.y)

                if(mouseX<(playerWin.width-playerListLoader.width) && mouseY<(playerWin.height-controlPanel.height))
                    hideTimer.restart()
            }
            onDoubleClicked: {
                mainWindow.isFullScreen = !mainWindow.isFullScreen
            }
        }
        Timer {
            id:hideTimer
            interval: 2000;
            onTriggered: {
                controlPanel.visible = false
                playerListLoader.visible = false
                winMouseArea.cursorShape = Qt.BlankCursor
            }
        }

        VideoOutput2 {
            id:videoOutput
            anchors.fill: parent
            source: {
                //console.log("videoOutput change:",readyPlayerList.playingIndex%2)
                return readyPlayerList.playingIndex%2===0?player1:player2
            }
        }
        AVPlayer { //
            id: player1
            autoLoad: true
            onStatusChanged: {
                console.log(AVPlayer.NoMedia,AVPlayer.Loading,AVPlayer.Loaded);
                console.log(AVPlayer.Buffering,AVPlayer.Stalled,AVPlayer.Buffered);
                console.log(AVPlayer.EndOfMedia,AVPlayer.InvalidMedia,AVPlayer.UnknownStatus);
                console.log(player1.status)
                if(player1.status === AVPlayer.Buffering|| player1.status === AVPlayer.Loading|| player1.status === AVPlayer.Loaded)
                {
                    busyIndicator.text = "正在缓冲……"
                    root.isPlayBuffing = true;

                }else if(player1.status === 8){
                    busyIndicator.text = "播放失败"
                    root.isPlayBuffing = true;
                }else
                {
                    root.isPlayBuffing = false
                }

                if( player1.status === AVPlayer.EndOfMedia && player1.position > (player1.duration-1000))
                {
                    if(player1.duration === 0)
                        return;
                    console.log("player1 onStatusChanged playNextVideo")
                    playerWin.playNextVideo()
                }
            }
            onPositionChanged: {
                controlPanel.percent = player1.position/player1.duration;
            }
        }

        AVPlayer { //
            id: player2
            autoLoad: true
            onStatusChanged: {
                console.log("player2.onStatusChanged:")
                if(player2.status === AVPlayer.Buffering || player2.status === AVPlayer.Loading|| player2.status === AVPlayer.Loaded)
                {
                    root.isPlayBuffing = true;
                    busyIndicator.text = "正在缓冲……"
                }else if(player2.status === 8){
                    busyIndicator.text = "播放失败"
                    root.isPlayBuffing = true;
                }else
                {
                    root.isPlayBuffing = false
                }
                if( player2.status === AVPlayer.EndOfMedia && player2.position > (player2.duration-1000))//
                {
                    if(player2.duration === 0)
                        return;
                    console.log("player2 onStatusChanged playNextVideo")
                    playerWin.playNextVideo()
                }
            }
            onPositionChanged: {
                controlPanel.percent = player2.position/player2.duration;
            }
        }
        ListModel{//存储将要播放的真实地址list
            id:readyPlayerList
            property int playingIndex:0//播放到的视频片段索引
            //ListElement{realUrl:"url"}
        }
        function playNewVideo(){

            readyPlayerList.playingIndex = 0;
            if(readyPlayerList.count>0)
            {
                //console.log("playNewVideo()")
                player2.stop()
                player1.source = worker.getDerectUrl(readyPlayerList.get(0).realUrl);
                player1.play();
                //console.log(player1.source)
                if(readyPlayerList.count>1)
                {
                    player2.source = worker.getDerectUrl(readyPlayerList.get(1).realUrl);
                    //console.log("player2.source",player2.source)
                }
            }
            var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
            db.transaction(
                        function(tx) {
                            tx.executeSql('UPDATE Series SET historyEpisode="'+root.episodeNum+'" WHERE id="'+root.episodeId+'"');
                            //console.log('UPDATE Series SET historyEpisode="'+root.episodeNum+'" WHERE id="'+root.episodeId+'"')
                        });
        }
        function playNextVideo(){//播放下一片段,只在play到片结尾时调用
            console.log("readyPlayerList.playingIndex:",readyPlayerList.playingIndex)
            console.log("player2.source:",player2.source)
            if(readyPlayerList.playingIndex < (readyPlayerList.count-1))//列表中还有视频片没播放
            {
                readyPlayerList.playingIndex += 1;//选切换videoOutput的source
                if((readyPlayerList.playingIndex-1)%2 ===0)//player1刚播放完
                {
                    console.log("player2.play()",player2.status,player2.playbackState)
                    player2.play();
                    console.log("player2.play()")
                    if(readyPlayerList.playingIndex+1 > readyPlayerList.count-1)
                        return;
                    player1.source = worker.getDerectUrl(readyPlayerList.get(readyPlayerList.playingIndex+1).realUrl);
                }else{//player2刚播放完
                    player1.play();
                    if(readyPlayerList.playingIndex+1 > readyPlayerList.count-1)
                        return;
                    player2.source = worker.getDerectUrl(readyPlayerList.get(readyPlayerList.playingIndex+1).realUrl);
                    console.log("player1.play();")
                }

                //console.log("player2.playbackState()",player2.playbackState)


            }else if(readyPlayerList.playingIndex === (readyPlayerList.count-1)){//刚播放完的是最后一片
                //播放下一集
                playNextEpisode()
            }
        }
        function playNextEpisode()//播放下一集
        {
            console.log("播放下一集")
            readyPlayerList.playingIndex = 0;
            //由当前正在播放的视频的ID和集数（root.episodeId和root.episodeNum）从数据库得到下一集数的sourceUrl

            var sourceUrl;
            var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
            db.transaction(
                        function(tx) {
                            var rs = tx.executeSql('SELECT * FROM Series');
                            for(var i = 0; i < rs.rows.length; i++) {
                                var episodeId = rs.rows.item(i).id;
                                var videoType = rs.rows.item(i).videoType;
                                var EpisodeName = rs.rows.item(i).videoName;
                                var videosUrlJson = JSON.parse(rs.rows.item(i).videosUrl);
                                var selectSourceName = rs.rows.item(i).selectSourceName;
                                var historyEpisode = rs.rows.item(i).historyEpisode;
                                if(episodeId === root.episodeId)
                                {
                                    if(videoType === "movie")
                                    {
                                        //没有下一集……
                                    }else
                                    {
                                        for(var a=0;a<videosUrlJson.length;a++)
                                        {
                                            if(videosUrlJson[a].site_info.name === selectSourceName)//找到对应来源的地址集
                                            {
                                                sourceUrl = videosUrlJson[a].episodes[root.episodeNum].url;//root.episodeNum刚好是下一集的索引
                                                tx.executeSql('UPDATE Series SET historyEpisode="'+(root.episodeNum+1)+'" WHERE id="'+root.episodeId+'"');
                                                playerListLoader.reloadList();
                                                break;
                                            }
                                        }

                                    }
                                }
                            }

                        });
            if(sourceUrl === undefined)
                return;
            //console.log("下一集sourceUrl",sourceUrl);
            var url = "http://v.baidu.com"+sourceUrl
            worker.getVideoRealUrls(url);
            //将下一集置为当前集
            root.episodeNum = root.episodeNum+1
            root.url = url;
        }
        function fastSeek(index,percent)
        {
            console.log("fastSeek",index,percent)
            if(readyPlayerList.playingIndex === index)//seek是当前片
            {
                if(readyPlayerList.playingIndex%2===0)
                {
                    player1.seek(percent*player1.duration);
                }else
                {
                    player2.seek(percent*player2.duration);
                }
                return;

            }
            readyPlayerList.playingIndex = index;//seek到其它片，
            player1.stop();
            player2.stop()
            if(index%2===0)//用player1播放
            {
                player1.source =  worker.getDerectUrl(readyPlayerList.get(index).realUrl);
                player1.play();
                if(index+1 >readyPlayerList.count-1)
                    return;
                player2.source =  worker.getDerectUrl(readyPlayerList.get(index+1).realUrl);
                //player1.seek(percent*player1.duration)
                console.log("player1.source:",player1.source,player2.source)
            }else//用player2播放
            {
                player2.source = worker.getDerectUrl(readyPlayerList.get(index).realUrl);
                player2.play();
                if(index+1 >readyPlayerList.count-1)
                    return;
                player1.source = worker.getDerectUrl(readyPlayerList.get(index+1).realUrl);
                //player2.seek(percent*player2.duration)
            }
        }

    }

    Rectangle{
        id:playerListTopBar
        visible:playerListLoader.visible
        anchors.top: backgroundItem.top
        anchors.right: backgroundItem.right
        width: 240
        height:30
        anchors.margins: 1
        color: "#BB000000"
        Image {
            id:syncBtn
            width: 26
            height: 26
            anchors.centerIn: parent
            source: "qrc:/images/images/sync.png";

            opacity:0.6
            NumberAnimation on rotation { running: root.isSyncData; from: 0; to: 360; loops: Animation.Infinite; duration: 1200 }
            MouseArea{
                anchors.fill: parent;
                hoverEnabled : true
                onClicked: {
                    if(!root.isSyncData)
                        root.syncData();
                }
                onEntered: syncBtn.opacity = 0.9
                onExited: syncBtn.opacity = 0.6
            }
        }
    }
    Loader {
        id: playerListLoader
        anchors.top: playerListTopBar.bottom
        anchors.right: backgroundItem.right
        anchors.bottom: controlPanel.top
        width: playerListTopBar.width
        anchors.margins: 1
        anchors.bottomMargin: 0
        function reloadList()
        {
            //console.log("reload")
            playerListLoader.source = ""

            playerListLoader.source = "qrc:/player/PlayerList.qml"
        }
        Connections {
            target: playerListLoader.item
            //signal playVideo(string episodeId,string episodeNum,string url)
            onPlayVideo: {
                //console.log(episodeId,episodeNum,url)
                //将url交给c++的worker进行解析，信号传回视频直链url
                root.episodeId = episodeId;
                root.episodeNum = episodeNum;
                root.url = url;

                worker.getVideoRealUrls(url);
                playerListLoader.reloadList();
            }
            onDeleteEpisode: {
                //deleteEpisode(episodeId)
                var a = "";
                a = episodeId;
                var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
                db.transaction(
                            function(tx) {

                                tx.executeSql('DELETE FROM Series WHERE id="'+a+'"');
                            });
                playerListLoader.reloadList();
            }
        }

        Connections {
            target: worker
            onCallQmlplay:{//将信号传回视频直链videoUrlList进行播放
                //signals: callQmlplayer(QString videoUrlList);//以#分隔每个地址
                var urls = videoUrlList;
                var urlList=urls.split('#');
                readyPlayerList.clear();
                //                console.log(urlList)
                for(var i=0;i<urlList.length;++i)
                {
                    readyPlayerList.append({"realUrl":urlList[i]})
                }
                playerWin.playNewVideo();
            }
            onSendBusyState:{//arg<<isBusy
                root.isWorkerBusy = isBusy
                busyIndicator.text = "正在解析"
            }
        }
        Component.onCompleted: {
            playerListLoader.reloadList();
        }
    }

    ControlPanel{
        id:controlPanel
        height: 60
        anchors.left: backgroundItem.left
        anchors.right: backgroundItem.right
        anchors.bottom: backgroundItem.bottom
        count: readyPlayerList.count
        index: readyPlayerList.playingIndex
        playState: {
            if(readyPlayerList.playingIndex%2===0)
            {
                if(player1.status === AVPlayer.Buffered && player1.playbackState === 1)
                {
                    return "play"
                }else
                {
                    return "pause"
                }
            }else
            {
                if(player2.status === AVPlayer.Buffered && player2.playbackState === 1)
                {
                    return "play"
                }else
                {
                    return "pause"
                }
            }
        }

    }
    Rectangle{
        id:busyIndicator
        anchors.top: playerWin.top
        anchors.left: playerWin.left
        anchors.margins: 10
        color: "transparent"
        border.width: 1
        border.color: "#40FFFFFF"
        radius: 5
        visible: (root.isWorkerBusy || root.isPlayBuffing)
        property string text: ""
        Image {
            id: busyIndicatorImg
            width: 32
            height: 32
            source: "qrc:/images/images/busy.png";
            visible:busyIndicator.visible
            NumberAnimation on rotation { running: busyIndicator.visible; from: 0; to: 360; loops: Animation.Infinite; duration: 1200 }

        }
        Text {
            id: busyIndicatorText
            text: qsTr(busyIndicator.text)
            anchors.left: busyIndicatorImg.right
            anchors.leftMargin: 3
            color: "white"
            font.pixelSize: 24
            y:4
        }

    }

    Connections{
        target:controlPanel
        onSeekSiganl:{//seekSiganl(int index,real percent)
            playerWin.fastSeek(index,percent)
        }

        onPlayStateExchange:{
            console.log("change")
            if(readyPlayerList.playingIndex%2===0)
            {
                console.log(player1.playbackState)//playbackState 1播放，2暂停，0停止
                if(player1.playbackState === 1)
                {
                    player1.pause()
                }else
                {
                    player1.play()
                }
            }else
            {
                if(player2.playbackState === 1)
                {
                    player2.pause()
                }else
                {
                    player2.play()
                }
            }
        }
    }

    function syncData(){//同步剧集数据
        root.isSyncData = true;
        var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
        db.transaction(
                    function(tx) {
                        //表格Series(id TEXT, videoType TEXT,videoName TEXT, videosUrl TEXT, selectSourceName TEXT,selectSite TEXT,  historyEpisode TEXT)

                        var rs = tx.executeSql('SELECT * FROM Series');
                        for(var i = 0; i < rs.rows.length; i++) {
                            var id = rs.rows.item(i).id;
                            var videoType = rs.rows.item(i).videoType;
                            var selectSite = rs.rows.item(i).selectSite;

                            var videosUrl;
                            if(videoType === "movie")//加入&site=指定来源,对movie无效
                            {
                                videosUrl = worker.getPageHtml("http://v.baidu.com/movie_intro/?dtype=playUrl&service=json&e=1&id="+id+"&site="+selectSite);
                            }else if(videoType === "tv")
                            {
                                videosUrl = worker.getPageHtml("http://v.baidu.com/tv_intro/?dtype=tvPlayUrl&e=1&service=json&id="+id+"&site="+selectSite);
                            }else if(videoType === "show")
                            {
                                videosUrl = worker.getPageHtml("http://v.baidu.com/show_intro/?dtype=tvshowPlayUrl&service=json&id="+id+"&site="+selectSite);
                            }else if(videoType === "comic")
                            {
                                videosUrl = worker.getPageHtml("http://v.baidu.com/comic_intro/?dtype=comicPlayUrl&service=json&id="+id+"&site="+selectSite);
                            }
                            root.isSyncData = false;
                            //console.log(videosUrl);
                            if(videosUrl===undefined)
                            {
                                return;
                            }else
                            {
                                //console.log("UPDATE Series SET videosUrl='"+videosUrl+"' WHERE id='"+id+"'");
                                tx.executeSql("UPDATE Series SET videosUrl='"+videosUrl+"' WHERE id='"+id+"'");

                            }

                        }
                        root.reloadPlayerList();

                    }
                    );

    }
    Component.onCompleted: {
        //root.syncData();
    }

}
