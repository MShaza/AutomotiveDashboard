import QtQuick 2.15

Item {
    id: root
    property alias label: labelText.text
    property alias lowLabel: lowText.text
    property alias highLabel: highText.text
    property int gap: 20
    property int barOffset: 5
    property color barColor: "#0BA6DF"
    property int blocks: 10

    width: 155
    height: parent.height

    Row {
        id: barRow
        spacing: 5
        anchors.bottom: parent.bottom
        

        Repeater {
            model: root.blocks
            Rectangle {
                width: 10
                height: 15
                color: root.barColor
            }
        }
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.lineWidth = 2;
            ctx.strokeStyle = "lightblue";
            var w = barRow.width;
            var x0 = barRow.x;
            var y0 = barRow.y - root.barOffset;
            ctx.beginPath();
            ctx.moveTo(x0, y0);
            ctx.lineTo(x0 + 20, y0 - root.gap);
            ctx.lineTo(x0 + w - 20, y0 - root.gap);
            ctx.lineTo(x0 + w, y0);
            ctx.moveTo(x0 + w / 2, y0 - root.gap);
            ctx.lineTo(x0 + w / 2, y0 - 10);
            ctx.stroke();
        }
    }

    Text {
        id: lowText
        text: "E"
        color: "red"
        font.pixelSize: 16
        x: barRow.x - width / 2
        y: barRow.y - root.gap - root.barOffset - height / 2
    }

    Text {
        id: highText
        text: "F"
        color: "white"
        font.pixelSize: 16
        x: barRow.x + barRow.width - width / 2
        y: barRow.y - root.gap - root.barOffset - height / 2
    }

    Text {
        id: labelText
        text: "LABEL"
        color: "white"
        font.pixelSize: 16
        y: barRow.y - root.gap - root.barOffset - height
        x: barRow.x + barRow.width / 2 - width / 2
    }
}
