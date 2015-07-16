import QtQuick 2.0
import QtQuick.Controls 1.2


/**
树控件
第一作者：surfsky.cnblogs.com 2014-10
第二作者：mvgather.com 2015-05
协议：MIT 请保留本文档说明
第一作者添加功能
    /递归树显示
    /左侧一个箭头，点击可展开显示子树
    /选中节点变色
    /节点点击事件
    /tag属性，携带类似id的数据
    异步方式，点击箭头后请求子数据。异步模式的话，节点要加上isLeaf属性，点击箭头后动态加载数据
第二作者添加功能
    root节点添加删除信号功能
    双击可展开项可展开
存在的问题
model clear会出错，即无法直接清空

使用参考 http://qt-project.org/forums/viewthread/30521/
*/
Flickable {
    id: view

    implicitWidth: 200
    implicitHeight: 160
    contentHeight: content.height
    // 输入属性
    property var model
    property int rowHeight: 40
    property int columnIndent: 20
    property string expanderImage : "qrc:/images/images/expander.png";

    // 私有属性
    property var currentNode  // 当前节点数据
    property var currentItem  // 当前节点UI

    // 信号
    signal selectedItemChanged(var item)
    signal itemDoubleClicked(var item)
    signal deleteEpisode(var item)


    // 节点数据展示的UI
    property Component delegate: Label {
        id: label
        text: model.title ? model.title : 0
        font.pixelSize: view.rowHeight*0.4
        color: currentNode === model ?"#80FFFFFF":"white"
        property var episodeId : model.episodeId!==undefined?model.episodeId:""
        property var url : model.url!==undefined?model.url:""
        property var episodeNum : model.episodeNum!==undefined?model.episodeNum:""

    }

    //
    Loader {
        id: content
        onLoaded: item.isRoot = true
        sourceComponent: treeBranch
        property var items: model

        // 背景条纹
        Column {
            anchors.fill: parent
            Repeater {
                model: 1 + Math.max(view.contentItem.height, view.height) / rowHeight
                Rectangle {
                    objectName: "Faen"
                    color: index % 2 ? "#40303030" : "#60303030"
                    //border.color: "#40303030"
                    width: view.width ; height: rowHeight
                }
            }
        }

        // 树节点组件
        Component {
            id: treeBranch
            Item {
                id: root
                property bool isRoot: false
                implicitHeight: column.implicitHeight
                implicitWidth: column.implicitWidth
                Column {
                    id: column
                    x: 2
                    Item { height: isRoot ? 0 : rowHeight; width: 1}
                    Repeater {
                        model: items
                        Item {
                            id: filler
                            width: Math.max(loader.width + columnIndent, row.width)
                            height: Math.max(row.height, loader.height)
                            property var _model: model
                            // 当前行背景色块
                            Rectangle {
                                id: rowfill
                                x: view.mapToItem(rowfill, 0, 0).x
                                width: view.width
                                height: rowHeight
                                visible: currentNode === model
                                color: "transparent"
                            }
                            // 行点击响应区域
                            MouseArea {
                                anchors.fill: rowfill
                                onPressed: {
                                    currentNode = model
                                    currentItem = loader
                                    forceActiveFocus()
                                    selectedItemChanged(model);

                                }
                                onDoubleClicked: {
                                    loader.expanded = !loader.expanded
                                    itemDoubleClicked(model);
                                }
                            }
                            // 行数据UI
                            Row {
                                id: row
                                // 行图标
                                Item {
                                    width: rowHeight
                                    height: rowHeight
                                    opacity: !!model.items ? 1 : 0
                                    Image {
                                        id: expander
                                        source: view.expanderImage
                                        height: view.rowHeight * 0.6
                                        fillMode: Image.PreserveAspectFit
                                        opacity: mouse.containsMouse ? 1 : 0.7
                                        anchors.centerIn: parent
                                        rotation: loader.expanded ? 90 : 0
                                        Behavior on rotation {NumberAnimation { duration: 120}}
                                    }
                                    MouseArea {
                                        id: mouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: loader.expanded = !loader.expanded
                                    }
                                }
                                // 行文本
                                Loader {
                                    property var model: _model
                                    sourceComponent: delegate
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                //删除按钮
                                Item {
                                    width: rowHeight
                                    height: rowHeight
                                    visible: root.isRoot
                                    Image {
                                        id: deleteBtn
                                        source: "qrc:/images/images/close.png"
                                        height: view.rowHeight * 0.6
                                        fillMode: Image.PreserveAspectFit

                                        anchors.centerIn: parent
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            //console.log(model.episodeId)
                                            deleteEpisode(model)
                                        }

                                    }
                                }
                            }

                            // 子树（递归自身）
                            Loader {
                                id: loader
                                x: columnIndent
                                height: expanded ? implicitHeight : 0
                                property var node: model
                                property bool expanded:  {
                                    //console.log(worker.getEpisodeId(),model.episodeId,worker.getEpisodeId() === model.episodeId)
                                    return worker.getEpisodeId().toString() === model.episodeId.toString()
                                }
                                    //false
                                property var items: model.items
                                property var text: model.title
                                sourceComponent: (expanded && !!model.items) ? treeBranch : undefined
                            }
                        }
                    }
                }
            }
        }
    }
}
