/**
 * Parses one availableModes entry like "2560x1440@279.96Hz" into its parts. The
 * Hz is rounded to a whole number for UI grouping and the apply mode string,
 * while `raw` keeps the original entry for reference. Returns null when the
 * entry does not match the WxH@HZHz shape.
 */
function parseMode(raw) {
    var m = raw.match(/^(\d+)x(\d+)@([\d.]+)Hz$/);
    if (!m)
        return null;
    return {
        w: parseInt(m[1], 10),
        h: parseInt(m[2], 10),
        hz: Math.round(parseFloat(m[3])),
        raw: raw
    };
}

/**
 * Parses the `hyprctl monitors -j` text into the slim shape the Display surface
 * needs: per monitor its name, current width/height/refresh/scale/x/y and the
 * available modes as `{ w, h, hz, raw }`. Refresh is rounded the same way as a
 * mode's Hz so the current mode can be matched against the list. Modes that do
 * not parse are dropped. Returns [] on bad input.
 */
function parse(jsonText) {
    var data;
    try {
        data = JSON.parse(jsonText);
    } catch (e) {
        return [];
    }
    if (!Array.isArray(data))
        return [];

    return data.map(function (mon) {
        var modes = (mon.availableModes || [])
            .map(parseMode)
            .filter(function (m) { return m !== null; });
        return {
            name: mon.name,
            width: mon.width,
            height: mon.height,
            refresh: Math.round(mon.refreshRate),
            scale: mon.scale,
            x: mon.x,
            y: mon.y,
            modes: modes
        };
    });
}

/**
 * Rewrites only the `hl.monitor({...})` block whose `output = "<output>"`,
 * replacing the `mode`, `position` and `scale` field values and leaving every
 * other character of the file byte-identical (other monitors, workspace_rule
 * loops, whitespace, field order). The block is located by its `output` field,
 * then the closest enclosing `hl.monitor({` ... `})` bounds are taken and each
 * of the three fields is substituted in place within those bounds. Returns
 * `{ text, ok, error }`; ok is false (text unchanged) when the output's block or
 * any of the three fields cannot be found.
 */
function setMonitor(luaText, output, mode, position, scale) {
    var outRe = new RegExp('output\\s*=\\s*"' + escapeRe(output) + '"');
    var outMatch = outRe.exec(luaText);
    if (!outMatch)
        return { text: luaText, ok: false, error: "output not found: " + output };

    var blockStart = luaText.lastIndexOf("hl.monitor({", outMatch.index);
    if (blockStart === -1)
        return { text: luaText, ok: false, error: "no hl.monitor block for " + output };

    var blockEnd = luaText.indexOf("})", outMatch.index);
    if (blockEnd === -1)
        return { text: luaText, ok: false, error: "unterminated block for " + output };

    var head = luaText.slice(0, blockStart);
    var block = luaText.slice(blockStart, blockEnd);
    var tail = luaText.slice(blockEnd);

    var r1 = replaceField(block, "mode", '"' + mode + '"');
    if (!r1.ok)
        return { text: luaText, ok: false, error: "mode field not found for " + output };
    var r2 = replaceField(r1.text, "position", '"' + position + '"');
    if (!r2.ok)
        return { text: luaText, ok: false, error: "position field not found for " + output };
    var r3 = replaceField(r2.text, "scale", String(scale));
    if (!r3.ok)
        return { text: luaText, ok: false, error: "scale field not found for " + output };

    return { text: head + r3.text + tail, ok: true, error: "" };
}

/**
 * Replaces the value of a single `name = <value>` field within a hl.monitor
 * block, preserving the field name, the `=` spacing and any trailing comma. The
 * value run is a complete double-quoted string when the value is quoted (so a
 * comma inside the quotes is not mistaken for the field end), otherwise the run
 * up to the next comma or the block's closing brace. Returns `{ text, ok }`.
 */
function replaceField(block, name, value) {
    var re = new RegExp("(" + name + "\\s*=\\s*)(\"[^\"]*\"|[^,}\\n]*)");
    if (!re.test(block))
        return { text: block, ok: false };
    return { text: block.replace(re, "$1" + value), ok: true };
}

function escapeRe(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}
