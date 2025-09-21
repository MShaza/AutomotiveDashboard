import QtQuick 2.15

Item {
    id: root

    // ---- Value → angle config ----
    property real value: 0              // accepts int or float (bind from C++)
    property real minSpeed: 0
    property real maxSpeed: 180
    property int  step: 20
    property real startAngle: -120      // 0 at bottom-left
    property real sweepAngle: 240       // arc to top-right

    // ---- Layout controls ----
    property real dialPadding: 6
    property real rimRadius: Math.min(width, height)/2 - dialPadding

    // ticks (outer ends touch the rim)
    property real tickThickness: 3
    property real tickLenMajor: 20

    // labels: UNDER the tick (toward center)
    property real labelFromTick: 12
    property bool  labelsUpright: true

    // smooth rotation (ms)
    property int animationDurationMs: 250

    // ---- Needle styling
    property color needleColor: "red"
    property real  needleBaseWidth: 8        // width near center
    property real  needleBaseRadius: 12      // base distance from center
    property real  needleClearFromLabel: 6   // clearance before label ring

    // keep the tip inside the numbers
    property real  labelRingRadius: rimRadius - tickLenMajor - labelFromTick
    property real  needleTipRadius: Math.max(needleBaseRadius + 4,
                                            labelRingRadius - needleClearFromLabel)

    // debug
    property bool showDebug: false

    width: 300
    height: 300

    // ---- Helpers (needle-space: 0° = down) ----
    function valueToAngleDeg(v) {
        const vv = Math.max(minSpeed, Math.min(maxSpeed, v));
        return startAngle + ((vv - minSpeed) / (maxSpeed - minSpeed)) * sweepAngle;
    }
    function toRad(needleDeg) { return (needleDeg - 90) * Math.PI / 180; }
    function labelRotationFor(angleDeg) {
        if (labelsUpright) return 0;
        let a = angleDeg - 90;
        const norm = (angleDeg % 360 + 360) % 360;
        if (norm > 90 && norm < 270) a += 180;
        return a;
    }

    // ---- Dial background ----
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "#222"
        border.color: "white"
        border.width: 1
    }

    // ---- Ticks + Labels ----
    Repeater {
        model: Math.floor((root.maxSpeed - root.minSpeed) / root.step) + 1

        Item {
            readonly property real tickValue: root.minSpeed + index * root.step
            readonly property real angleDeg:  valueToAngleDeg(tickValue)
            readonly property real angleRad:  toRad(angleDeg)

            width: 1; height: 1

            // Tick: center radius so OUTER end touches rim
            readonly property real rTickCenter: root.rimRadius - root.tickLenMajor/2

            Rectangle {
                width: root.tickThickness
                height: root.tickLenMajor
                color: "white"
                x: root.width/2  + rTickCenter * Math.cos(angleRad) - width/2
                y: root.height/2 + rTickCenter * Math.sin(angleRad) - height/2
                transformOrigin: Item.Center
                rotation: angleDeg
                antialiasing: true
            }

            // Label UNDER the tick (toward center)
            Text {
                text: tickValue
                color: "white"
                font.pixelSize: 14
                antialiasing: true

                readonly property real rLabel: root.rimRadius - root.tickLenMajor - root.labelFromTick
                x: root.width/2  + rLabel * Math.cos(angleRad) - width/2
                y: root.height/2 + rLabel * Math.sin(angleRad) - height/2
                transformOrigin: Item.Center
                rotation: labelRotationFor(angleDeg)
            }
        }
    }

    // ===== Center-pivot + smooth rotation =====
    Item {
        id: needlePivot
        anchors.centerIn: parent
        width: 1; height: 1
        transformOrigin: Item.Center
        rotation: valueToAngleDeg(root.value)

        // Smooth the rotation on value changes
        Behavior on rotation {
            NumberAnimation {
                duration: root.animationDurationMs
                easing.type: Easing.InOutQuad
            }
        }

        // Pointed needle via Canvas (no extra modules)
        Canvas {
            id: needleCanvas
            anchors.centerIn: parent
            width: root.rimRadius * 2
            height: root.rimRadius * 2

            onPaint: {
                const ctx = getContext("2d");
                ctx.resetTransform();
                ctx.clearRect(0, 0, width, height);

                // draw in local coords with pivot at center
                ctx.translate(width/2, height/2);

                const tipY  = -root.needleTipRadius;
                const baseY = -root.needleBaseRadius;
                const halfW = root.needleBaseWidth/2;

                ctx.beginPath();
                ctx.moveTo(0, tipY);
                ctx.lineTo(-halfW, baseY);
                ctx.lineTo( halfW, baseY);
                ctx.closePath();

                ctx.fillStyle = root.needleColor;
                ctx.fill();
            }

            // repaint on geometry changes
            Connections {
                target: root
                function onNeedleTipRadiusChanged(){ needleCanvas.requestPaint(); }
                function onNeedleBaseRadiusChanged(){ needleCanvas.requestPaint(); }
                function onNeedleBaseWidthChanged(){ needleCanvas.requestPaint(); }
                function onRimRadiusChanged(){ needleCanvas.requestPaint(); }
                function onLabelFromTickChanged(){ needleCanvas.requestPaint(); }
                function onTickLenMajorChanged(){ needleCanvas.requestPaint(); }
            }
            Component.onCompleted: needleCanvas.requestPaint()
        }
    }

    // Hub
    Rectangle {
        width: 16; height: 16; radius: 8
        color: "#ddd"
        anchors.centerIn: parent
    }

    // Units
    Text {
        text: "km/h"
        color: "white"
        font.pixelSize: 18
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
    }

    // Debug: exact 0 position on rim
    Rectangle {
        visible: root.showDebug
        width: 6; height: 6; radius: 3
        color: "yellow"
        readonly property real a0: toRad(root.startAngle)
        x: root.width/2  + root.rimRadius * Math.cos(a0) - width/2
        y: root.height/2 + root.rimRadius * Math.sin(a0) - height/2
    }
}
