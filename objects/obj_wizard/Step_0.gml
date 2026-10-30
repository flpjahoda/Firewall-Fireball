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
for (var i = 0; i < array_length(spells); i++) {
    var sp = spells[i];
    if (keyboard_check_pressed(sp.key)) {
        if (sp.loop && instance_exists(sp.runner)) {
            instance_destroy(sp.runner);   // druhé stisknutí smyčku zastaví
            sp.runner = noone;
        } else {
            sp.runner = instance_create_layer(x, y, "Instances", obj_spell_runner,
                { owner: id, blocks: sp.blocks, loop: sp.loop });
        }
    }
}