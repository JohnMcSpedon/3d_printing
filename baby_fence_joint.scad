POLE_DIAMETER = 14;
FENCE_HEIGHT=21.6;
FENCE_DEPTH=20;
FENCE_LENGTH = 50; //open ended
WALL_THICKNESS = 4;

TOTAL_HEIGHT = FENCE_HEIGHT + WALL_THICKNESS;
TOTAL_DEPTH = FENCE_DEPTH+2*WALL_THICKNESS;

CUT_DEPTH = 10;

$fn=50;


module fence_section() {
    difference() {
        cube([FENCE_LENGTH, TOTAL_DEPTH, TOTAL_HEIGHT]);
        translate([WALL_THICKNESS, WALL_THICKNESS, WALL_THICKNESS]){
            cube([FENCE_LENGTH - WALL_THICKNESS, FENCE_DEPTH, FENCE_HEIGHT]);
        }
    }
}

//fence_section();

module pole_section() {
    difference() {
        cylinder(h=TOTAL_HEIGHT, r=TOTAL_DEPTH/2);
        color("blue") cylinder(h=TOTAL_HEIGHT, r=POLE_DIAMETER/2, center=false);
    }

}


difference() {
    union() {
        fence_section();
        translate([0, TOTAL_DEPTH/2, 0]) {
            pole_section();
        }
    }
    // delete pole 2nd time so it passes through fence section
    translate([0, TOTAL_DEPTH/2, 0]) {
        color("blue") cylinder(h=TOTAL_HEIGHT, r=POLE_DIAMETER/2, center=false);
    }
    translate([0, TOTAL_DEPTH/2 - CUT_DEPTH/2, 0]) {
        color("pink") cube([FENCE_LENGTH, CUT_DEPTH, TOTAL_HEIGHT]);
    }
    color("green") translate([FENCE_LENGTH-15, TOTAL_DEPTH, TOTAL_HEIGHT/2]) rotate([90, 0, 0]) cylinder(h=TOTAL_DEPTH, r=2.5, center=false);
    // delete interior fence section 2nd time so part is more flexible
    translate([WALL_THICKNESS*2, WALL_THICKNESS, WALL_THICKNESS]){
        cube([FENCE_LENGTH - WALL_THICKNESS, FENCE_DEPTH, FENCE_HEIGHT]);
    }
}



