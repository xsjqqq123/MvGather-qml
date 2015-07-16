import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Flickable {
    id:root
    flickableDirection: Flickable.VerticalFlick
    width: 240
    contentWidth: 240
    clip: true
    signal playVideo(string episodeId,string episodeNum,string url)
    signal deleteEpisode(string episodeId)

    TreeView {
        anchors.fill: parent
        id: tree
        model: modelTree2
        //onSelectedItemChanged: console.log(item.tag,modelTree2)
        onItemDoubleClicked:{
            if(item.url !== undefined)
            {
                root.playVideo(item.episodeId,item.episodeNum,item.url);
                //console.log(item.episodeId,item.episodeNum,item.url)
            }
        }
        onDeleteEpisode: {
            //console.log(item.episodeId)
            root.deleteEpisode(item.episodeId)
        }
    }
    //滚动条
    ScrollBar {
        id: verticalScrollBar
        width: 12; height: tree.height
        anchors.right: tree.right
        opacity: 1
        orientation: Qt.Vertical
        position: tree.visibleArea.yPosition
        pageSize: tree.visibleArea.heightRatio
    }

    ListModel {
        id: modelTree2
    }
    Component.onCompleted: {//重新从数据库中加载列表
        //Series(id TEXT, videoType TEXT,videoName TEXT, videosUrl TEXT, selectSourceName TEXT, historyEpisode TEXT)
        var db = LocalStorage.openDatabaseSync("mvgather", "4.0", "影视集结号本地数据库!", 1000000);
        db.transaction(
                    function(tx) {
                        var arrayData = new Array;
                        var rs = tx.executeSql('SELECT * FROM Series');
                        for(var i = 0; i < rs.rows.length; i++) {
                            //var jsonStr = JSON.parse(rs.rows.item(i).videosUrl);
                            var episodeId = rs.rows.item(i).id;
                            var videoType = rs.rows.item(i).videoType;
                            var EpisodeName = rs.rows.item(i).videoName;
                            var videosUrlJson = JSON.parse(rs.rows.item(i).videosUrl);
                            var selectSourceName = rs.rows.item(i).selectSourceName;
                            var historyEpisode = rs.rows.item(i).historyEpisode;

                            var items = new Array;
                            var a = 0;
                            var url="";
                            var item;
                            if(videoType === "movie")
                            {
                                for(a=0;a<videosUrlJson.length;a++)
                                {
                                    if(videosUrlJson[a].name === selectSourceName)
                                    {
                                        url = "http://v.baidu.com"+videosUrlJson[a].link
                                        item = {title: "第1集",episodeId:episodeId,episodeNum:1,url:url}
                                        items.push(item)
                                    }
                                }
                            }else
                            {
                                for(a=0;a<videosUrlJson.length;a++)
                                {
                                    if(videosUrlJson[a].site_info.name === selectSourceName)
                                    {
                                        for(var b=videosUrlJson[a].episodes.length-1;b>=0;b--)
                                        {
                                            url = "http://v.baidu.com"+videosUrlJson[a].episodes[b].url
                                            var title = "" ;
                                            title+="第"+(b+1)+"集";
                                            title+=(parseInt(historyEpisode) === parseInt(b+1)?"(上次播放处)":"");
                                            item = {title: title,episodeId:episodeId,episodeNum:b+1,url:url}
                                            items.push(item);
                                        }
                                    }
                                }
                            }

                            var episodeObj = {title: EpisodeName,episodeId:episodeId,items:items};
                            arrayData.push(episodeObj)

                        }
                        modelTree2.append(arrayData);
                    });

        /* arrayData格式如下
        [
        {title: "EpisodeName1",episodeId:"EpisodeId1"},
        {title: "EpisodeName2",episodeId:"EpisodeId2",items: [
                    {title: "第EpisodeNum1集",episodeId:"EpisodeId2",episodeNum:"EpisodeNum1",url:"url1"},
                    {title: "第EpisodeNum2集",episodeId:"EpisodeId2",episodeNum:"EpisodeNum2",url:"url2"},
                    {title: "第EpisodeNum3集",episodeId:"EpisodeId2",episodeNum:"EpisodeNum3",url:"url3"},
                ]}
        ]
*/
    }
}
