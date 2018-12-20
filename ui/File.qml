import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.centerIn: parent
        spacing: parent.height / 15

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Choose the disk image file")
        }

        Button {
            id: btn
            enabled: !isBurning
            anchors.horizontalCenter: parent.horizontalCenter
            width: btnLabel.text == "+" ? parent.width / 8 : parent.width * 3 / 2
            scale: 0.8
            Label {
                id: btnLabel
                anchors.centerIn: parent
                text: "+"
                width: parent.width - 6
                elide: Text.ElideMiddle
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: parent.height / 4 > 0 ? parent.height / 4 : 10
            }

            onClicked: {
                fd.open()
            }
            hoverEnabled: true
            ToolTip.text: qsTr("Click to choose disk image")
            ToolTip.delay: 1000
            ToolTip.visible: hovered
            ToolTip.timeout: 3000
        }

        Image {
            id: diskImageIcon
            smooth: true
            mipmap: true
            scale: 1
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/iso.svg"
            Behavior on scale {
                PropertyAnimation {
                    easing.overshoot: 2
                    easing.type: Easing.OutBack
                    duration: 200
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        onEntered: {
            diskImageIcon.scale = 1.2
        }

        onExited: {
            diskImageIcon.scale = 1.0
        }

        onDropped: {
            diskImageIcon.scale = 1.0
            console.log(drop.text)
        }
    }

    FileDialog {
        id: fd
        title: qsTr("Please choose the disk image")
        folder: helper.downloadsFolderPath()
        nameFilters: [qsTr("Disk images") + " (*.iso *.bin *.img *.ISO *.BIN *.IMG)"]
        onAccepted: {
            var path = fd.fileUrl.toString();
            if (helper.preProcessImageFile(path)) {
                filePath = path
                fileName = helper.fileNameFromPath(filePath)
                btnLabel.text = fileName
            }
        }
        onRejected: {
            btnLabel.text = fileName != "" ? fileName : "+"
        }
        visible: false
        Component.onCompleted: {
            fd.close()
        }
    }

    Component.onCompleted: {
        var fp = helper.filePathFromArguments()
        if( fp !== "" && helper.preProcessImageFile(fp)) {
            filePath = helper.filePathFromArguments()
            fileName = helper.fileNameFromPath(filePath)
            btnLabel.text = fileName
        }
    }
}
