import QtQuick 2.1

Item{
    id:root

    //need set
    property int totalNum: 0

    //can get
    property int currentNum: 1
    onTotalNumChanged: {
        currentNum = 1;
        reset();
    }

    function reset(){
        model.clear();
        var startNum = (currentNum-5)>1?(currentNum-5):1
        var endNum = (currentNum +5)<totalNum?(currentNum +5):totalNum
        //console.log(startNum,endNum)
        for(var i=startNum;i<=endNum;i++)
        {
            model.append({"numTxt":i})

        }
    }
    GridView {
        id:view
        anchors.fill: parent
        width: cellWidth*model.count
        cellWidth:60
        cellHeight:45
        //flickableDirection:Flickable.HorizontalFlick
        model: model
        contentWidth:cellWidth*model.count
        clip:true
        contentHeight:40
        delegate: Rectangle {
            color: "transparent"
            //border.width: 1
            //border.color: "#80ffffff"
            width: 60
            height:35
            Rectangle{
                anchors.centerIn: parent
                width: 50
                height:30
                border.width: 1
                border.color: "#80ffffff"
                color: root.currentNum === numTxt?"#60FFFFFF":"transparent"
                radius: 5
                Text { text: numTxt ; anchors.centerIn: parent;color: "white";font.pixelSize: 25}

            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                var index = view.indexAt(mouse.x,mouse.y);
                if(index>-1)
                {
                    //view.currentIndex = index;
                    root.currentNum = model.get(index).numTxt
                    root.reset();
                }
            }
        }
    }
    ListModel {
        id:model
    }

}
