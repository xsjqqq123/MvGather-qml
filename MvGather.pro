TEMPLATE = app

QT += qml quick av network gui

SOURCES += main.cpp \
    worker.cpp \
    videoanalyzer.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    worker.h \
    videoanalyzer.h

OTHER_FILES +=
