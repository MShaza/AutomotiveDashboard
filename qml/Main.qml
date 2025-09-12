import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    property int maxSpeed: 180
    property int step: 10
    property int maxRPM: 8
    property real startAngle: 120
    property real sweepAngle: 300

    width: 800
    height: 480
    visible: true
    title: "Dashboard Demo"

    Rectangle {
        anchors.fill: parent
        color: "black"

        //**********************/
        // Speedo Meter
        //*********************/
        Rectangle {
            id: speedoMeter

            width: parent.width * 0.4
            height: width
            radius: width / 2
            color: "#222"
            anchors.left: parent.left
            border.color: "white"
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            //***Needle
            Rectangle {
                width: 5
                height: parent.height * 0.45
                color: "red"
                anchors.centerIn: parent
            }

            Text {
                text: "km/h"
                color: "white"
                font.pixelSize: 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Repeater {
                model: maxSpeed / step + 1

                Item {
                    property real angleDeg: startAngle + (index * step * sweepAngle / maxSpeed)
                    property real angleRad: angleDeg * Math.PI / 180
                    property real r: speedoMeter.width / 2 - 20

                    // Tick
                    Rectangle {
                        width: 3
                        height: (index % 2 === 0) ? 20 : 12
                        color: "white"
                        radius: 1
                        x: speedoMeter.width / 2 + r * Math.cos(angleRad) - width / 2
                        y: speedoMeter.height / 2 + r * Math.sin(angleRad) - height / 2
                        transformOrigin: Item.Center
                        rotation: angleDeg + 90
                    }

                    // Text label
                    Text {
                        visible: index % 2 === 0
                        text: index * step
                        color: "white"
                        font.pixelSize: 14
                        x: speedoMeter.width / 2 + (r - 25) * Math.cos(angleRad) - width / 2
                        y: speedoMeter.height / 2 + (r - 25) * Math.sin(angleRad) - height / 2
                    }

                }

            }

        }

        //**********************/
        // Tcho Meter
        //*********************/
        Rectangle {
            id: tachoMeter

            width: parent.width * 0.4
            height: width
            radius: width / 2
            color: "#222"
            anchors.right: parent.right
            border.color: "white"
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            //****needle****
            Rectangle {
                width: 5
                height: parent.height * 0.45
                color: "Orange"
                anchors.centerIn: parent
            }

            Text {
                text: "x 1000r/min"
                color: "white"
                font.pixelSize: 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Repeater {
                model: 9 // 0..8

                Item {
                    property real angleDeg: startAngle + (index * sweepAngle / maxRPM)
                    property real angleRad: angleDeg * Math.PI / 180
                    property real r: tachoMeter.width / 2 - 20

                    Rectangle {
                        width: 2
                        height: 20
                        color: index >= 6 ? "red" : "white"
                        radius: 1
                        x: tachoMeter.width / 2 + r * Math.cos(angleRad) - width / 2
                        y: tachoMeter.height / 2 + r * Math.sin(angleRad) - height / 2
                        rotation: angleDeg + 90
                    }

                    Text {
                        //visible: index % 2 === 0
                        text: index
                        color: "white"
                        font.pixelSize: 14
                        x: speedoMeter.width / 2 + (r - 25) * Math.cos(angleRad) - width / 2
                        y: speedoMeter.height / 2 + (r - 25) * Math.sin(angleRad) - height / 2
                    }

                }

            }

            Canvas {
                id: rpmRedArc

                width: tachoMeter.width
                height: tachoMeter.height
                anchors.centerIn: tachoMeter
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.lineWidth = 6;
                    ctx.strokeStyle = "red";
                    var cx = width / 2;
                    var cy = height / 2;
                    var r = width / 2 - 20;
                    var startRPM = 6;
                    var endRPM = 8;
                    var startAngleDeg = startAngle + (startRPM / maxRPM) * sweepAngle;
                    var endAngleDeg = startAngle + (endRPM / maxRPM) * sweepAngle;
                    var startAngleRad = startAngleDeg * Math.PI / 180;
                    var endAngleRad = endAngleDeg * Math.PI / 180;
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, startAngleRad, endAngleRad, false);
                    ctx.stroke();
                }
            }

        }

        Rectangle {
            id: indicatorBar

            anchors.bottom: parent.bottom
            border.color: "white"
            color: "#222"
            width: parent.width
            height: 75

            Row {
                id: fuelRow

                spacing: 5
                anchors.centerIn: parent
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10

                // "E" label on the left
                Text {
                    verticalAlignment: Text.AlignVCenter
                    text: "E"
                    color: "red"
                    font.pixelSize: 16
                }

                // Fuel bars
                Repeater {
                    model: 10

                    Rectangle {
                        width: 10
                        height: 15
                        color: "#0BA6DF"
                    }

                }

                // "F" label on the right
                Text {
                    verticalAlignment: Text.AlignVCenter
                    text: "F"
                    color: "white"
                    font.pixelSize: 16
                }

            }

        }

    }

}
