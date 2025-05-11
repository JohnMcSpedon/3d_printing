MAIN_DIAMETER = 60.8;
TRIANGLE_SIDE_LEN = 43.5;

SMALL_HEX_DIAMETER = 6.6; // v1: 6.5
SMALL_HEX_HEIGHT = 2.5;
SMALL_HEX_SHAFT_DIAMETER = 3.4; // v1: 3

LARGE_HEX_DIAMETER = 12.7;  // v1: 12.4
LARGE_HEX_HEIGHT = 5.5;
LARGE_HEX_SHAFT_DIAMETER = 7.4;

FLOOR_HEIGHT = 1.5; // v1: 2
EPS = 0.01;

$fn=1000;


module main_bolt_hole() {
    translate([0, 0, FLOOR_HEIGHT]) {
        linear_extrude(height=LARGE_HEX_HEIGHT + EPS) {
            circle(r=LARGE_HEX_DIAMETER/2, $fn=6);
        }
    }
    translate([0, 0, -1 * EPS]) {
        cylinder(FLOOR_HEIGHT + LARGE_HEX_HEIGHT + 2*EPS, r=LARGE_HEX_SHAFT_DIAMETER/2);
    }
}

module m3_nut_hole() {
    translate([0, 0, -EPS]) {
        linear_extrude(height=SMALL_HEX_HEIGHT + EPS) {
            circle(r=SMALL_HEX_DIAMETER/2, $fn=6);
        }
    }
    cylinder(FLOOR_HEIGHT + LARGE_HEX_HEIGHT + 2*EPS, r=SMALL_HEX_SHAFT_DIAMETER/2);
}

difference() {
    cylinder(FLOOR_HEIGHT + LARGE_HEX_HEIGHT, r=MAIN_DIAMETER/2);
    color("blue") main_bolt_hole();
    for(i=[0:3]) {
        rotate([0, 0, i*120]) {
            translate([TRIANGLE_SIDE_LEN / (2 * cos(30)), 0, 0]) {
                color("red") m3_nut_hole();
            }
        }
    }
}