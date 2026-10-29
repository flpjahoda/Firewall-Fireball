hp -= 1;
image_blend = c_red;   // krátce zčervená po zásahu
alarm[0] = 5;          // za 5 snímků se vrátí barva
with (other) instance_destroy();   // jiskra zmizí
if (hp <= 0) instance_destroy();   // terč zmizí