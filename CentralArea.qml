import QtQuick 2.0
import QtQuick.Particles 2.0
Rectangle {
    anchors.fill: parent
    Image {
        id: backgroundImg
        source: "qrc:/images/images/background.png"
        anchors.fill: parent
    }
    ParticleSystem {//background star
        anchors.fill: parent
        paused: blurBackground || !settings.showParticles
        ImageParticle {
            source: "qrc:/images/images/star.png"
            color: "#ffefaf"
            colorVariation: 0.1
            alpha: 0
        }
        Emitter {
            id: shootingStarEmitter
            width: mainWindow.width;
            height: mainWindow.width;
            emitRate: 10
            lifeSpan: 4000
            velocity: PointDirection {xVariation: 8; yVariation: 8;}
            acceleration: PointDirection {xVariation: 12; yVariation: 12;}
            size: 30
            sizeVariation: 8
        }

    }
}
