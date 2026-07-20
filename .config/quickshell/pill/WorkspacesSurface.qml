pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import "lib/keychord.js" as Chord
import "Singletons"

/**
 * 場 WORKSPACES hub: a glance at Hyprland's special spaces and the keys that
 * summon them. The three built-in rows (Stash, Private, Minimized) sit on top;
 * below them every user-defined space from the Spaces store gets its own row with
 * a Super+<key> chip, a chevron into its app manager (SpaceApps) and a remove
 * control on hover. A dashed "Add Workspace" bar at the bottom swaps the surface
 * into a create form — name, description and a captured single-letter key — that
 * makes a new space on confirm.
 *
 * Built on the plain surface base like Stash and Keybinds; the host routes its
 * header-back to the settings index (or, while the form is open, back to the
 * list) and each navigable row's tap to the matching surface.
 */
PillSurface {
    id: root

    mTop: 15
    mLeft: 19
    mRight: 19
    mBottom: 14

    implicitHeight: content.implicitHeight

    signal requestSurface(string name)

    ameForm: "off"

    property bool formOpen: false
    property bool listening: false
    property string conflict: ""
    property string formName: ""
    property string formDesc: ""
    property string formKey: ""

    readonly property var spaces: [
        { name: "Stash", key: "Super + S", note: "Background apps that open here", surface: "stash" },
        { name: "Private", key: "Super + P", note: "Hidden scratchpad", surface: "" },
        { name: "Minimized", key: "Super + Shift + M", note: "Minimized windows", surface: "" }
    ]

    function openForm() {
        root.formName = "";
        root.formDesc = "";
        root.formKey = "";
        root.conflict = "";
        root.listening = false;
        root.formOpen = true;
    }

    function closeForm() {
        root.formOpen = false;
        root.listening = false;
        root.conflict = "";
    }

    /**
     * Fold a captured keypress into a single uppercase letter for the new space's
     * key. Modifiers are dropped (Super is auto-prefixed), a bare modifier keeps
     * capture waiting, Escape ends it, and anything that is not one A–Z letter is
     * refused inline.
     */
    function capture(key, modifiers) {
        if (key === Qt.Key_Escape) {
            root.listening = false;
            return;
        }
        var name = Chord.chord(key, 0);
        if (name === null)
            return;
        if (!/^[A-Z]$/.test(name)) {
            root.conflict = "single letter only";
            root.listening = false;
            return;
        }
        root.formKey = name;
        root.conflict = "";
        root.listening = false;
    }

    /**
     * Validate and create the space. Name must slug to a non-empty, unused id; the
     * key must be one letter and free of every existing bind. A clash is reported
     * inline so nothing is written until it is resolved.
     */
    function create() {
        var name = root.formName.trim();
        if (name.length === 0) { root.conflict = "name empty"; return; }
        var id = Spaces.slug(name);
        if (id.length === 0) { root.conflict = "name needs a letter"; return; }
        if (Spaces.reserved(id)) { root.conflict = name + " is reserved"; return; }
        for (var i = 0; i < Spaces.list.length; i++)
            if (Spaces.list[i].id === id) { root.conflict = name + " already exists"; return; }
        if (!/^[A-Za-z]$/.test(root.formKey)) { root.conflict = "pick a key"; return; }
        if (Spaces.keyTaken(root.formKey)) { root.conflict = "Super + " + root.formKey.toUpperCase() + " in use"; return; }
        Spaces.addSpace(name, root.formDesc.trim(), root.formKey.toUpperCase());
        root.closeForm();
    }

    onActiveChanged: {
        formOpen = false;
        listening = false;
        conflict = "";
    }

    onFormOpenChanged: if (formOpen) Qt.callLater(nameField.forceActiveFocus)

    Item {
        id: keyCatcher
        focus: root.listening
        Keys.onPressed: (e) => {
            if (!root.listening)
                return;
            e.accepted = true;
            root.capture(e.key, e.modifiers);
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
                    text: "場"
                    color: Theme.cream
                    font.family: Theme.fontJp
                    font.weight: Font.Medium
                    font.pixelSize: 16 * root.s
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "WORKSPACES"
                    color: Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.6 * root.s
                }
            }

            GlyphIcon {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 16 * root.s
                height: 16 * root.s
                name: "chevron-left"
                color: Theme.iconDim
                stroke: 2.2
            }
        }

        Item { width: 1; height: 8 * root.s }

        /** ── list view ── */

        Column {
            id: listCol
            width: parent.width
            visible: !root.formOpen
            spacing: 0

            Repeater {
                model: root.spaces

                delegate: Item {
                    id: wrow
                    required property int index
                    required property var modelData

                    readonly property bool nav: modelData.surface.length > 0

                    width: parent.width
                    height: 50 * root.s

                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: 3 * root.s
                        anchors.bottomMargin: 3 * root.s
                        radius: 10 * root.s
                        color: (wrow.nav && navHover.hovered) ? Theme.frameBg : "transparent"
                        border.width: 1
                        border.color: (wrow.nav && navHover.hovered) ? Theme.frameBorder : "transparent"
                        Behavior on color { ColorAnimation { duration: Motion.fast } }
                    }

                    HoverHandler { id: navHover; enabled: wrow.nav }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 12 * root.s
                        anchors.right: rightRow.left
                        anchors.rightMargin: 10 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3 * root.s

                        Text {
                            width: parent.width
                            text: wrow.modelData.name
                            color: Theme.cream
                            font.family: Theme.font
                            font.pixelSize: 12.5 * root.s
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }
                        Text {
                            width: parent.width
                            text: wrow.modelData.note
                            color: Theme.faint
                            font.family: Theme.font
                            font.pixelSize: 10.5 * root.s
                            elide: Text.ElideRight
                        }
                    }

                    Row {
                        id: rightRow
                        anchors.right: parent.right
                        anchors.rightMargin: 12 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8 * root.s

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: keyText.implicitWidth + 16 * root.s
                            height: keyText.implicitHeight + 8 * root.s
                            radius: 7 * root.s
                            color: Theme.frameBg
                            border.width: 1
                            border.color: Theme.hairSoft

                            Text {
                                id: keyText
                                anchors.centerIn: parent
                                text: wrow.modelData.key
                                color: Theme.subtle
                                font.family: Theme.font
                                font.pixelSize: 11 * root.s
                                font.weight: Font.Bold
                                font.letterSpacing: 0.3 * root.s
                            }
                        }

                        GlyphIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: wrow.nav
                            width: 16 * root.s
                            height: 16 * root.s
                            name: "chevron-right"
                            color: navHover.hovered ? Theme.cream : Theme.iconDim
                            stroke: 2.2
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: wrow.nav
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.requestSurface(wrow.modelData.surface)
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1
                        color: Theme.hairSoft
                    }
                }
            }

            Repeater {
                model: Spaces.list

                delegate: Item {
                    id: crow
                    required property int index
                    required property var modelData

                    readonly property bool last: crow.index === Spaces.list.length - 1

                    width: parent.width
                    height: 50 * root.s

                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: 3 * root.s
                        anchors.bottomMargin: 3 * root.s
                        radius: 10 * root.s
                        color: cHover.hovered ? Theme.frameBg : "transparent"
                        border.width: 1
                        border.color: cHover.hovered ? Theme.frameBorder : "transparent"
                        Behavior on color { ColorAnimation { duration: Motion.fast } }
                    }

                    HoverHandler { id: cHover }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Spaces.editing = crow.modelData.id;
                            root.requestSurface("spaceapps");
                        }
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 12 * root.s
                        anchors.right: cRightRow.left
                        anchors.rightMargin: 10 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3 * root.s

                        Text {
                            width: parent.width
                            text: crow.modelData.name
                            color: Theme.cream
                            font.family: Theme.font
                            font.pixelSize: 12.5 * root.s
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }
                        Text {
                            width: parent.width
                            visible: crow.modelData.desc.length > 0
                            text: crow.modelData.desc
                            color: Theme.faint
                            font.family: Theme.font
                            font.pixelSize: 10.5 * root.s
                            elide: Text.ElideRight
                        }
                    }

                    Row {
                        id: cRightRow
                        anchors.right: parent.right
                        anchors.rightMargin: 12 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8 * root.s

                        Rectangle {
                            id: cRemove
                            anchors.verticalCenter: parent.verticalCenter
                            width: 24 * root.s
                            height: 24 * root.s
                            radius: 7 * root.s
                            opacity: cHover.hovered ? 1 : 0
                            color: cRemoveArea.containsMouse ? Qt.alpha(Theme.verm, 0.16) : "transparent"
                            Behavior on opacity { NumberAnimation { duration: Motion.fast } }
                            Behavior on color { ColorAnimation { duration: Motion.fast } }

                            GlyphIcon {
                                anchors.centerIn: parent
                                width: 12 * root.s
                                height: 12 * root.s
                                name: "close"
                                color: cRemoveArea.containsMouse ? Theme.vermLit : Theme.iconDim
                                stroke: 2
                            }

                            MouseArea {
                                id: cRemoveArea
                                anchors.fill: parent
                                enabled: cHover.hovered
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Spaces.removeSpace(crow.modelData.id)
                            }
                        }

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: cKeyText.implicitWidth + 16 * root.s
                            height: cKeyText.implicitHeight + 8 * root.s
                            radius: 7 * root.s
                            color: Theme.frameBg
                            border.width: 1
                            border.color: Theme.hairSoft

                            Text {
                                id: cKeyText
                                anchors.centerIn: parent
                                text: "Super + " + crow.modelData.key
                                color: Theme.subtle
                                font.family: Theme.font
                                font.pixelSize: 11 * root.s
                                font.weight: Font.Bold
                                font.letterSpacing: 0.3 * root.s
                            }
                        }

                        GlyphIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 16 * root.s
                            height: 16 * root.s
                            name: "chevron-right"
                            color: cHover.hovered ? Theme.cream : Theme.iconDim
                            stroke: 2.2
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1
                        color: Theme.hairSoft
                        visible: !crow.last
                    }
                }
            }

            Item { width: 1; height: 6 * root.s }

            Item {
                width: parent.width
                height: 40 * root.s

                Canvas {
                    id: dash
                    anchors.fill: parent
                    anchors.topMargin: 4 * root.s
                    anchors.bottomMargin: 4 * root.s
                    property color stroke: Qt.alpha(Theme.vermLit, addArea.containsMouse ? 0.7 : 0.36)
                    onStrokeChanged: requestPaint()
                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        var r = 9 * root.s;
                        var w = width;
                        var h = height;
                        var p = 0.5;
                        ctx.lineWidth = 1;
                        ctx.strokeStyle = stroke;
                        ctx.setLineDash([4 * root.s, 4 * root.s]);
                        ctx.beginPath();
                        ctx.moveTo(p + r, p);
                        ctx.lineTo(w - p - r, p);
                        ctx.arcTo(w - p, p, w - p, p + r, r);
                        ctx.lineTo(w - p, h - p - r);
                        ctx.arcTo(w - p, h - p, w - p - r, h - p, r);
                        ctx.lineTo(p + r, h - p);
                        ctx.arcTo(p, h - p, p, h - p - r, r);
                        ctx.lineTo(p, p + r);
                        ctx.arcTo(p, p, p + r, p, r);
                        ctx.stroke();
                    }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 6 * root.s

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "+"
                        color: Theme.vermLit
                        font.family: Theme.font
                        font.pixelSize: 14 * root.s
                        font.weight: Font.Bold
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Add Workspace"
                        color: Theme.vermLit
                        font.family: Theme.font
                        font.pixelSize: 11 * root.s
                        font.weight: Font.DemiBold
                        font.letterSpacing: 0.5 * root.s
                    }
                }

                MouseArea {
                    id: addArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.openForm()
                }
            }
        }

        /** ── create form ── */

        Column {
            id: form
            width: parent.width
            visible: root.formOpen
            spacing: 10 * root.s

            Item {
                width: parent.width
                height: 22 * root.s

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 7 * root.s

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 16 * root.s
                        height: 16 * root.s

                        GlyphIcon {
                            anchors.fill: parent
                            name: "chevron-left"
                            color: formBackArea.containsMouse ? Theme.cream : Theme.iconDim
                            stroke: 1.8
                        }

                        MouseArea {
                            id: formBackArea
                            anchors.fill: parent
                            anchors.margins: -6 * root.s
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.closeForm()
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "NEW WORKSPACE"
                        color: Theme.subtle
                        font.family: Theme.font
                        font.pixelSize: 9.5 * root.s
                        font.weight: Font.DemiBold
                        font.capitalization: Font.AllUppercase
                        font.letterSpacing: 1.4 * root.s
                    }
                }
            }

            Item {
                width: parent.width
                height: 40 * root.s

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    text: "NAME"
                    color: Theme.faint
                    font.family: Theme.font
                    font.pixelSize: 8.5 * root.s
                    font.weight: Font.Medium
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1 * root.s
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 26 * root.s
                    radius: 8 * root.s
                    color: Theme.frameBg
                    border.width: 1
                    border.color: nameField.activeFocus ? Qt.alpha(Theme.vermLit, 0.45) : Theme.hairSoft

                    TextField {
                        id: nameField
                        anchors.left: parent.left
                        anchors.leftMargin: 11 * root.s
                        anchors.right: parent.right
                        anchors.rightMargin: 11 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        background: null
                        padding: 0
                        color: Theme.cream
                        font.family: Theme.font
                        font.pixelSize: 11.5 * root.s
                        placeholderText: "Discord"
                        placeholderTextColor: Theme.faint
                        selectByMouse: true
                        selectionColor: Theme.verm
                        text: root.formName
                        onTextEdited: root.formName = text
                        Keys.onPressed: (e) => {
                            if (e.key === Qt.Key_Escape) { root.closeForm(); e.accepted = true; }
                            else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) { root.create(); e.accepted = true; }
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: 40 * root.s

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    text: "DESCRIPTION"
                    color: Theme.faint
                    font.family: Theme.font
                    font.pixelSize: 8.5 * root.s
                    font.weight: Font.Medium
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1 * root.s
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 26 * root.s
                    radius: 8 * root.s
                    color: Theme.frameBg
                    border.width: 1
                    border.color: descField.activeFocus ? Qt.alpha(Theme.vermLit, 0.45) : Theme.hairSoft

                    TextField {
                        id: descField
                        anchors.left: parent.left
                        anchors.leftMargin: 11 * root.s
                        anchors.right: parent.right
                        anchors.rightMargin: 11 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        background: null
                        padding: 0
                        color: Theme.cream
                        font.family: Theme.font
                        font.pixelSize: 11.5 * root.s
                        placeholderText: "Chat (optional)"
                        placeholderTextColor: Theme.faint
                        selectByMouse: true
                        selectionColor: Theme.verm
                        text: root.formDesc
                        onTextEdited: root.formDesc = text
                        Keys.onPressed: (e) => {
                            if (e.key === Qt.Key_Escape) { root.closeForm(); e.accepted = true; }
                            else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) { root.create(); e.accepted = true; }
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: 40 * root.s

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    text: "KEYBIND"
                    color: Theme.faint
                    font.family: Theme.font
                    font.pixelSize: 8.5 * root.s
                    font.weight: Font.Medium
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1 * root.s
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 26 * root.s
                    radius: 8 * root.s
                    color: root.listening ? Qt.alpha(Theme.vermLit, 0.12) : Theme.frameBg
                    border.width: 1
                    border.color: root.listening ? Qt.alpha(Theme.vermLit, 0.55) : Theme.hairSoft
                    Behavior on color { ColorAnimation { duration: Motion.fast } }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 11 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.listening ? "press a letter…  esc cancels"
                            : (root.formKey.length ? "Super + " + root.formKey : "tap to set a key")
                        color: root.listening ? Theme.flameGlow
                            : (root.formKey.length ? Theme.cream : Theme.faint)
                        font.family: Theme.font
                        font.pixelSize: 11.5 * root.s
                        font.weight: root.formKey.length ? Font.DemiBold : Font.Medium
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.conflict = "";
                            root.listening = true;
                        }
                    }
                }
            }

            Text {
                width: parent.width
                visible: root.conflict.length > 0
                text: root.conflict
                color: Theme.vermLit
                font.family: Theme.font
                font.pixelSize: 10 * root.s
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Item {
                width: parent.width
                height: 30 * root.s

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: cancelLabel.implicitWidth + 24 * root.s
                    height: 28 * root.s
                    radius: 8 * root.s
                    color: cancelArea.containsMouse ? Theme.frameBg : "transparent"
                    border.width: 1
                    border.color: Theme.hairSoft

                    Text {
                        id: cancelLabel
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: Theme.subtle
                        font.family: Theme.font
                        font.pixelSize: 10.5 * root.s
                        font.weight: Font.DemiBold
                        font.letterSpacing: 0.3 * root.s
                    }

                    MouseArea {
                        id: cancelArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.closeForm()
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: createLabel.implicitWidth + 30 * root.s
                    height: 28 * root.s
                    radius: 8 * root.s
                    color: createArea.containsMouse ? Theme.vermLit : Theme.verm

                    Text {
                        id: createLabel
                        anchors.centerIn: parent
                        text: "Create"
                        color: Theme.cream
                        font.family: Theme.font
                        font.pixelSize: 10.5 * root.s
                        font.weight: Font.Bold
                        font.letterSpacing: 0.4 * root.s
                    }

                    MouseArea {
                        id: createArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.create()
                    }
                }
            }
        }

        Item { width: 1; height: 4 * root.s }
    }
}
