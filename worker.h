#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QEventLoop>
#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QDesktopServices>
#include "videoanalyzer.h"
class Worker : public QObject//唯一与qml界面交互的功能类
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = 0);

signals:
    void callQmlplay(QString videoUrlList);//以#分隔每个地址
    void sendBusyState(bool isBusy);//告诉qml,worker是否处于busy.
public slots:
    void getVideoRealUrls(QString pageUrl);//从视频来源的播放页pageUrl，得到真实的videoUrlList
    QString getDerectUrl(QString url);//获取有重定向网址直链

    void setEpisodeId(int episodeId);
    void setVideoClarity(int videoClarity);
    int getEpisodeId();

    QString searchMagnets(QString keyword);//搜索磁力链，返回json格式结果
    void openLocalMagnetLink(QString link);//调用本地磁力链下载软件

    QString getPageHtml(QString url);//得到url源码
private slots:

private:
    QNetworkAccessManager *manager;
    VideoAnalyzer *videoAnalyzer;
    int episodeId;

    //
    int videoClarity;//清晰度等级1-10,10最清晰，软件启动时由qml查询数据库后调用本类setVideoClarity得到。
};

#endif // WORKER_H
