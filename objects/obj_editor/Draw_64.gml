draw_set_color(c_black);
draw_rectangle(0, 0, 640, 360, false);

var f = asset_get_index("fnt_terminal");
if (f != -1) draw_set_font(f);

draw_set_color(c_lime);
draw_rectangle(4, 4, 635, 355, true);
draw_text(16, 8, "SPELL EDITOR   [TAB] zavrit");
draw_text(16, 336, "tahni bloky, klik na cislo = psat");

var sp = global.spells[sel];

for (var i = 0; i < array_length(global.spells); i++) {
    var tx = 16 + i * (tab_w + 4);
    draw_set_color(c_lime);
    if (i == sel) {
        draw_rectangle(tx, tab_y, tx + tab_w, tab_y + row_h, false);
        draw_set_color(c_black);
    } else {
        draw_rectangle(tx, tab_y, tx + tab_w, tab_y + row_h, true);
    }
    draw_text(tx + 6, tab_y + 2, "[" + chr(global.spells[i].key) + "]");
}

draw_set_color(c_lime);
draw_rectangle(16, set_y, 16 + key_w, set_y + row_h, true);
draw_text(22, set_y + 2, rebind ? "stiskni klavesu" : "klavesa [" + chr(sp.key) + "]");

if (sp.loop) {
    draw_rectangle(mode_x, set_y, mode_x + mode_w, set_y + row_h, false);
    draw_set_color(c_black);
} else {
    draw_rectangle(mode_x, set_y, mode_x + mode_w, set_y + row_h, true);
}
draw_text(mode_x + 6, set_y + 2, sp.loop ? "loop" : "once");

var rows = layout_rows(blocks_to_rows(sp, "blocks", 0), blk_x, blk_y, row_h);
for (var j = 0; j < array_length(rows); j++) {
    var r = rows[j];
    draw_set_color(block_color(r.type));
    draw_rectangle(r.x, r.y, r.x + blk_w, r.y + r.h, false);
    if (r.is_end) {
        draw_rectangle(r.x, r.strip_y, r.x + 12, r.y, false);
    } else {
        var editing = (!is_undefined(edit_blk) && r.blk == edit_blk);
        var cursor = (editing && ((current_time div 400) mod 2 == 0)) ? "_" : "";
        draw_set_color(c_black);
        draw_text(r.x + 4, r.y + 2, r.text + cursor);
        if (editing) {
            draw_set_color(c_white);
            draw_rectangle(r.x, r.y, r.x + blk_w, r.y + r.h, true);
        }
    }
}

for (var k = 0; k < array_length(palette); k++) {
    var py = pal_y + k * (row_h + 2);
    draw_set_color(block_color(palette[k].type));
    draw_rectangle(pal_x, py, pal_x + pal_w, py + row_h, false);
    draw_set_color(c_black);
    draw_text(pal_x + 4, py + 2, palette[k].label);
}

if (!is_undefined(drag)) {
    var gx = device_mouse_x_to_gui(0);
    var gy = device_mouse_y_to_gui(0);

    if (gx < pal_x - 5 && gy >= blk_y - 12 && !is_undefined(hover_slot)) {
        draw_set_color(c_white);
        draw_line_width(hover_slot.x, hover_slot.y, hover_slot.x + blk_w, hover_slot.y, 2);
    }

    draw_set_alpha(0.85);
    draw_set_color(block_color(drag.blk.type));
    draw_rectangle(gx - 20, gy - row_h / 2, gx + 150, gy + row_h / 2, false);
    draw_set_color(c_black);
    draw_text(gx - 16, gy - row_h / 2 + 2, block_to_text(drag.blk));
    draw_set_alpha(1);
}

if (debug) {
    draw_set_color(c_white);
    draw_text(16, 310, "mx " + string(device_mouse_x_to_gui(0)) + "  my " + string(device_mouse_y_to_gui(0)) + "  drag " + string(!is_undefined(drag)));
}

draw_set_color(c_white);
draw_set_font(-1);