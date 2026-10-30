if (wet_timer > 0) wet_timer--;
if (burn_timer > 0) {
    burn_timer--;
    if (burn_timer mod 30 == 0) hp -= 1;   // hoření ubírá život
}

if (flash_timer > 0) {
    flash_timer--;
    image_blend = c_red;
} else if (burn_timer > 0) {
    image_blend = c_orange;
} else if (wet_timer > 0) {
    image_blend = c_aqua;
} else {
    image_blend = c_white;
}

if (hp <= 0) instance_destroy();