if (!instance_exists(owner)) { instance_destroy(); exit; }

// sprej se chrlí i během čekání
if (spray_timer > 0) {
    spray_timer--;
    if (spray_timer mod 2 == 0) {
        var p = instance_create_layer(owner.x + 16 * owner.facing, owner.bbox_bottom - owner.cast_y_offset, "Instances", obj_spark,
            { element: element, dmg: spray_dmg, life: 18 });
        p.direction = (owner.facing == 1 ? 0 : 180) + random_range(-15, 15);
        p.speed = 4 * spray_mult;
        p.image_blend = element_color(element);
        p.image_xscale = 0.6;
        p.image_yscale = 0.6;
    }
}

if (wait_timer > 0) { wait_timer--; exit; }

if (pc >= array_length(blocks)) {
    if (loop) { pc = 0; } else { instance_destroy(); }
    exit;
}

var b = blocks[pc];
pc++;

switch (b.type) {
    case "element":
        element = b.value;
        break;
    case "barrier":
        owner.shield_timer = b.frames;
        break;

    case "shoot":
        var sc = 1 + (mod_dmg - 1) * 0.5;
        var s = instance_create_layer(owner.x + 16 * owner.facing, owner.bbox_bottom - owner.cast_y_offset, "Instances", obj_spark,
            { element: element, dmg: mod_dmg, life: -1 });
        s.hspeed = b.speed * mod_speed * owner.facing;
        s.image_blend = element_color(element);
        s.image_xscale = sc;
        s.image_yscale = sc;
        mod_speed = 1;
        mod_dmg = 1;
        break;

    case "spray":
        spray_timer = b.frames;
        spray_mult = mod_speed;
        spray_dmg = 0.3 * mod_dmg;
        wait_timer = b.frames;
        mod_speed = 1;
        mod_dmg = 1;
        break;

    case "faster":
        mod_speed *= 1.5;
        break;

    case "stronger":
        mod_dmg *= 2;
        break;

    case "wait":
        wait_timer = b.frames;
        break;

    case "dash":
        owner.dash_dir = owner.facing;
        owner.dash_speed = b.speed;
        owner.dash_timer = b.frames;
        wait_timer = b.frames;
        break;

    case "teleport":
        var dist = b.distance;
        with (owner) {
            repeat (dist) {
                if (place_meeting(x + facing, y, obj_wall)) break;
                x += facing;
            }
        }
        break;
}