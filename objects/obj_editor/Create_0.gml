instance_deactivate_all(true);
display_set_gui_size(640, 360);

sel = 0;
age = 0;
drag = undefined;
hover_slot = undefined;
edit_blk = undefined;
edit_buf = "";
rebind = false;
debug = false;

var f = asset_get_index("fnt_terminal");
if (f != -1) draw_set_font(f);
row_h = string_height("M") + 4;
cw = string_width("M");
draw_set_font(-1);

tab_y = 34;
tab_w = cw * 3 + 14;
set_y = tab_y + row_h + 6;
key_w = cw * 17 + 10;
mode_x = 16 + key_w + 10;
mode_w = cw * 6 + 10;
blk_x = 16;
blk_y = set_y + row_h + 12;
blk_w = 220;
pal_x = 470;
pal_w = 150;
pal_y = 34;

palette = [
    { label: "ohen",     id: "fire",     type: "element" },
    { label: "voda",     id: "water",    type: "element" },
    { label: "strela",   id: "shoot",    type: "shoot" },
    { label: "sprej",    id: "spray",    type: "spray" },
    { label: "dash",     id: "dash",     type: "dash" },
    { label: "teleport", id: "teleport", type: "teleport" },
    { label: "bariera",  id: "barrier",  type: "barrier" },
    { label: "pockej",   id: "wait",     type: "wait" },
    { label: "opakuj",   id: "repeat",   type: "repeat" },
    { label: "rychleji", id: "faster",   type: "faster" },
    { label: "silneji",  id: "stronger", type: "stronger" }
];