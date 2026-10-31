draw_self();

if (shield_timer > 0) {
    draw_set_alpha(0.35);
    draw_set_color(c_aqua);
    draw_circle(x, (bbox_top + bbox_bottom) / 2, 22, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

draw_text(x - 8, bbox_top - 14, "HP " + string(hp));