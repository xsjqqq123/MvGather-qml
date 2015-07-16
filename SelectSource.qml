import QtQuick 2.0

Item {
    id:root
    property alias gridA: grid
    property alias m_model: m_model
    Component {
        id: delegate
        Item {
            width: grid.cellWidth; height: grid.cellHeight
            AnimatedImage { id:img;source: logo; anchors.top: parent.top;anchors.topMargin: 3
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: qsTr(name)
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 4
                color:"white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    GridView {
        id: grid
        anchors.fill: parent
        cellWidth: 60; cellHeight: 40
        model: ListModel {id:m_model;}
        delegate: delegate
        highlight: Rectangle { color: "#30FFFFFF"; radius: 5 }
        focus: true
        clip:true
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(grid.indexAt(mouseX,mouseY)>-1)
                    grid.currentIndex = grid.indexAt(mouseX,mouseY);
            }
        }
    }
}
