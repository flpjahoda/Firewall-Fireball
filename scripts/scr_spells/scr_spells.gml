function block_element(_el)  { return { type: "element", value: _el }; }
function block_shoot(_speed) { return { type: "shoot", speed: _speed }; }
function block_wait(_frames) { return { type: "wait", frames: _frames }; }

function element_color(_el) {
    switch (_el) {
        case "fire":  return c_orange;
        case "water": return c_aqua;
        default:      return c_yellow;
    }
}
function block_repeat(_times, _body) { return { type: "repeat", times: _times, body: _body }; }

// rozbalí "Opakuj" na obyčejný plochý seznam bloků
function flatten_blocks(_blocks) {
    var out = [];
    for (var i = 0; i < array_length(_blocks); i++) {
        var b = _blocks[i];
        if (b.type == "repeat") {
            var inner = flatten_blocks(b.body);
            var times = min(b.times, 100);   // pojistka proti obřím smyčkám
            for (var t = 0; t < times; t++) {
                for (var j = 0; j < array_length(inner); j++) {
                    array_push(out, inner[j]);
                }
            }
        } else {
            array_push(out, b);
        }
    }
    return out;
}
function block_dash(_frames, _speed) { return { type: "dash", frames: _frames, speed: _speed }; }
function block_teleport(_distance)   { return { type: "teleport", distance: _distance }; }
function block_wait_sec(_seconds)    { return block_wait(_seconds * game_get_speed(gamespeed_fps)); }
function block_spray(_frames) { return { type: "spray", frames: _frames }; }
function block_faster()       { return { type: "faster" }; }
function block_stronger()     { return { type: "stronger" }; }
function block_barrier(_frames) { return { type: "barrier", frames: _frames }; }




function block_color(_type) {
    switch (_type) {
        case "element":
            return make_color_rgb(232, 116, 42);
        case "shoot":
        case "spray":
        case "dash":
        case "teleport":
        case "barrier":
            return make_color_rgb(59, 141, 224);
        case "wait":
        case "repeat":
            return make_color_rgb(230, 194, 41);
        case "faster":
        case "stronger":
            return make_color_rgb(160, 107, 224);
    }
    return c_gray;
}



function array_with(_arr, _item) {
    var out = [];
    for (var i = 0; i < array_length(_arr); i++) array_push(out, _arr[i]);
    array_push(out, _item);
    return out;
}

function array_without(_arr, _idx) {
    var out = [];
    for (var i = 0; i < array_length(_arr); i++) {
        if (i != _idx) array_push(out, _arr[i]);
    }
    return out;
}

function make_block(_id) {
    switch (_id) {
        case "fire":     return block_element("fire");
        case "water":    return block_element("water");
        case "shoot":    return block_shoot(6);
        case "spray":    return block_spray(30);
        case "dash":     return block_dash(8, 10);
        case "teleport": return block_teleport(96);
        case "barrier":  return block_barrier(120);
        case "wait":     return block_wait(20);
        case "repeat":   return block_repeat(3, []);
        case "faster":   return block_faster();
        case "stronger": return block_stronger();
    }
	
}
function array_insert_at(_arr, _idx, _item) {
    var out = [];
    for (var i = 0; i < array_length(_arr); i++) {
        if (i == _idx) array_push(out, _item);
        array_push(out, _arr[i]);
    }
    if (_idx >= array_length(_arr)) array_push(out, _item);
    return out;
}

function layout_rows(_rows, _x0, _y0, _rh) {
    var cy = _y0;
    var stk = [];
    for (var i = 0; i < array_length(_rows); i++) {
        var r = _rows[i];
        r.x = _x0 + r.indent * 16;
        if (r.type == "repeat" && !r.is_end) {
            array_push(stk, i);
        }
        if (r.is_end) {
            if (array_length(r.blk.body) == 0) y += _rh + 2;
            r.h = 8;
            var hi = array_pop(stk);
            r.strip_y = _rows[hi].y + _rows[hi].h;
        } else {
            r.h = _rh;
        }
        r.y = y;
        y += r.h + 2;
    }
    return _rows;
}

function build_slots(_sp, _rows, _x0, _y0, _rh) {
    var out = [];
    var bottom = _y0;
    for (var i = 0; i < array_length(_rows); i++) {
        var r = _rows[i];
        if (r.is_end) {
            var iy = (array_length(r.blk.body) == 0) ? r.y - _rh / 2 - 2 : r.y - 1;
            array_push(out, { owner: r.blk, field: "body", idx: array_length(r.blk.body), x: r.x + 16, y: iy });
        } else {
            array_push(out, { owner: r.owner, field: r.field, idx: r.idx, x: r.x, y: r.y - 1 });
        }
        bottom = r.y + r.h + 1;
    }
    array_push(out, { owner: _sp, field: "blocks", idx: array_length(_sp.blocks), x: _x0, y: bottom });
    return out;
}

function block_has_val(_type) {
    return (_type == "repeat" || _type == "wait" || _type == "spray" || _type == "teleport");
}

function block_get_val(_b) {
    var fps = game_get_speed(gamespeed_fps);
    switch (_b.type) {
        case "repeat":   return _b.times;
        case "wait":     return round(_b.frames * 10 / fps);
        case "spray":    return round(_b.frames * 10 / fps);
        case "teleport": return round(_b.distance / 16);
    }
    return 0;
}

function block_set_val(_b, _v) {
    var fps = game_get_speed(gamespeed_fps);
    var v = clamp(_v, 1, 99);
    switch (_b.type) {
        case "repeat":   _b.times = v; break;
        case "wait":     _b.frames = round(v * fps / 10); break;
        case "spray":    _b.frames = round(v * fps / 10); break;
        case "teleport": _b.distance = v * 16; break;
    }
}

function block_to_text(_b) {
    switch (_b.type) {
        case "element":
            if (_b.value == "fire")  return "ohen";
            if (_b.value == "water") return "voda";
            return _b.value;
        case "shoot":    return "strela " + string(_b.speed);
        case "spray":    return "sprej " + string(block_get_val(_b) / 10) + "s";
        case "wait":     return "pockej " + string(block_get_val(_b) / 10) + "s";
        case "dash":     return "dash";
        case "teleport": return "teleport " + string(block_get_val(_b));
        case "barrier":  return "bariera";
        case "faster":   return "rychleji";
        case "stronger": return "silneji";
        case "repeat":   return "opakuj " + string(_b.times) + "x";
    }
    return _b.type;
}

function blocks_to_rows(_owner, _field, _indent) {
    var out = [];
    var blocks = _owner[$ _field];
    for (var i = 0; i < array_length(blocks); i++) {
        var b = blocks[i];
        array_push(out, { text: block_to_text(b), type: b.type, indent: _indent, blk: b, owner: _owner, field: _field, idx: i, is_end: false });
        if (b.type == "repeat") {
            var inner = blocks_to_rows(b, "body", _indent + 1);
            for (var j = 0; j < array_length(inner); j++) array_push(out, inner[j]);
            array_push(out, { text: "", type: "repeat", indent: _indent, blk: b, owner: _owner, field: _field, idx: i, is_end: true });
        }
    }
    return out;
}

function count_blocks(_blocks) {
    var c = 0;
    for (var i = 0; i < array_length(_blocks); i++) {
        c++;
        if (_blocks[i].type == "repeat") c += count_blocks(_blocks[i].body);
    }
    return c;
}