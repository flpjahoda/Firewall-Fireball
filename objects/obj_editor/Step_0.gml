age++;
var n = array_length(global.spells);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);

if (keyboard_check_pressed(vk_f2)) debug = !debug;

var sp = global.spells[sel];
var rows = layout_rows(blocks_to_rows(sp, "blocks", 0), blk_x, blk_y, row_h);
var slots = build_slots(sp, rows, blk_x, blk_y, row_h);

// psani hodnoty do bloku
if (!is_undefined(edit_blk)) {
    for (var dg = 0; dg <= 9; dg++) {
        if (keyboard_check_pressed(ord("0") + dg) || keyboard_check_pressed(vk_numpad0 + dg)) {
            if (string_length(edit_buf) < 2) edit_buf += string(dg);
            block_set_val(edit_blk, real(edit_buf));
        }
    }
    if (keyboard_check_pressed(vk_backspace) && string_length(edit_buf) > 0) {
        edit_buf = string_delete(edit_buf, string_length(edit_buf), 1);
        if (edit_buf != "") block_set_val(edit_blk, real(edit_buf));
    }
    if (keyboard_check_pressed(vk_enter)) edit_blk = undefined;
}

// prirazeni klavesy
if (rebind && keyboard_check_pressed(vk_anykey)) {
    var kk = keyboard_lastkey;
    if (kk == vk_escape) {
        rebind = false;
    } else {
        var ok = ((kk >= ord("A") && kk <= ord("Z")) || (kk >= ord("0") && kk <= ord("9")));
        if (kk == ord("A") || kk == ord("D")) ok = false;
        for (var u = 0; u < n; u++) {
            if (u != sel && global.spells[u].key == kk) ok = false;
        }
        if (ok) { sp.key = kk; rebind = false; }
    }
}

if (is_undefined(drag)) {
    if (click) {
        if (rebind) {
            rebind = false;
        } else {
            edit_blk = undefined;

            for (var i = 0; i < n; i++) {
                var tx = 16 + i * (tab_w + 4);
                if (mx >= tx && mx < tx + tab_w && my >= tab_y && my < tab_y + row_h) sel = i;
            }

            if (mx >= 16 && mx < 16 + key_w && my >= set_y && my < set_y + row_h) {
                rebind = true;
                keyboard_lastkey = 0;
            }

            if (mx >= mode_x && mx < mode_x + mode_w && my >= set_y && my < set_y + row_h) {
                sp.loop = !sp.loop;
            }

            for (var k = 0; k < array_length(palette); k++) {
                var py = pal_y + k * (row_h + 2);
                if (mx >= pal_x && mx < pal_x + pal_w && my >= py && my < py + row_h) {
                    drag = { blk: make_block(palette[k].id), origin: undefined, sx: mx, sy: my };
                }
            }

            for (var j = 0; j < array_length(rows); j++) {
                var r = rows[j];
                if (!r.is_end && mx >= r.x && mx < r.x + blk_w && my >= r.y && my < r.y + r.h) {
                    drag = { blk: r.blk, origin: { owner: r.owner, field: r.field, idx: r.idx }, sx: mx, sy: my };
                    r.owner[$ r.field] = array_without(r.owner[$ r.field], r.idx);
                    break;
                }
            }
        }
    }
} else {
    hover_slot = undefined;
    var bd = 1000000;
    for (var q = 0; q < array_length(slots); q++) {
        var d = abs(my - slots[q].y) + abs(mx - slots[q].x) * 0.3;
        if (d < bd) { bd = d; hover_slot = slots[q]; }
    }

    if (!mouse_check_button(mb_left)) {
        var moved = (point_distance(drag.sx, drag.sy, mx, my) > 4);
        var is_new = is_undefined(drag.origin);
        var can_add = (count_blocks(sp.blocks) < 12);

        if (!moved && !is_new) {
            var o1 = drag.origin;
            o1.owner[$ o1.field] = array_insert_at(o1.owner[$ o1.field], o1.idx, drag.blk);
            if (block_has_val(drag.blk.type)) { edit_blk = drag.blk; edit_buf = ""; }
        } else if (!moved && is_new) {
            if (can_add) sp.blocks = array_with(sp.blocks, drag.blk);
        } else if (mx >= pal_x - 5) {
            // pusteno nad paletou: smazat
        } else if (my >= blk_y - 12 && !is_undefined(hover_slot)
                   && !(drag.blk.type == "repeat" && hover_slot.field == "body")
                   && (!is_new || can_add)) {
            hover_slot.owner[$ hover_slot.field] = array_insert_at(hover_slot.owner[$ hover_slot.field], hover_slot.idx, drag.blk);
        } else if (!is_new) {
            var o2 = drag.origin;
            o2.owner[$ o2.field] = array_insert_at(o2.owner[$ o2.field], o2.idx, drag.blk);
        }

        drag = undefined;
        hover_slot = undefined;
    }
}

if (age > 3 && is_undefined(drag) && !rebind && keyboard_check_pressed(vk_tab)) {
    instance_activate_all();
    with (obj_wizard) editor_cd = 10;
    instance_destroy();
}