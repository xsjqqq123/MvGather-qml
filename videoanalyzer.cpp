#include "videoanalyzer.h"
#include <QDebug>
#include <QJSEngine>
#include <QFile>
#include <QTextStream>
#include <QJSValue>
#include <QJSValueList>
VideoAnalyzer::VideoAnalyzer(QObject *parent) :
    QObject(parent)
{
    manager = new QNetworkAccessManager(this);
}

QStringList VideoAnalyzer::analyze(QString pageUrl, int videoClarity)
{
    qDebug()<< pageUrl;

//目前使用flvsp.com解析
    QEventLoop loop;
    QByteArray url = pageUrl.replace("//","##").toLatin1();

    QFile scriptFile(":/base64.js");
    scriptFile.open(QIODevice::ReadOnly);
    QTextStream out(&scriptFile);
    QString contents = out.readAll();
    scriptFile.close();
    QJSEngine myEngine;
    QJSValue fun = myEngine.evaluate(contents);
    QJSValueList args;
    args << QJSValue(QString(url)) ;
    QJSValue base64_encode = myEngine.globalObject().property("base64_encode");

    QJSValue encodeResult = base64_encode.call(args).toString();
    //qDebug()<<encodeResult.toString();


    //qDebug()<<base64_encode(&a,strlen(&a));
    QNetworkRequest request;
    request.setUrl(QUrl("http://www.flvsp.com/parse/getData.php?url="+encodeResult.toString()));
    request.setRawHeader("Accept","text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01");
    request.setRawHeader("Accept-Encoding","gzip, deflate, sdch");
    request.setRawHeader("Referer","http://www.flvsp.com/?url=https://www.letv.com/ptv/vplay/22827477.html");
    request.setRawHeader("X-Requested-With","XMLHttpRequest");
    request.setRawHeader("User-Agent","Mozilla/5.0 (Linux; U; Android 4.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1  ");
    QNetworkReply *reply = manager->get(request);
    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();
    QString data = reply->readAll();
    qDebug()<<"get flvsp data start";
    QStringList videoClarityList = data.split("panel-heading");
    if(videoClarityList.count()>2)
    {
        videoClarityList.removeFirst();
        videoClarityList.removeFirst();
    }else
    {
        return QStringList()<<"null";
    }

    //搜寻符合清晰度的视频
    int videoClarityIndex = 10-videoClarity;//flvsp的解析结果中排在前面的清晰度高
    QString videos;
    for(int i=0;i<10;i++)//往清晰度低的方向查找合适的
    {
        videos = videoClarityList.value(videoClarityIndex+i,"");
        if(videos.isEmpty())
        {
            continue;
        }else
        {
            break;
        }
    }
    if(videos.isEmpty())//上述循环找不到，往清晰度高的方向找
    {
        for(int i=0;i<10;i++)
        {
            videos = videoClarityList.value(videoClarityIndex-i,"");
            if(videos.isEmpty())
            {
                continue;
            }else
            {
                break;
            }
        }
    }


    qDebug()<<"get flvsp data end";
    //得到真实地址列表realUrlList
    QStringList realUrlList;
    QRegExp rx("class=\"file_url\" href=\".*\"");
    rx.setMinimal(true);
    int pos = 0;
    while ((pos = rx.indexIn(videos, pos)) != -1) {
        QString href = rx.cap(0);
        realUrlList.append(href.replace(QRegExp("class=\"file_url\" href=\"|\""),""));
        pos += rx.matchedLength();
    }
    qDebug()<<realUrlList;

    return realUrlList;

}
