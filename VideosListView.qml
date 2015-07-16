import QtQuick 2.0

Rectangle {//
    id:root
    color: "transparent"
    property string currentStoreId
    property string currentStoreImageUrl
    property string currentStoreTitle
    property string currentStoreDate
    property string currentStoreDirector
    property string currentStoreActor
    property string currentStoreRating
    property string currentStoreIntro


    property string urlExcludePageNum: "http://v.baidu.com/commonapi/movie2level/?filter=false"
    property int pageNum: 1
    property alias model: model
    property alias grid: grid
    property int totalNum: 0
    signal selectedVideo
    GridView {
        id:grid
        anchors.fill: parent
        cellWidth: mainWindow.width*0.9/Math.floor(mainWindow.width/210)
        cellHeight: cellWidth*1.4
//        leftMargin: (root.width-grid.contentWidth)/2

        //flickableDirection:Flickable.HorizontalFlick

        focus: true
        model: model
        delegate: Rectangle{
            id:delegate
            width:grid.cellWidth*0.8
            height:grid.cellHeight*0.8
            color:"transparent"
            Column{
                id:container
                spacing: 4
                anchors.centerIn: parent
                width: delegate.width
                height: delegate.height
                BorderImage {
                    width: container.width
                    height:container.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    border { left: 5; top: 5; right: 5; bottom: 5 }
                    horizontalTileMode: BorderImage.Repeat
                    verticalTileMode: BorderImage.Repeat
                    source: (grid.currentIndex==index && img.status == Image.Ready)?"qrc:/images/images/border_select.png":"qrc:/images/images/border.png"
                    BusyIndicator { anchors.centerIn: parent; on: img.status != Image.Ready }
                    Image {
                        id:img
                        width: container.width-10
                        height:container.height-10
                        anchors.centerIn: parent
                        //cache: false
                        source: imgv_url
                    }
                }

                Text {
                    elide:Text.ElideRight
                    width: container.width
                    height: parent.height/6
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: s_intro;
                    clip:true
                    font.pixelSize: parent.width/12
                    color: "white"
                    horizontalAlignment:Text.AlignHCenter

                }


            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    grid.currentIndex=index
                    root.currentStoreId = grid.model.get(index).storeId;
                    root.currentStoreImageUrl = grid.model.get(index).imgv_url;
                    root.currentStoreTitle = grid.model.get(index).title
                    root.currentStoreDate = grid.model.get(index).date
                    root.currentStoreDirector = grid.model.get(index).director
                    root.currentStoreActor = grid.model.get(index).actor
                    root.currentStoreRating = grid.model.get(index).rating
                    root.currentStoreIntro = grid.model.get(index).intro

                    root.selectedVideo()
                }

            }
        }
        header: PagingConponent{
            totalNum: root.totalNum
            width: grid.width
            height: 40
            Connections{
                onCurrentNumChanged: {
                    root.setList(root.urlExcludePageNum,currentNum)
                }
            }


        }
    }
    ListModel {
        id:model
    }
    function setList(m_urlExcludePageNum,m_pageNum){
        //console.log(m_urlExcludePageNum,m_pageNum);
        root.urlExcludePageNum = m_urlExcludePageNum;
        root.pageNum = m_pageNum
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange=function(){
            if(xmlhttp.readyState!==4) return;
            if(xmlhttp.status!==200)
            {
                console.log("Problem retrieving json data");
                return;
            }
            videosListView.model.clear();
            var json = JSON.parse(xmlhttp.responseText.toString());
            var videosArray = json.videoshow.videos;
            var total_num = Math.floor(json.total_num/18)+1
            root.totalNum = (total_num===undefined?0:total_num)
            for(var i=0;i<videosArray.length;++i){
                var o = videosArray[i];
                var title = o.title;
                var id = o.id.toString();
                var imgv_url = o.imgv_url;
                var s_intro = o.s_intro===undefined?"":o.s_intro;
                var date = o.date;

                var directorTmp = o.director;
                var director = "";
                if(directorTmp !== undefined)
                    for(var d=0;d<directorTmp.length;d++)
                    {
                        director += directorTmp[d].name;
                        director += " "
                    }
                var actors = o.actor;
                var actor = "";
                if(actors !== undefined)
                    for(var a=0;a<actors.length;a++)
                    {
                        actor += actors[a].name;

                        actor += " "
                    }
                var rating = o.rating
                rating = rating/10
                var intro = o.intro
                //                        console.log(actor)
                videosListView.model.append({"storeId":id
                                                ,"s_intro": title+"\n"+s_intro
                                                ,"title":title
                                                ,"imgv_url": imgv_url
                                                ,"date":date
                                                ,"director":director
                                                ,"actor":actor
                                                ,"rating":rating
                                                ,"intro":intro
                                            });
            }

        };
        xmlhttp.open("GET",m_urlExcludePageNum+"&pn="+m_pageNum,true);
        xmlhttp.send(null);
    }
    function search(keyword){
        root.totalNum = 0;//分页不显示
        var xmlhttp = new XMLHttpRequest();

        xmlhttp.onreadystatechange=function(){
            if(xmlhttp.readyState!==4) return;
            if(xmlhttp.status!==200)
            {
                console.log("Problem retrieving json data");
                return;
            }
            videosListView.model.clear();
            var data = xmlhttp.responseText.toString();
            //console.log(data);
            var json = JSON.parse(xmlhttp.responseText.toString());//蛋疼的返回结果
            var pagelets = json.pagelets;//
            for(var i=0;i<pagelets.length;i++)
            {
                if(pagelets[i].parent_id === "__elm_main__qk_7")
                {
                    var html = pagelets[i].html;
                    console.log(html,"\n","_________________________________________");
                    var ID =  html.match(/&id=\d{1,10}/);//&id=11120&
                    ID = ID[0].replace(/&id=/g,"")
                    console.log(ID);
                    var title=  html.match(/title=\".*?(?=")/);//
                    title = title[0].replace(/title=\"|\"/,"")
                    var s_intro = "";
                    var imgv_url=  html.match(/src=\".*?(?=")/);//&
                    imgv_url = imgv_url[0].replace(/src=\"|\"/,"")
                    imgv_url = imgv_url.replace(/&amp;/,"&")
                    console.log("search",ID,title,imgv_url);
                    var date = html.match(/\(\d{1,10}\)/);
                    date = date[0].replace(/\(|\)/,"")
                    var director = "";
                    var actor = "";
                    var rating = 0;
                    var intro = html.match(/class=\"brief\"\>.*?(?=\<)/);//
                    intro = intro[0].replace(/class=\"brief\"\>|\</,"")

                    var videoType =  "movie";
                    videoType = html.match(/id=\".*?(?=_)/);
                    videoType = videoType[0].replace(/id=\"|_/,"")
                    videosListView.model.append({"storeId":ID
                                                    ,"s_intro": title+"\n"+s_intro
                                                    ,"title":title
                                                    ,"imgv_url": imgv_url
                                                    ,"date":date
                                                    ,"director":director
                                                    ,"actor":actor
                                                    ,"rating":rating
                                                    ,"intro":intro
                                                    ,"videoType":videoType//搜索结果有多种类型，设置一个标记
                                                });
                }


            }

        };
        xmlhttp.open("GET","http://v.baidu.com/v?&ct=301989888&rn=20&pn=0&db=0&s=0&fbl=800&ie=utf-8&pagelets[]=main&pagelets[]=widget_log&force_mode=1&t=205083&word="+keyword,true);
        xmlhttp.setRequestHeader("X-Requested-With","XMLHttpRequest")
        xmlhttp.send(null);
    }


    Component.onCompleted: {
//        console.log(mainWindow.width)
        //search("屌丝男士")
    }

}
