event_inherited();

// gravitace
vsp += 0.5;
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// pohyb za wizardem
var dx = 0;
if (instance_exists(obj_wizard)) {
    if (abs(obj_wizard.x - x) > 4) dx = sign(obj_wizard.x - x);
}

if (dx != 0) {
    dir = dx;
    if (!place_meeting(x + dir * move_speed, y, obj_wall)) {
        x += dir * move_speed;
    }
}
image_xscale = dir;