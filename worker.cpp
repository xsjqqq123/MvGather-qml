#include "worker.h"
#include <QDebug>
Worker::Worker(QObject *parent) :
    QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    videoAnalyzer = new VideoAnalyzer(this);
    this->videoClarity = 10;
}

void Worker::getVideoRealUrls(QString pageUrl)
{
    sendBusyState(true);
    //qDebug()<<"Worker::getVideoRealUrls "<<pageUrl;
    //将pageUrl转成真正的播放页
    QString realPageUrl;
    if(pageUrl.contains("baidu.com"))//pageUrl类似http://v.baidu.com/link?url=dm_00pw_klemzAqUjr-Q0lj09RpMh8y3IXB2wmtn7QZKkhV69q4QLARVTg1O9yL8l_vx0lGa6StZH-c9sbNoh3_LF1eiZDZighNC07mXOX9FvLkyzmF3u-PFjoWeRTG3HHdxoPUqgJZJ-jBTQjBfCP4Qlw8giBsmDWOag8AAMPfnZJh_5lbUr0OlAFpDVtH0S_ElMo9C54w..
    {
        QEventLoop loop;
        QNetworkReply *reply = manager->get(QNetworkRequest(pageUrl));
        connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
        loop.exec();
        QString data = reply->readAll();
        QRegExp rx("href=\".*\"");
        rx.setMinimal(true);
        if(rx.indexIn(data)>-1)
        {
            QString href = rx.cap(0);
            realPageUrl = href.replace(QRegExp("href=\"|\""),"");
        }
    }else
    {
        realPageUrl = pageUrl;
    }
    //用视频解析类将realPageUrl解析成真实地址
    QStringList resultList = videoAnalyzer->analyze(realPageUrl,this->videoClarity);

    //qDebug()<<realPageUrl<<resultList;
    //将解析器输出转成url1#url2#url3，#分隔,并提醒qml播放

    emit callQmlplay(resultList.join('#'));
    sendBusyState(false);
}

QString Worker::getDerectUrl(QString url)
{
    int tryTimes=5;
    //尝试tryTimes次
    QString realUrl_temp = url;
    while(tryTimes --)
    {
        QEventLoop loop;
        QNetworkRequest request;
        request.setUrl(QUrl(realUrl_temp));
        request.setRawHeader("User-Agent","Mozilla/5.0 (iPhone; CPU iPhone OS 511 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3");

        if(url.contains("1905.com"))
        {
            request.setRawHeader("Referer","1905.com");
        }else
        {
            request.setRawHeader("Referer",url.toLatin1());
        }

        QNetworkReply *reply = manager->head(request);
        connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
        loop.exec();
        QVariant varLocation = reply->header(QNetworkRequest::LocationHeader);
        //qDebug()<<reply->rawHeader("Location");
        if(!varLocation.isNull())
        {
            realUrl_temp = varLocation.toString();
            //qDebug()<<realUrl_temp;
            continue;
        }
        delete reply;
        break;
    }
    qDebug()<<realUrl_temp;
    return realUrl_temp;
}

void Worker::setEpisodeId(int episodeId)
{
    this->episodeId = episodeId;
}

int Worker::getEpisodeId()
{
    return this->episodeId;
}

QString Worker::searchMagnets(QString keyword)
{
    QString returnJson;//返回 {"data":[{"title":"info","magnet":""},{"":"","":""}]}
    returnJson.append("{\"data\":[");
    QEventLoop loop;
    QNetworkReply *reply = manager->get(QNetworkRequest("http://cililian.me/list/"+keyword));
    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();
    QString data = reply->readAll();
//qDebug()<<data;
    QStringList seriesList = data.split("T1");
    if(seriesList.count()>0)
        seriesList.removeFirst();
    QRegExp rx_file_title("<a name=.*</a>");
    rx_file_title.setMinimal(true);
    QRegExp rx_BotInfo("<dt>.*</dt>");
    rx_BotInfo.setMinimal(true);
    QRegExp rx_magnet("magnet.*\"");
    rx_magnet.setMinimal(true);
    int count = seriesList.count();
    foreach (QString single, seriesList) {
        QString file_title;
        QString file_info;
        QString file_magnet;
        if(rx_file_title.indexIn(single)>-1)
        {
            //qDebug()<<"rx_file_title";
            file_title = rx_file_title.cap(0);
            QRegExp rx("<.*>");
            rx.setMinimal(true);
            file_title = file_title.replace(rx,"");
        }
        if(rx_BotInfo.indexIn(single)>-1)
        {
            file_info = rx_BotInfo.cap(0);
            QRegExp rx("<.*>|&nbsp;");
            rx.setMinimal(true);
            file_info = file_info.replace(rx,"");
            file_info = file_info.replace("\n",";");
        }
        if(rx_magnet.indexIn(single)>-1)
        {
            file_magnet = rx_magnet.cap(0);
            file_magnet = file_magnet.replace("\"","");
        }
        returnJson.append("{");
        returnJson.append("\"title\":\""+file_title+"\",");
        returnJson.append("\"info\":\""+file_info+"\",");
        returnJson.append("\"magnet\":\""+file_magnet+"\"");
        //qDebug()<<file_title<<file_info<<file_magnet<<"\n++++++++++++";
        count--;
        if(count>0)
        {
            returnJson.append("},");
        }else
        {
            returnJson.append("}");
        }

    }
    returnJson.append("]}");
    return returnJson;
}

void Worker::openLocalMagnetLink(QString link)
{
    QDesktopServices::openUrl(QUrl(link, QUrl::TolerantMode));
}

QString Worker::getPageHtml(QString url)
{
    QEventLoop loop;
    QNetworkReply *reply = manager->get(QNetworkRequest(url));
    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();
    QString data = reply->readAll();
    return data;
}

void Worker::setVideoClarity(int videoClarity)
{
    this->videoClarity = videoClarity;
}

