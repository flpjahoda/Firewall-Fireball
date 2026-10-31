if (!instance_exists(obj_wizard)) exit;

var cam = view_camera[0];
var cw = camera_get_view_width(cam);
var ch = camera_get_view_height(cam);

var tx = obj_wizard.x - cw / 2;
var ty = obj_wizard.y - ch / 2 - 20;

var cx = lerp(camera_get_view_x(cam), tx, 0.12);
var cy = lerp(camera_get_view_y(cam), ty, 0.12);

cx = clamp(cx, 0, room_width - cw);
cy = clamp(cy, 0, room_height - ch);

camera_set_view_pos(cam, round(cx), round(cy));