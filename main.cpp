#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "worker.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Worker *worker=new Worker;
    engine.rootContext()->setContextProperty("worker", worker);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
