import QtQuick 2.15
import QtQuick.Controls 2.15
import "components"

ApplicationWindow {
    width: 800
    height: 480
    visible: true
    title: "Dashboard Demo"

    Rectangle {
        anchors.fill: parent
        color: "black"

        //==========================
        // Speedometer (left)
        //==========================
        Speedometer {
            id: speedo
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            // dial config
            minSpeed: 0
            maxSpeed: 180
            step: 20

            // smooth needle rotation
            animationDurationMs: 250

            // bind to C++ 
            value: dashboardData ? dashboardData.speed : 0
        }

        //==========================
        // Tachometer (right, reuse Speedometer)
        //==========================
        Speedometer {
            id: tacho
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            
            minSpeed: 0
            maxSpeed: 9
            step: 1

            animationDurationMs: 250

            // bind to C++ ß
            value: dashboardData ? dashboardData.rpm : 0
        }

        //==========================
        // Indicator Bar (bottom)
        //==========================
        Rectangle {
            id: indicatorBar
            anchors.bottom: parent.bottom
            width: parent.width
            height: 75
            color: "black"

            Row {
                id: indicatorRow
                anchors.fill: parent
                anchors.margins: 10
                anchors.leftMargin: 20
                spacing: 50

                BarIndicator {
                    label: "FUEL"
                    lowLabel: "E"
                    highLabel: "F"
                    blocks: 10
                    // If BarIndicator supports 'value', bind it:
                    // value: dashboardData ? dashboardData.fuelLevel : 0
                }

                BarIndicator {
                    label: "WATER"
                    lowLabel: "0"
                    highLabel: "100"
                    blocks: 10
                }

                BarIndicator {
                    label: "OIL"
                    lowLabel: "0"
                    highLabel: "100"
                    blocks: 10
                }

                BarIndicator {
                    label: "BATTERY"
                    lowLabel: "0"
                    highLabel: "100"
                    blocks: 10
                }
            }
        }
    }
}
