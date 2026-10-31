var el = other.element;
var d = other.dmg;
with (other) instance_destroy();

hp -= d;
flash_timer = 5;

switch (el) {
    case "water":
        wet_timer = 300;
        burn_timer = 0;     // voda hasí
        break;
    case "fire":
        if (wet_timer > 0) {
            wet_timer = 0;
            instance_create_layer(x, bbox_top, "Instances", obj_steam);
        } else {
            burn_timer = 180;
        }
        break;
}