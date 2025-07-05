LOWER_NOTCH_HEIGHT = 6.67;
MIDDLE_NOTCH_HEIGHT = 7.8;
UPPER_NOTCH_HEIGHT = 6.45;

NOTCH_WIDTH = 4.91;

RAIL_HEIGHT = LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT + UPPER_NOTCH_HEIGHT;

RAIL_WIDTH = 24.6;

RAIL_LENGTH = 396;

FRONT_LEN = 200;

module cross_section() {
    polygon([
            [0, 0],
            [0, LOWER_NOTCH_HEIGHT],
            [NOTCH_WIDTH, LOWER_NOTCH_HEIGHT],
            [NOTCH_WIDTH, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [0, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [0, RAIL_HEIGHT],
            [RAIL_WIDTH, RAIL_HEIGHT],
            [RAIL_WIDTH, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [RAIL_WIDTH - NOTCH_WIDTH, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [RAIL_WIDTH - NOTCH_WIDTH, LOWER_NOTCH_HEIGHT],
            [RAIL_WIDTH, LOWER_NOTCH_HEIGHT],
            [RAIL_WIDTH, 0],
    ]);
}

//module back_cross_section() {
//    polygon([
//        [NOTCH_WIDTH, 8.15],
//        [NOTCH_WIDTH, 8.15 + 9.8],
//        [RAIL_WIDTH - NOTCH_WIDTH, 8.15 + 9.8],
//        [RAIL_WIDTH - NOTCH_WIDTH, 8.15],
//    ]);
//}

module front_cross_section() {
        polygon([
            [NOTCH_WIDTH, LOWER_NOTCH_HEIGHT],
            [NOTCH_WIDTH, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [0, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [0, RAIL_HEIGHT-3.3],
            [RAIL_WIDTH, RAIL_HEIGHT-3.3],
            [RAIL_WIDTH, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [RAIL_WIDTH - NOTCH_WIDTH, LOWER_NOTCH_HEIGHT + MIDDLE_NOTCH_HEIGHT],
            [RAIL_WIDTH - NOTCH_WIDTH, LOWER_NOTCH_HEIGHT],
    ]);
}


module full_rail() {
    difference() {
        linear_extrude(height=RAIL_LENGTH) {cross_section();};
        color("green") translate([0, RAIL_HEIGHT, 380]) rotate([atan(3.5/14), 0, 0]) cube([RAIL_WIDTH, 10, 30]);
    }
    
    difference() {
        translate([0, 0, -18.76]) linear_extrude(height=18.76) {front_cross_section();};
        color("blue") translate([14, 0, -9.25]) rotate([90, 0, 0]) cylinder(h=50, r=2.5, center=true);
        color("red") translate([-3, 0, -30]) rotate([0, atan(-5/18.76), 0]) cube([10, 20, 30]);
        color("green") translate([RAIL_WIDTH -9, 0, -28]) rotate([0, atan(6/18.76), 0]) cube([10, 20, 30]);
    }
}


module male_peg() {
    z_depth = 19;
    translate([RAIL_WIDTH / 2, RAIL_HEIGHT / 2, FRONT_LEN - z_depth/2]) cube([RAIL_WIDTH - NOTCH_WIDTH*2 - 5 - .2, RAIL_HEIGHT-12 -.2, z_depth], center=true);
}

module female_hole() {
    z_depth = 20;
    translate([RAIL_WIDTH / 2, RAIL_HEIGHT / 2, FRONT_LEN - z_depth/2]) cube([RAIL_WIDTH - NOTCH_WIDTH*2 - 5, RAIL_HEIGHT-12, z_depth], center=true);
}


module back_rail() {
    difference() {
        full_rail();
        translate([0, 0, -40]) color("purple") cube([50, 50, FRONT_LEN + 40]);   
    }
    male_peg();

}

module front_rail() {
    difference() {
        full_rail();
        translate([0, 0, FRONT_LEN]) color("purple") cube([50, 50, 300]);   
        female_hole();

    }

}

//full_rail();
//back_rail();
front_rail();

//difference() {
//color("pink") female_hole();
//color("blue") male_peg();
//}

