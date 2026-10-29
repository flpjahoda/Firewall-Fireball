// pohyb doleva/doprava (A a D)
var dir = keyboard_check(ord("D")) - keyboard_check(ord("A"));
if (dir != 0) facing = dir;
image_xscale = facing;
hsp = dir * move_speed;

// gravitace
vsp += grav;

// skok, jen když stojíme na zemi
if (place_meeting(x, y + 1, obj_wall) && keyboard_check_pressed(vk_space)) {
    vsp = jump_speed;
}

// kolize vodorovně
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// kolize svisle
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;
// kouzlo na klávesu Q
if (keyboard_check_pressed(ord("Q"))) {
    var spawn_x = x + 16 * facing;                 // kousek před wizardem
    var spawn_y = (bbox_top + bbox_bottom) / 2;    // střed těla
    var s = instance_create_layer(spawn_x, spawn_y, "Instances", obj_spark);
    s.hspeed = 6 * facing;
}