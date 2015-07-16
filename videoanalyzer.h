#ifndef VIDEOANALYZER_H
#define VIDEOANALYZER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QEventLoop>
#include <QTimer>
#include <QByteArray>
class VideoAnalyzer : public QObject
{
    Q_OBJECT
public:
    explicit VideoAnalyzer(QObject *parent = 0);

signals:

public slots:
    QStringList analyze(QString pageUrl,int videoClarity=0);//videoClarity清晰度级别，1-10,10最清晰
private slots:
private:
    QNetworkAccessManager *manager;

};

#endif // VIDEOANALYZER_H
