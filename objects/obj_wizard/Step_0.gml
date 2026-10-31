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

// dash přebije chůzi i gravitaci
if (dash_timer > 0) {
    hsp = dash_dir * dash_speed;
    vsp = 0;
    dash_timer--;
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

if (editor_cd > 0) editor_cd--;

// otevření editoru
if (keyboard_check_pressed(vk_tab) && editor_cd <= 0 && !instance_exists(obj_editor)) {
    instance_create_layer(0, 0, "Instances", obj_editor);
}

// spelly na klávesy
for (var i = 0; i < array_length(global.spells); i++) {
    var sp = global.spells[i];
    if (keyboard_check_pressed(sp.key)) {
        if (sp.loop && instance_exists(sp.runner)) {
            instance_destroy(sp.runner);
            sp.runner = noone;
        } else {
            sp.runner = instance_create_layer(x, y, "Instances", obj_spell_runner,
                { owner: id, blocks: sp.blocks, loop: sp.loop });
        }
    }
}
if (invuln > 0) invuln--;
if (shield_timer > 0) shield_timer--;

if (place_meeting(x, y, obj_enemy) && invuln <= 0 && shield_timer <= 0) {
    hp -= 1;
    invuln = 60;
}

image_alpha = (invuln > 0 && (invuln div 4) mod 2 == 0) ? 0.4 : 1;

if (hp <= 0) room_restart();
