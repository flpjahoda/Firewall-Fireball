hsp = 0;             // vodorovná rychlost
vsp = 0;             // svislá rychlost
move_speed = 4;      // jak rychle chodí
grav = 0.7;          // gravitace
jump_speed = -13;    // síla skoku (záporná = nahoru)
facing = 1;          // 1 = doprava, -1 = doleva
dash_timer = 0;
dash_dir = 1;
dash_speed = 0;

spells = [
    { key: ord("Q"), loop: false, runner: noone,
      blocks: [ block_element("fire"), block_shoot(6) ] },

    { key: ord("E"), loop: true, runner: noone,
      blocks: [ block_element("water"), block_shoot(5), block_wait(20) ] },

    { key: ord("R"), loop: false, runner: noone,
      blocks: [ block_element("fire"), block_repeat(3, [ block_shoot(6), block_wait(10) ]) ] },

    { key: ord("F"), loop: false, runner: noone,
      blocks: [ block_wait_sec(5), block_dash(8, 10) ] },

    { key: ord("T"), loop: false, runner: noone,
      blocks: [ block_teleport(96) ] }
];