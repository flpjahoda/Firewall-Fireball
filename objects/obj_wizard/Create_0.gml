hsp = 0;
vsp = 0;
move_speed = 4;
grav = 0.7;
jump_speed = -13;
facing = 1;
dash_timer = 0;
dash_dir = 1;
dash_speed = 0;
cast_y_offset = 14;
hp = 5;
invuln = 0;
shield_timer = 0;
editor_cd = 0;

if (!variable_global_exists("spells")) {
    global.spells = [
        { key: ord("Q"), loop: false, runner: noone,
          blocks: [ block_element("fire"), block_shoot(6) ] },

        { key: ord("E"), loop: true, runner: noone,
          blocks: [ block_element("water"), block_shoot(5), block_wait(20) ] },

        { key: ord("R"), loop: false, runner: noone,
          blocks: [ block_element("fire"), block_repeat(3, [ block_shoot(6), block_wait(10) ]) ] },

        { key: ord("F"), loop: false, runner: noone,
          blocks: [ block_wait_sec(5), block_dash(8, 10) ] },

        { key: ord("T"), loop: false, runner: noone,
          blocks: [ block_teleport(96) ] },

        { key: ord("Z"), loop: false, runner: noone,
          blocks: [ block_element("fire"), block_spray(30) ] },

        { key: ord("X"), loop: false, runner: noone,
          blocks: [ block_element("water"), block_stronger(), block_shoot(5) ] },

        { key: ord("V"), loop: false, runner: noone,
          blocks: [ block_barrier(120) ] }
    ];
}