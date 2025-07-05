RAIL_WIDTH_EXP = 28;
RAIL_HEIGHT_EXP = 8.5;


OVERHANG_WIDTH = 4;
OVERHANG_HEIGHT = 3;

BOTTOM_WIDTH = RAIL_WIDTH_EXP + 10;

SLIDER_WIDTH = 62;
BACK_HEIGHT = 35;

DEPTH = 12.5;

$fn=100;

module outer_cross_section() {
    polygon([
        [RAIL_WIDTH_EXP / 2, 0],
        [RAIL_WIDTH_EXP / 2, -RAIL_HEIGHT_EXP],
        [RAIL_WIDTH_EXP / 2 - OVERHANG_WIDTH, -RAIL_HEIGHT_EXP],
        [RAIL_WIDTH_EXP / 2 - OVERHANG_WIDTH, -RAIL_HEIGHT_EXP - OVERHANG_HEIGHT],
        [RAIL_WIDTH_EXP / 2 - OVERHANG_WIDTH, -RAIL_HEIGHT_EXP - OVERHANG_HEIGHT],
        [BOTTOM_WIDTH / 2, -RAIL_HEIGHT_EXP - OVERHANG_HEIGHT],
        [SLIDER_WIDTH / 2, 10],
        [SLIDER_WIDTH / 2, BACK_HEIGHT],
        // Left half (reflected points in reverse order)
        [-SLIDER_WIDTH / 2, BACK_HEIGHT],
        [-SLIDER_WIDTH / 2, 10],
        [-BOTTOM_WIDTH / 2, -RAIL_HEIGHT_EXP - OVERHANG_HEIGHT],
        [-RAIL_WIDTH_EXP / 2 + OVERHANG_WIDTH, -RAIL_HEIGHT_EXP - OVERHANG_HEIGHT],
        [-RAIL_WIDTH_EXP / 2 + OVERHANG_WIDTH, -RAIL_HEIGHT_EXP - OVERHANG_HEIGHT],
        [-RAIL_WIDTH_EXP / 2 + OVERHANG_WIDTH, -RAIL_HEIGHT_EXP],
        [-RAIL_WIDTH_EXP / 2, -RAIL_HEIGHT_EXP],
        [-RAIL_WIDTH_EXP / 2, 0]
    ]);
}

module slat_cross_section() {
    slat_v_offset = 2.14;
    slat_height = 6.5;
    slat_width = 30;
    polygon([
        [slat_width / 2, slat_v_offset],
        [slat_width / 2, slat_v_offset + slat_height],
        [-slat_width / 2, slat_v_offset + slat_height],
        [-slat_width / 2, slat_v_offset],
    ]);
}


module screw_hole() {
    translate([0, 0, 5]) cylinder(h=DEPTH, r=2.5, center=true);
    cylinder(h=DEPTH, r=1, center=true);
}
        

difference() {
    linear_extrude(height=DEPTH) {outer_cross_section();};
    linear_extrude(height=DEPTH) {slat_cross_section();};
    color("blue") {translate([0, 16, DEPTH/2]) screw_hole();};
    color("blue") {translate([-20, 25, DEPTH/2]) screw_hole();};
    color("blue") {translate([20, 25, DEPTH/2]) screw_hole();};
}

        
//color("blue") {translate([0, 15, DEPTH/2]) screw_hole();};