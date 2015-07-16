import QtQuick 2.1
import QtQuick.Window 2.2
import QtAV 1.5
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "qrc:/videosList"
import "qrc:/navMenu"
import "qrc:/videoDetail"
import "qrc:/player"
import "qrc:/components"
import "qrc:/Magnet"

//import "qrc:/Fun.js" as funtions
Window {
    id:mainWindow
    visible: true
    width:  Math.min(Screen.desktopAvailableWidth,1180)
    height: Math.min(Screen.desktopAvailableHeight,666)
    title : "影视集结号 4.0"
    x: (Screen.desktopAvailableWidth - width)/2
    y: (Screen.desktopAvailableHeight - height)/2
    property bool blurBackground: false
    property bool isFullScreen: false
    QtObject {
        id: settings
        // These are used to scale fonts according to screen size
        property real _scaler: 400 + mainWindow.width * mainWindow.height * 0.00015
        property int fontXS: _scaler * 0.032
        property int fontS: _scaler * 0.040
        property int fontM: _scaler * 0.046
        property int fontMM: _scaler * 0.064
        property int fontL: _scaler * 0.100
        //
        property bool showParticles: true//粒子效果开头
        property int videoClarity:10//清晰度
    }
    CentralArea{//中心区域，填充mainWindow，已加背景和星星粒子效果
        id:centralArea
        anchors.fill: parent
        color:"transparent"
        VideosListView{//视频图片展示列表，是一个gridview
            id:videosListView
            anchors.centerIn: parent
            width: centralArea.width*0.9
            height: centralArea.height*0.9
            clip: true
        }
    }
    FastBlur{//快速模糊，用于背景
        id:backgroundBlur
        anchors.fill: parent
        source: centralArea
        radius: 32
        visible: blurBackground
        MouseArea{
            anchors.fill: parent
            onClicked: {
                mainWindow.blurBackground = false;
                navPanel.hide();
                videoDetailsView.hide();
                player.hide();
                magnetId.hide();
            }
        }
        NumberAnimation {
            id:showBlur
            targets: [backgroundBlur]; properties: "radius"; duration: 300
            from: 0;to:32;
        }
        NumberAnimation {
            id:hideBlur
            targets: [backgroundBlur]; properties: "radius"; duration: 300
            from: 32;to:0;
        }
        onVisibleChanged: {
            if(backgroundBlur.visible)
            {
                showBlur.start();
            }else{
                hideBlur.start();
            }
        }
    }
    //各类弹出式面板++++++++++++++++++++++++++++++++++++++
    NavPanel{//菜单分类导航面板
        id:navPanel
        anchors.centerIn: parent
        width: mainWindow.width*0.8
        height: mainWindow.height*0.8
        onUrlExcludePageNumChanged: {
            videosListView.urlExcludePageNum = navPanel.urlExcludePageNum;
            videosListView.pageNum = 1;
            videosListView.setList(videosListView.urlExcludePageNum,1)
        }
    }
    VideoDetailsView{//视频详细信息页
        id:videoDetailsView
        onIsShownChanged: {
            mainWindow.blurBackground = videoDetailsView.isShown;
        }
        onColectNewVideo:{
            player.reloadPlayerList();

        }
    }
    Player{//播放器页
        id:player
    }
    Settings{//设置页
        id:settingsId
        anchors.right: showSettingsBtn.left
        anchors.rightMargin: 1
        anchors.bottom: showSettingsBtn.verticalCenter
        //anchors.bottomMargin: 1
    }
    Search{
        id:searchId
        anchors.right: showSearchBtn.left
        anchors.rightMargin: 1
        anchors.top: showSearchBtn.verticalCenter
        onSearch: {
            videosListView.search(keyword);
        }
    }
    Magnet{
        id:magnetId

    }

    //各类按钮++++++++++++++++++++++++++++++++++++++
    Rectangle{//按钮，显示导航菜单
        id:showNavPanelBtn
        width: 60
        height: 60
        color:"transparent"
        anchors.right: centralArea.right
        anchors.verticalCenter: centralArea.verticalCenter
        anchors.rightMargin: 10
        visible: !blurBackground
        Image {
            source: "qrc:/images/images/list.png"
            anchors.fill: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                mainWindow.blurBackground = !mainWindow.blurBackground;
                navPanel.isShown?navPanel.hide():navPanel.show();
            }
        }
    }
    Rectangle{//按钮，显示播放器
        id:showPlayerBtn
        width: 60
        height: 60
        color:"transparent"
        visible: !blurBackground
        anchors.right: centralArea.right
        anchors.top: showNavPanelBtn.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 20
        Image {
            source: "qrc:/images/images/television.png"
            anchors.fill: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                mainWindow.blurBackground = !mainWindow.blurBackground;
                player.isShown?player.hide():player.show();

            }
        }
    }
    Rectangle{//按钮，显示磁力链搜索界面
        id:showMagnetBtn
        width: 55
        height: 55
        color:"transparent"
        visible: !blurBackground
        anchors.right: centralArea.right
        anchors.top: showPlayerBtn.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 20
        Image {
            source: "qrc:/images/images/magnet.png"
            anchors.fill: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                mainWindow.blurBackground = !mainWindow.blurBackground;
                magnetId.isShown?magnetId.hide():magnetId.show();
            }
        }
    }
    Rectangle{//按钮，显示设置界面
        id:showSettingsBtn
        width: 55
        height: 55
        color:"transparent"
        visible: !blurBackground
        anchors.right: centralArea.right
        anchors.top: showMagnetBtn.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 20
        Image {
            source: "qrc:/images/images/settings.png"
            anchors.fill: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                settingsId.isShown?settingsId.hide():settingsId.show();
            }
        }
    }

    Rectangle{//按钮，显示搜索界面
        id:showSearchBtn
        width: 55
        height: 55
        color:"transparent"
        visible: !blurBackground
        anchors.right: centralArea.right
        anchors.top: centralArea.top
        anchors.rightMargin: 10
        anchors.topMargin: 20
        Image {
            source: "qrc:/images/images/search.png"
            anchors.fill: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                searchId.isShown?searchId.hide():searchId.show();
            }
        }
    }
    //其它++++++++++++++++++++++++++++++++++++++
    Connections{
        target: videosListView
        onSelectedVideo:{
            mainWindow.blurBackground = !mainWindow.blurBackground;
            videoDetailsView.isShown?videoDetailsView.hide():videoDetailsView.show();
            var videoType;
            //console.log("urlExcludePageNum",navPanel.urlExcludePageNum)
            if(navPanel.urlExcludePageNum.indexOf("movie2level")>-1)
            {
                videoType = "movie"
            }else if(navPanel.urlExcludePageNum.indexOf("tvplay2level")>-1)
            {
                videoType = "tv"
            }else if(navPanel.urlExcludePageNum.indexOf("tvshow2level")>-1)
            {
                videoType = "show"
            }else if(navPanel.urlExcludePageNum.indexOf("comic2level")>-1)
            {
                videoType = "comic"
            }
            var videoType_tmp = videosListView.model.get(videosListView.grid.currentIndex).videoType;
            if(videoType_tmp !== undefined)
            {
                videoType = videoType_tmp;
            }


            videoDetailsView.image = videosListView.currentStoreImageUrl;
            videoDetailsView.title = videosListView.currentStoreTitle;
            videoDetailsView.date = videosListView.currentStoreDate;
            videoDetailsView.director = videosListView.currentStoreDirector;
            videoDetailsView.actor = videosListView.currentStoreActor;
            videoDetailsView.rating = videosListView.currentStoreRating;
            videoDetailsView.intro = videosListView.currentStoreIntro;

            videoDetailsView.storeId = videosListView.currentStoreId;
            videoDetailsView.videoType = videoType;

            videoDetailsView.getVideoSiteUrls(videoDetailsView.storeId)
        }
    }
    Connections{
        target: settings
        onShowParticlesChanged:mainWindow.writeSettings()
        onVideoClarityChanged:{
            //console.log("w")
            worker.setVideoClarity(settings.videoClarity);
            mainWindow.writeSettings();

        }
    }
    onIsFullScreenChanged: {
        if(mainWindow.isFullScreen)
        {
            mainWindow.showFullScreen();
        }else
        {
            mainWindow.showNormal();
        }
    }
    onBlurBackgroundChanged: {
        if(mainWindow.blurBackground)
        {
            settingsId.hide();
            searchId.hide();
        }
    }

    Component.onCompleted: {
        //videosListView.setList(videosListView.urlExcludePageNum,1);
        //mainWindow.showMaximized();
        var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
        db.transaction(
                    function(tx) {
                        //tx.executeSql('Drop table Series');//删除表
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Series(id TEXT, videoType TEXT,videoName TEXT, videosUrl TEXT, selectSourceName TEXT,selectSite TEXT, historyEpisode TEXT)');
                        //id：剧集唯一ID
                        //videoType:标识该视频所属大类，如movie(电影)、tv(电视剧)、comic(动漫)或show(综艺)
                        //videoName:剧集名称
                        //videosUrl：所有剧集的url，json格式，格式见最下方[1]，包含各SourceName的url
                        //selectSourceName：选择的剧集来源名，如爱奇艺，优酷，腾讯等，用于从videosUrl取出相应来源的url
                        //selectSite：选择的剧集来源的域名，如sohu.com;iqiyi.com
                        //historyEpisode：播放到的集数历史

                        //tx.executeSql('Drop table Settings');//删除表
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT PRIMARY KEY , value TEXT)');//软件设置保存表
                        //name:设置项名  value:值
                        //Settings表存储：videoClarity清晰度值；showParticles:粒子效果bool

                        mainWindow.readSettings();
                    });
    }
    function writeSettings(){
        var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
        db.transaction(
                    function(tx) {//未完成
                        tx.executeSql('REPLACE INTO Settings VALUES(?, ?)', [ "videoClarity", settings.videoClarity]);
                        tx.executeSql('REPLACE INTO Settings VALUES(?, ?)', [ "showParticles", settings.showParticles]);
        })
    }
    function readSettings(){
        var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
        db.transaction(
                    function(tx) {
                        //读取设置
                        var rs = tx.executeSql('SELECT * FROM Settings');
                        for(var i = 0; i < rs.rows.length; i++) {
                            var name = rs.rows.item(i).name;



                            if(name === "videoClarity")
                            {

                                var videoClarity = (rs.rows.item(i).value)===undefined?10:(rs.rows.item(i).value);
                                worker.setVideoClarity(videoClarity);
                                settings.videoClarity = videoClarity;

                            }else if(name === "showParticles")
                            {
                                //console.log(rs.rows.item(i).value)
                                var showParticles = (rs.rows.item(i).value)===undefined?true:(rs.rows.item(i).value);

                                settings.showParticles = showParticles;
                            }
                        }


                    })
    }


}
/*
[1]:
[
    {
        "link": "/link?url=dm_20Jg0HnMUvGItah1n_HsgNSTldM6y86QIgPH2_mcmfG-kOlPDUKfDzwB0IKO4Lo0NJbN-otgSU8fmve4Hx2OkP8M14bJfd20kcrE4pGByFWDbk8bODZnSHhHp4h1Qnh7_poKTgOlHvtTGUEy6i2PJ1dg..",
        "site": "hunantv.com",
        "name": "芒果TV",
        "logo": "http://vs3.bdstatic.com/logo/imgo_tv.gif",
        "big_logo": "",
        "ad": 0,
        "vision": 1,
        "speed": 0
    },
    {
        第二个源
    }
]
*/
