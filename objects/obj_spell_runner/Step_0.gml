if (!instance_exists(owner)) { instance_destroy(); exit; }
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
    case "shoot":
        var s = instance_create_layer(owner.x + 16 * owner.facing, (owner.bbox_top + owner.bbox_bottom) / 2, "Instances", obj_spark);
        s.hspeed = b.speed * owner.facing;
        s.element = element;
        s.image_blend = element_color(element);
        break;
    case "wait":
        wait_timer = b.frames;
        break;
}