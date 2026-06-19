pragma ComponentBehavior: Bound

import QtQuick
import "Singletons"

/**
 * 設 SETTINGS surface: Flags-persisted preferences grouped into sections of
 * rows, each a name with an optional faint caption and a right-aligned control.
 * Appearance covers the clock format and seconds, the Japanese-glyph toggle that
 * gates every surface header, and the accent-palette mode; Recording carries the
 * capture countdown. Toggles reuse LinkToggle; choice rows use an inline
 * mini-segmented control that flame-tints the selected pill. Exposes
 * `implicitHeight` from its content and docks Ame at the header gear.
 */
PillSurface {
    id: root

    mTop: 15
    mLeft: 19
    mRight: 19
    mBottom: 14

    implicitHeight: content.implicitHeight

    readonly property point gearPoint: {
        void root.width;
        void root.height;
        return gear.mapToItem(root, gear.width / 2, gear.height / 2);
    }

    ameForm: open ? "dock" : "off"
    amePoint: gearPoint

    /**
     * Mini-segmented choice control. `options` is a list of `{ label, value }`;
     * the pill whose value equals `value` lights with a flame tint. Picking a
     * pill emits `picked(value)`; selection keys off the source value, never a
     * child's effective visibility.
     */
    component MiniSeg: Rectangle {
        id: seg
        property var options: []
        property var value
        signal picked(var value)

        readonly property real pad: 2 * root.s

        width: pills.implicitWidth + 2 * pad
        height: pills.implicitHeight + 2 * pad
        radius: 9 * root.s
        color: Theme.tileBg
        border.width: 1
        border.color: Theme.border

        Row {
            id: pills
            anchors.centerIn: parent
            spacing: 2 * root.s

            Repeater {
                model: seg.options

                Rectangle {
                    id: opt
                    required property var modelData
                    readonly property bool current: seg.value === modelData.value

                    width: optLabel.implicitWidth + 18 * root.s
                    height: optLabel.implicitHeight + 12 * root.s
                    radius: 7 * root.s
                    color: opt.current ? Qt.alpha(Theme.vermDeep, 0.18) : "transparent"
                    border.width: opt.current ? 1 : 0
                    border.color: Qt.alpha(Theme.vermLit, 0.4)
                    Behavior on color { ColorAnimation { duration: Motion.fast } }

                    Text {
                        id: optLabel
                        anchors.centerIn: parent
                        text: opt.modelData.label
                        color: opt.current ? Theme.cream : Theme.subtle
                        font.family: Theme.font
                        font.pixelSize: 10.5 * root.s
                        font.weight: Font.Bold
                        font.letterSpacing: 0.3 * root.s
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: seg.picked(opt.modelData.value)
                    }
                }
            }
        }
    }

    /**
     * One settings line: a name plus an optional faint sub caption on the left
     * and a control slot on the right, capped to a single bottom hairline. The
     * `control` default-property slot holds the toggle or segmented control.
     */
    component SRow: Item {
        id: srow
        property string name: ""
        property string sub: ""
        property bool last: false
        default property alias control: controlSlot.data

        width: parent ? parent.width : 0
        height: Math.max(textCol.implicitHeight, controlSlot.childrenRect.height) + 26 * root.s

        Column {
            id: textCol
            anchors.left: parent.left
            anchors.right: controlSlot.left
            anchors.rightMargin: 14 * root.s
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5 * root.s

            Text {
                text: srow.name
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 12.5 * root.s
                font.weight: Font.DemiBold
            }
            Text {
                width: parent.width
                visible: srow.sub.length > 0
                text: srow.sub
                color: Theme.faint
                font.family: Theme.font
                font.pixelSize: 10.5 * root.s
                wrapMode: Text.WordWrap
                lineHeight: 1.2
            }
        }

        Item {
            id: controlSlot
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: childrenRect.width
            height: childrenRect.height
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Theme.hairSoft
            visible: !srow.last
        }
    }

    Column {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Item {
            width: parent.width
            height: 22 * root.s

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8 * root.s

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Flags.showGlyphs
                    text: "設"
                    color: Theme.cream
                    font.family: Theme.fontJp
                    font.weight: Font.Medium
                    font.pixelSize: 16 * root.s
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "SETTINGS"
                    color: Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.6 * root.s
                }
            }

            GlyphIcon {
                id: gear
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 16 * root.s
                height: 16 * root.s
                name: "cog"
                color: Theme.iconDim
                stroke: 1.7
            }
        }

        Text {
            topPadding: 17 * root.s
            bottomPadding: 2 * root.s
            text: "Appearance"
            color: Theme.faint
            font.family: Theme.font
            font.pixelSize: 8.5 * root.s
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2 * root.s
        }

        SRow {
            name: "Time format"
            sub: "24-hour stays the default"

            MiniSeg {
                options: [{ label: "24H", value: false }, { label: "12H", value: true }]
                value: Flags.time12h
                onPicked: (v) => Flags.time12h = v
            }
        }

        SRow {
            name: "Clock seconds"
            sub: "Show :SS in the pill clock"

            LinkToggle {
                s: root.s
                on: Flags.clockSeconds
                onToggled: Flags.clockSeconds = !Flags.clockSeconds
            }
        }

        SRow {
            name: "Japanese glyphs"
            sub: "Kanji on surface headers (蓄 BATTERY…). Off swaps for plain labels."

            LinkToggle {
                s: root.s
                on: Flags.showGlyphs
                onToggled: Flags.showGlyphs = !Flags.showGlyphs
            }
        }

        SRow {
            name: "Accent palette"
            sub: "Static = fixed flame · Dynamic = recolor per wallpaper (matugen)"

            MiniSeg {
                options: [{ label: "Static", value: false }, { label: "Dynamic", value: true }]
                value: Flags.dynamicPalette
                onPicked: (v) => Flags.dynamicPalette = v
            }
        }

        Text {
            topPadding: 17 * root.s
            bottomPadding: 2 * root.s
            text: "Recording"
            color: Theme.faint
            font.family: Theme.font
            font.pixelSize: 8.5 * root.s
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2 * root.s
        }

        SRow {
            name: "Countdown"
            sub: "Delay before capture starts"
            last: true

            MiniSeg {
                options: [
                    { label: "Off", value: 0 },
                    { label: "3s", value: 3 },
                    { label: "5s", value: 5 },
                    { label: "10s", value: 10 }
                ]
                value: Flags.recordCountdown
                onPicked: (v) => Flags.recordCountdown = v
            }
        }
    }
}
